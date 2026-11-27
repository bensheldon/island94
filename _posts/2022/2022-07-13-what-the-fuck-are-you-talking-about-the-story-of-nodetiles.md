---
title: '"What the fuck are you talking about?": The story of NodeTiles'
date: 2022-07-13 22:31 PDT
published: true
tags: [maps]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "0decf7b96f51a51c"
  vector: "9QQGAAX3+QTyBfYDAPgAAgoJ//z27//7CgX8BwT6/wgFCgASBPf5/gcE+AUI+gH5+AT49wX08wAE+QYBAf0FAgkC/ggO+AP//P/1/QP5+fwC/P0H+P79CAcE/gUFBQD/Cfn4CwIBCPIE+QQC+wb3AfUA+vYBAQwODQT9/AX/+AAEDgcICvv79+//BBD8DQT3/f0E/vr++/8EBQAIAgL/BgAKAQH48P7+/P3/Av33A/0I/wAI/QYD9wH5CggD/AICA//8Bvr9AwcJ//0A9/v1AgD7+fwDAgoE/wEC+/74/QD0AfcRA/QB/wEH9vwG+/sDDPn/+QAO+AX7Bvn/9QH/AAT+CQYAB/35/PT4/P4E+gz/A/4H//gI+PsIAgAC9QAAA/cA/AIJBQoBAAMFCAH+9v0IBAcHCPwD/wMDAvQOAAAGA/r+/f4IBgIFCvz+AQsDCQb2/PsM+wD8CP0G/vX++/8E///5/AEEAv4BA/gE+fgB/P789wQNBfwDBg3+/PEA"
---

