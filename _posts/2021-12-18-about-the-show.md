---
layout: single
title: "All About the Show"
last_modified_at: 2022-09-24
categories: projects lightshow
tags: Christmas Halloween HomeAssistant
header:
  overlay_image: /assets/images/posts/2021-12-18/banner-all-about-the-show.jpg
  overlay_filter: 0.5
  teaser: /assets/images/posts/2021-12-18/teaser-all-about-the-show.jpg
excerpt: Probably more than you ever wanted to know about our holiday light show and how we put it together.
toc: true
toc_sticky: true
---

## Our Location

We're located in the Anderson Mill West area of Cedar Park, just north of Austin, TX.

## Equipment

### Control Equipment

![image-left](/assets/images/posts/2021-12-18/rpi_controller.jpg){: .align-left} 

Surprisingly, the brains of the entire show is a $60 Raspberry Pi 4. It runs a program called <a href="https://github.com/FalconChristmas/fpp" target="_new">Falcon Player (FPP)</a> that takes the playlist, sequences and effects for the show and sends that data to a <a href="https://www.pixelcontroller.com/store/" target="_new">Falcon F48 Differential Controller</a>. The F48 further processes the data and talks to several Differential Smart Receivers distributed throughout the 'stage'. Each Smart Receiver controls a small group of light strings.

### The Lights

All the lights in the display are WS2811 RGB LED "pixel" nodes. With a few exceptions, like the Leaping Arches, all are bullet-style nodes. In the arches we use WS2811 LED strips. 

There are nearly 10,000 individual lights in both the Halloween and Christmas shows.

We sourced all of our pixel nodes, connectors and most of our cable from <a href="https://www.rgb-man.com/" target="_new">RGB-Man.com</a>, and highly recommend them. 

### The Music

In addition to sending light data to the F48, the Raspberry Pi also handles playing the music. It is connected to a low-power FM transmitter, allowing visitors to listen in their cars or portable FM radios while watching the show without disturbing the neighbors.

When a show song is not actively playing, I'll play 'intermission' music from my personal music library, or the following favorite online streaming channels:

* <a href="https://deadair.co/" target="_new">Dead Air Radio (The Sound of Halloween)</a> 
* <a href="https://www.santaradio.co.uk/" target="_new">Santa Radio</a>
* <a href="https://somafm.com/" target="_new">SomaFM</a> *(Usually 'Mission Control' or 'Groove Salad')*

### The Software

For audio editing, processing and normalization, we use <a href="https://www.audacityteam.org/" target="_new">Audacity</a>.

For developing the show sequences and effects, we use <a href="https://xlights.org/" target="_new">xLights</a>.

To run the show, we use <a href="https://github.com/FalconChristmas/fpp" target="_new">Falcon Player (FPP)</a>.

For scheduling and automation tasks, we use <a href="https://www.home-assistant.io/" target="_new">Home Assistant</a>.

## Features

### House Outline

![image-left](/assets/images/posts/2021-12-18/house-outline-lights.jpg){: .align-left}

Most of the horizontal-running lights are attached to 1/2" PVC pipes, which are then attached under the soffits using PVC clips from <a href="https://holidaycoro.com" target="_new">HolidayCoro</a>. 

The vertical lights posed a bit more of a challenge, as much of the house is brick. So, I attached the lights to 3/4" EMT electical conduit with pipe hangers, and attached furniture levelers to the ends of the EMT. By adjusting the furniture levelers, I 'pressure fit' the EMT between the soffits and the ground. Finally, where I can, I secure the EMT to wood with pipe straps.

The overall solution makes it easy to assemble and disassemble with minimal permanent damage to the house. 

### Mega-Tree

![image-left](/assets/images/posts/2021-12-18/mega-tree.jpg){: .align-left} 

The center pole of the Mega-Tree (Christmas show only) is a 10' length of galvanized iron pipe. 

At the bottom, the center pole is attached to some EMT conduit bent and joined into a semi-circle. The pipe and conduit are attached using connectors from <a href="https://makerpipe.com" target="_new">MakerPipe</a> (which, incidentally, are used generously throughout the whole display and highly recommended). This bottom structure is raised about 6" off the ground, and held in place with rebar driven through the EMT conduit/floor flange support legs and into the ground.

