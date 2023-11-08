
--boundary_.oOo._4RMe2iHRhTMuQmG37evsw9LMGjqgFirj
Content-Length: 28868
Content-Type: application/octet-stream
X-File-MD5: 9c4251574c8c9e470628a1eb65565004
X-File-Mtime: 1698902547
X-File-Path: /@Life/Documents/GitHub/chadgoode.github.io/vendor/bundle/gems/dnsruby-1.61.9/lib/dnsruby/select_thread.rb

# --
# Copyright 2007 Nominet UK
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ++
require 'socket'
# require 'thread'
begin
  require 'fastthread'
rescue LoadError
  require 'thread'
end
require 'set'
require 'singleton'
require 'dnsruby/validator_thread.rb'
module Dnsruby
  class SelectThread #:nodoc: all
    class SelectWakeup < RuntimeError; end
    include Singleton
    #  This singleton class runs a continuous select loop which
    #  listens for responses on all of the in-use sockets.
    #  When a new query is sent, the thread is woken up, and
    #  the socket is added to the select loop (and the new timeout
    #  calculated).
    #  Note that a combination of the socket and the packet ID is
    #  sufficient to uniquely identify the query to the select thread.
    # 
    #  But how do we find the response queue for a particular query?
    #  Hash of client_id->[query, client_queue, socket]
    #  and socket->[client_id]
    # 
    #  @todo@ should we implement some of cancel function?

    def initialize
      @@mutex = Mutex.new
      @@mutex.synchronize {
        @@in_select=false
        #         @@notifier,@@notified=IO.pipe
        @@sockets = Set.new
        @@timeouts = Hash.new
        #     @@mutex.synchronize do
        @@query_hash = Hash.new
        @@socket_hash = Hash.new
        @@socket_is_persistent = Hash.new
        @@observers = Hash.new
        @@tcp_buffers=Hash.new
        @@socket_remaining_queries = Hash.new
        @@tick_observers = []
        @@queued_exceptions=[]
        @@queued_responses=[]
        @@queued_validation_responses=[]
        @@wakeup_sockets = get_socket_pair
        @@sockets << @@wakeup_sockets[1]

        #  Suppress reverse lookups
        BasicSocket.do_not_reverse_lookup = true
        #     end
        #  Now start the select thread
        @@select_thread = Thread.new { do_select }

        #         # Start the validator thread
        #         @@validator = ValidatorThread.instance
      }
    end

    def get_socket_pair
      #  Emulate socketpair on platforms which don't support it
      srv = nil
      begin
        srv = TCPServer.new('localhost', 0)
      rescue Errno::EADDRNOTAVAIL, SocketError # OSX Snow Leopard issue - need to use explicit IP
        begin
          srv = TCPServer.new('127.0.0.1', 0)
        rescue Error # Try IPv6
          srv = TCPServer.new('::1', 0)
        end
      end
      rsock = TCPSocket.new(srv.addr[3], srv.addr[1])
      lsock = srv.accept
      srv.close
      return [lsock, rsock]
    end

    class QuerySettings
      attr_accessor :query_bytes, :query, :ignore_truncation, :client_queue,
        :client_query_id, :socket, :dest_server, :dest_port, :endtime, :udp_packet_size,
        :single_resolver, :is_persistent_socket, :tcp_pipelining_max_queries
      #  new(query_bytes, query, ignore_truncation, client_queue, client_query_id,
      #      socket, dest_server, dest_port, endtime, , udp_packet_size, single_resolver)
      def initialize(*args)
        @query_bytes = args[0]
        @query = args[1]
        @ignore_truncation=args[2]
        @client_queue = args[3]
        @client_query_id = args[4]
        @socket = args[5]
        @dest_server = args[6]
        @dest_port=args[7]
        @endtime = args[8]
        @udp_packet_size = args[9]
        @single_resolver = args[10]
        @is_persistent_socket = false
        @tcp_pipelining_max_queries = nil
      end
    end

    def tcp?(socket)
      type = socket.getsockopt(Socket::SOL_SOCKET, Socket::SO_TYPE)
      [Socket::SOCK_STREAM].pack("i") == type.data
    end

    def udp?(socket)
      type = socket.getsockopt(Socket::SOL_SOCKET, Socket::SO_TYPE)
      [Socket::SOCK_DGRAM].pack("i") == type.data
    end

    def add_to_select(query_settings)
      #  Add the query to sockets, and then wake the select thread up
      @@mutex.synchronize {
        check_select_thread_synchronized
        #  @TODO@ This assumes that all client_query_ids are unique!
        #  Would be a good idea at least to check this...
        @@query_hash[query_settings.client_query_id]=query_settings
        @@socket_hash[query_settings.socket] ||= []
        @@socket_hash[query_settings.socket] << query_settings.client_query_id
        @@socket_remaining_queries[query_settings.socket] ||= query_settings.tcp_pipelining_max_queries if query_settings.tcp_pipelining_max_queries != :infinite
        @@timeouts[query_settings.client_query_id]=query_settings.endtime
        @@sockets << query_settings.socket
        @@socket_is_persistent[query_settings.socket] = query_settings.is_persistent_socket
      }
      begin
        @@wakeup_sockets[0].send("wakeup!", 0)
      rescue Exception
        #          do nothing
      end
    end

    def check_select_thread_synchronized
      if (!@@select_thread.alive?)
        Dnsruby.log.debug{"Restarting select thread"}
        @@select_thread = Thread.new {
          do_select
        }
      end
    end

    def select_thread_alive?
      ret=true
      @@mutex.synchronize{
        ret = @@select_thread.alive?
      }
      return ret
    end

    def do_select
      unused_loop_count = 0
      last_tick_time = Time.now - 10
      while true do
        if (last_tick_time < (Time.now - 0.5))
          send_tick_to_observers # ONLY NEED TO SEND THIS TWICE A SECOND - NOT EVERY SELECT!!!
          last_tick_time = Time.now
        end
        send_queued_exceptions
        send_queued_responses
        send_queued_validation_responses
        timeout = tick_time = 0.1 # We provide a timer service to various Dnsruby classes
        sockets, timeouts, has_observer = @@mutex.synchronize { [@@sockets.to_a, @@timeouts.values, !@@observers.empty?] }
        if (timeouts.length > 0)
          timeouts.sort!
          timeout = timeouts[0] - Time.now
          if (timeout <= 0)
            process_timeouts
            timeout = 0
            next
          end
        end
        ready=nil
        if (has_observer && (timeout > tick_time))
          timeout = tick_time
        end
        #         next if (timeout < 0)
        begin
          ready, _write, _errors = IO.select(sockets, nil, nil, timeout)
        rescue SelectWakeup
          #  If SelectWakeup, then just restart this loop - the select call will be made with the new data
          next
        rescue IOError, EncodeError
          exceptions = clean_up_closed_sockets
          exceptions.each { |exception| send_exception_to_client(*exception) }

          next
        end
        if ready && ready.include?(@@wakeup_sockets[1])
          ready.delete(@@wakeup_sockets[1])
          wakeup_msg = "loop"
          begin
            while wakeup_msg && wakeup_msg.length > 0
              wakeup_msg = @@wakeup_sockets[1].recv_nonblock(20)
            end
          rescue
            #  do nothing
          end
        end
        if (ready == nil)
          #  process the timeouts
          process_timeouts
          unused_loop_count+=1
        else
          process_ready(ready)
          unused_loop_count=0
          # process_error(errors)
        end
        @@mutex.synchronize do
          if (unused_loop_count > 10 && @@query_hash.empty? && @@observers.empty?)
            Dnsruby.log.debug("Try stop select loop")

            non_persistent_sockets = @@sockets.select { |s| ! @@socket_is_persistent[s]