![NodeTiles' trippy demo image that says "NODTILES" written across a map ofthe globe](/uploads/2022-07/nodetiles.png)

_I recently lost access to my 10-year old Code for America email address when I changed jobs. I tried to preserve some of the good stuff and this is one story._

During my time as a Code for America Fellow in 2012, I created a Javascript-based slippy map tile renderer called [NodeTiles](https://github.com/nodetiles/nodetiles-core) (kinda sorta like Mapnik). Several colleagues helped vastly expand it, we presented at NACIS, and I know of at least one successful company that is still powered by forked version of it today.

**Jessica**

During our Fellowship, Jessica Lord gave a tech talk on building custom map tiles and first introduced me to TileMill. I couldn't find a record in my email of when that happened, but know she planted this seed 🌱

**Tom**

On April 25, 2012, I sent this email to Tom Carden:

> This week I came across a gist of yours and eventually made my way to nodemap while researching how to generate server-side map tiles. Thank you so much for putting those pieces together; they're fantastic! I matched your code with node-canvas-heroku to get it running in the cloud and it's pretty fantastic:
>
>  [http://morning-spring-2292.herokuapp.com/](http://morning-spring-2292.herokuapp.com/)
>
> Anyways, just wanted to send you a big thanks for the code and inspiration. I'm working on building a node-based utfgrid renderer to bootstrap an entire wax interaction layer... all without Mapnik (though maybe I should just work on packaging that for Heroku).
>
> Cheers,
> Ben

Tom gave some helpful advice and caveat emptor about JS performance and data caching. He continued to follow up with node-canvas and cairo suggestions for getting stuff running on Heroku. Tom ended up being a Code for America mentor for a different project and he was the source of us using the Toner map style in demos and also a nice leaflet clustering plugin.

**Rob**

Rob Brackett was the first person I explained what I was doing to create a tile render in Javascript. His reaction to my explanation was "What the fuck are you talking about?" Rob is one of my best friends, and I don't remember how I explained what would become Nodeiles initially, but I'm sure it took 20 minutes and was a non-linear train of thought.

On May 2, 2012, I sent this email to "Fuzz", Code for America's random-nerdsnipe list:

<blockquote markdown="1">

Last week Rob and I built a heroku-compatible map-tile renderer (and UTFGrid generator) that can quickly (and with low bandwidth/client-processing) serve interactive maps and markers comprising tens of thousands of points and polygons---and unlike TileMill, the final map can be connected to a live database and updated on-the-fly. It's kind've badass.

Here are 2 examples:

1. Static map of San Francisco streets and Parks:
 [http://morning-spring-2292.herokuapp.com/](http://morning-spring-2292.herokuapp.com/)

2. Map of all ~1.5k Occupy sites worldwide (I did this in about 15min, so it's a little clunky):
 [http://occupy-map.herokuapp.com/](http://occupy-map.herokuapp.com/)

In terms of why it's badass (from less to more geeky):

1. It's fast. Nothing is rendered in the browser, instead all of the tiles are rendered and streamed to the browser as PNGs.
2. It's small. No shapefiles are sent to the browser. Each Map (the entire initial pageload) is less than 500kb.
3. It can do dynamic data. TileMill makes beautiful maps, but once you export them to MapBox (or your own mbtile server), you can't change them. This can be hooked up to a live database (right now it parses geojson).
4. It runs on Heroku. It uses node-canvas (not Mapnik) so it is fast, lightweight and has few dependencies.
5. It renders UTFGrids, which can provide mouse-hovers and other straightforward UI stuff that most maps don't (way less clicky)
6. It's not a tileserver, it's a tile *renderer*. Seriously, all those maptiles are being generated on on-the-fly (we should probably cache them, but hey, this is bleeding edge)
7. It's nodejs and all the code is on Github: [https://github.com/bensheldon/nodetiles](https://github.com/bensheldon/nodetiles)  

I'm still working on it, so if you have a big dataset that you've had trouble mapping before, let me know since I'm looking for more/better use cases.

</blockquote>

**Prashant**

Prashant Singh, another Code for America fellow, was excited about the project and gave me lots of feedback. Prashant was using my project to generate large static maps from the commandline, and he gave some feedback on his experience doing similar work with Mapnik. Prashant and two other Fellows, Alicia Rouault and Matt Hampel, would subsequently build a business on top of it.

On June 5, 2012 I sent this email to Eric Gundersen at Mapbox:

<blockquote markdown="1">

I haven't done a big writeup yet. I'm hoping to submit to NACIS for their October conference, but I'm still trying to clean up the code, modularize it, and write tests and documentation.

General backstory: I had been playing around a lot with TileMill and Mapnik and trying to programmatically generate map tiles; at CfA we have a lot of big, dynamic data and I was trying to set up an automated tile renderer. Then I came across a Tom Carden project where he was use Node-Canvas to render tiles... and then I discovered a node-canvas module that would run on Heroku... and by that point I was in love with the idea of a low-dependency (compared to mapnik) on-the-fly tile rendering implementation.

From there, I wanted to see how close I could get to a full-blown TileJSON implementation. I had my coworker Rob Brackett write me a Javascript UTFGrid implementation and I hooked that up to the tile rasterizer. And bam. It's clunky as hell, and sort've slow (it's rendering an entire shapefile then cropping it down for every tile rather than spatially indexing the features), but I think it has potential.

I think the next step (in addition to cleanup and documentation) is loading up some OSM metro data and actually seeing how the performance compares to Mapnik. Also, while I can't foresee implementing something like Cascadenik, node-canvas gives you direct access to the graphics renderer and it might be useful for creating boutique maps with graphical flourishes that Mapnik hasn't implemented... and of course for creating layers with dynamic data.

Let me know if you have any specific questions or ideas you'd like me to try to implement or use as demos. Thanks for the interest!

</blockquote>

**Alex**

Alex Yule, another Code for America Fellow, and an actual experienced cartographer, was also interested. Alex would build a proper database adapter layer and the actual spatial indexing functionality that all of my previous emails yolo. Alex joined Rob and my presentation proposal at NACIS. This was our abstract:

> **NodeTiles: Joyful Map Tile Rendering with Node.js**
>
> Mapnik has become the de facto open-source standard for rendering map tiles. While Mapnik is extremely powerful, it can be difficult to set up and deploy. We present NodeTiles, a lightweight, JavaScript-based, open-source map tile renderer that is easy to deploy, use, and extend. Built to support applications with dynamic data, NodeTiles offers an accessible and cloud-friendly alternative to Mapnik. While still in early-stage development, features on the road-map include styling with the CSS-based Carto language for compatibility with MapBox TileMill, UTFGrid generation for client-side interactivity, and data adaptors for PostGIS and Shapefiles.

**NACIS**

The NACIS (North American Cartographic Information Society) conference was October 17-19, 2012 in Portland, Oregon. Alex and Rob and I had gotten an AirBnB and I mostly remember us doing a lot of last-minute implementing. Alex built a really nice Postgres Adapter plugin and Rob was reimplementing Cascadenik ("CSS for Maps") somewhere between Javascript and Cairo; there was a deep-dive into blitting. We presented at a breakout called "Slippy Maps".

Afterwards, I remember riding BART back from the airport when we arrived home in San Francisco. I was talking with a maybe-a-big-deal person from the map-tech community, and they asked me something pointed like "But how much did **you** _really_ contribute to NodeTiles?" I said something like "It was a team effort" and then it got really quiet. In hindsight that was probably a job interview. And also fuck that, it _was_ a team effort.

**That's it**

During Fall of 2012 Code for America Fellowship was ending and interviewing as an inexperienced engineer is freaking hard (and also incredibly dumb, but those are different stories). So I mostly put down NodeTiles. And also:

- Going from something that’s a tech demo to something understandable ("What the fuck are you talking about") and usable by outsiders is hard.
- The sheer difficulty of spatial work. That dumb NodeTiles logo took me hours just to get the tooling together to just like, draw straight lines on a globe to say "NODETILES".
- Maps are a commodity, and also if you need to dynamically map a billion+ polyons (I've been informed that today there is Postgres MVT) _and_ you need a pipeline for auth and anti-scrape and billing and raster and.... well, god bless you.
- I leaned into some questionable architectural decisions to make NodeTiles more Javascripty, splitting up the front and backends, and modularizing all the different pieces into their own packages. In hindsight that was a lot of valueless work that only introduced friction into building the tool and delivering the value. That's on me; never forget.
- Given that this is an email-based retrospective, I will admit I found some emails from kinda big deals like Stamen that I didn't respond to. I dunno why I didn't respond; probably burnout. If that was you, it wasn't personal, and I'm happy with the path I've taken, and I hope you are too 🤗

NodeTiles is [still up on GitHub](https://github.com/nodetiles). If you can get node-canvas linking to cairo (memories of this seems like a fever dream), NodeTiles is really cool. Maybe you'll do something neat with Nodetiles ❤️
