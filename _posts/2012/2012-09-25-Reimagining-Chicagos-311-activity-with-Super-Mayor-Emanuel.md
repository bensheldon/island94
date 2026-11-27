---
title: Reimagining Chicago's 311 activity with Super Mayor Emanuel
date: '2012-09-25'
tags:
- analytics
- data
- open311
- portfolio
wp:post_type: post
redirect_from:
- 2012/11/reimagining-chicagos-311-activity-with-super-mayor-emanuel/
- 2012/09/reimagining-chicagos-311-activity-with-super-mayor-emanuel/
- "?p=3057"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "b732caaded8d5e2f"
  vector: "8/f8+/30Af0DAP0F+/oGAhX6BPcD/f8E/gj99wn6A/kAAfoEAPj6/AAF+/39/Pb/+gAE+wEF/wD9AgINAfwDCwcD+QEG8gIA+//98/n6//kD9vsKBggCBQUJ9gUAAvgFAwL5BwICA/UE/f0MAQ35/v74+/0H/AgKEgj//AwDAAAEAPkCB/8E//wABQ8L/wX6AgUI+wP+AAkLCPwKAwIHA/QBCP4B8/n59gDtAvH+AAAHAgMBAgj9/wP5/gcK//36//z8CAEFAAAMBPgC+QL8+wb0AQUJ//35/An7AQcD8QD0/vgG//76AgP++AYGBgACAvX6AfoK8/n7B/cBAfv9+vr2AwkGBgL7Cfj+A/8L7Ajx/QT9Awb8AP/+BQQK+/oD//v+8AAABf34//z9BPX9Av8SBv4IBfj/AQT9C/UPAQAABP7+BQT/BAP8BQD+AgwCBvz3/fsE//8F/gkM+QHxCAX2Bwjz+wH9BP/5BgUG+fUMAfz3+wgG/v73BAkLBv0E"
---

![](/uploads/2012-09/screenshot-600x437.png "screenshot")

  [Super Mayor Emanuel](http://supermayor.io) is one of the goofier applications I've built at Code for America: [**supermayor.io**](http://supermayor.io)

**Boring explanation:** Using data from Chicago's Open311 API the app lists, in near-realtime, service requests within the City of Chicago's 311 system that have recently been created, updated or closed.

**Awesome explanation:** The mayor runs through the streets of Chicago, leaping over newly-reported civic issues and collecting coins as those civic problems are fixed.

I really like this application, not only because of its visual style, but because it lets you engage with the 311 data in a completely novel way: aurally. Turn up those speakers and let the website run in the background for about 30 minutes. Spinies (new requests) come in waves, and coin blocks (updated/closed requests) are disappointingly rare. Sure, I could have just created a chart of statistics, but I think actually _experiencing_ requests as they come in makes you think differently about both the people who submitted a request and the 311 operators and city staff who are receiving them (just think about what caused those restaurant complaints... or maybe don't).

The application is built with Node.js, which fetches and caches 311 requests, and a Backbone-based web-app, communicating via socket.io, which manages all of interface and animation. The source is on [Github](https://github.com/codeforamerica/super-mayor).