At the top, the center pole is connected to a custom tree-topper from <a href="https://boscoyostudio.com/" target="_new">Boscoyo Studios</a> with a floor flange. J-hooks connect to the tree topper and stretch 24 strands of lights, each holding 60 lights, to the bottom where they are attached with bungee balls.

The Mega-Tree alone has 1440 lights.

{% include video id="8g0b1Fsv86I" provider="youtube" %}

### Matrix

![image-left](/assets/images/posts/2021-12-18/matrix.png){: .align-left} 

The Matrix is constructed of an 4'x8' frame made of EMT electrical conduit, held together with MakerPipe connectors. To that frame we attached 1152 individual pixel nodes spaced 2" apart. 

The mesh used to hold the lights in position was purchased from Boscoyo Studios.

{% include video id="fDpVUTbP5eA" provider="youtube" %}

### Mini-Trees

![image-left](/assets/images/posts/2021-12-18/mini-tree.jpg){: .align-left} 

The Mini-Trees (Christmas show only) are constructed of EMT conduit slipped over a piece of rebar driven into the ground. The lights are attached to standard Mega-Tree mounting strips and 1/2 of a ChromaPole set, both purchased from Boscoyo Studios. The strings of lights are connected to a ChromaPole plate at the top, and held to the ground with tent stakes. Each mini-tree has 108 individual lights.  

### Tombstones

![image-left](/assets/images/posts/2021-12-18/tombs.jpg){: .align-left} 

The Tombstones (Halloween show only) are made of corrugated plastic and purchased from Boscoyo Studios. Each tombstone has 100 individual lights.

{% include video id="8egWLmNIVtU" provider="youtube" %}

### Leaping Arches

![image-left](/assets/images/posts/2021-12-18/arch.png){: .align-left} 

The 4 Leaping Arches are constructed of 2" HDPE tubing with LED strips inside. With some slight modifications, these were made following <a href="https://www.youtube.com/watch?v=4pjHDMx92TI" target="_new">Matt Johnson's Tutorial</a>.

{% include video id="BssjbqqX4kw" provider="youtube" %}

### Singing Face/Spinner Prop

![image-left](/assets/images/posts/2021-12-18/triune-in-progress.jpg){: .align-left} 

The large central 'spinner' over the garage door is a Hattitude Triune from <a href="https://gilbertengineeringusa.com/" target="_new">Gilbert Engineering</a>. This is one of our favorites due to its versatility. It can act as a high-density spinner to display designs and animation and also as a 'singing face' with several options. 

### Light Poles

![image-left](/assets/images/posts/2021-12-18/pole.jpg){: .align-left} 

The light poles on either side of the front door use Boscoyo ChromaPole top/bottom plates to connect 6x 30-light strings on a piece of EMT conduit slipped over a piece of rebar in the ground. Each pole has 180 lights and allows for doing numerous different effects.

### Spooky Tree

The Spooky Tree (Halloween Only) comes from <a href="https://gilbertengineeringusa.com/" target="_new">Gilbert Engineering</a>. It's made of corrugated plastic and has 394 individual lights. And, we can make it talk and sing. 

![image-left](/assets/images/posts/2021-12-18/spooky-tree1.jpg){: .align-left} 

I had issues the first year with the tree 'melting' under the Texas sun. This year, I built a frame by bending 1/2" EMT conduit.

![image-left](/assets/images/posts/2021-12-18/spooky-tree2.jpg){: .align-left} 


## Conclusion

When you come to see the show, please be respectful and don't upset our neighbors. Click to review our <a href="/lightshow/the_rules/">Rules for Viewing</a>.

---

Finally, some have commented after watching the videos that it looks as if I have some lights going out. Fortunately, it's not the lights. I have a big Live Oak tree in front of the house and some smaller trees and shrubs in front of the porch that are obvious when you see it in person and much less distracting than in the videos.

![image-left](/assets/images/posts/2021-12-18/house-halloween2021.jpg){: .align-left} 

If you're thinking about, or in the middle of, building your own display and want more details about how I did something, or why I did it that way, feel free to email me at <a href="mailto:chgo2022@opayq.cc">chgo2022@opayq.cc</a>.