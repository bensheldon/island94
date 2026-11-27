---
link: http://codeofrob.com/entries/lessons-learned-building-a-multiplayer-game-in-nodejs-and-webgl.html
date: 2012-04-19 06:13 UTC
published: true
title: Lessons learned building a multiplayer game in NodeJS and WebGL
tags:
- nodejs
- games
- javascript
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "4711672b8a94ef57"
  vector: "/P4KAQT7Avz+BAEM+foIBwz+Avjz7AP9/gD5Cv7z/f73AvcMAvP3+QMBAv38/gP8AQj+8gj2/wf+AwUI/AAIBQ76DPz+BfsC+AP6+//9CQEIAPoJ/vsEBfz8AP4HBvoIAAH9Av78Df39BgAN/f/0B/cB+QIE+wgLDAQHCAkF+gAK/fsEAwEE/vP9CAcAAA31BPoG+/z+/Qb9CwIHAQUK9/MJAQT69f4EAP71/PP/AfP/AvUDAv8CAwX4/PwE//jzAgT/CPv5BgMNBwX+8/MH/wn+/QX/8AEA+hD3///7/gD4BfcJAQEA//oD+QP6//0C9f0H9wYJBgkB//0A/QT+BQn9A/4EBf30BfX69AkJ9AQAAfj8AvIA+QP9CQQB+v///Pz8BAIE9AUA9/z8DAEH+QEKAgIFCwAH/PwACfoC/wD8C/0CAw0DBgoD/AIEB/8K+f7+Cf4H+wb4Af8D/vvvCfkC+vj6+/4FAAb+/w0D/fz0AwP49QoK/gT+BgID//UH"
---

I've uploaded Hoverbattles to its own server on EC2, and it has been running fine with an uptime of over 96 hours so far, and this is great!

http://hoverbattles.com

I've wanted to share a few of the mistakes/lessons learned writing and deploying a multiplayer game built entirely with JavaScript on top of NodeJS and WebGL for a while and this represents an opportune moment to do so.

I've gone with a brain-dump of various related learnings, as well as a couple of periphery items - first off, we'll go with the reason I couldn't keep Hoverbattles up on the old server.
