---
title: Content Map
date: '2005-11-26'
tags: []
wp:post_type: post
redirect_from:
- node/15
- content-map
- 2005/11/content-map/
- "?p=15"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "be3ab004bfaea526"
  vector: "/v7+AAcA+Pj4//z/B/0IBwMEA/EBAgQB/AYDAgP5CP4CDAEMAP7+/An++v0A+gP++wL88PYH/gf69f70AP4F/gcI+AcK/v4BBgP8APr68fQABAQL/gMA/QD+/foH/AcFAPT8AAj//PUD//f+/Af+Bvb28PsDAAQLBQT6/wf7/wAKBQkLCAH4/vn9BwH/CQX7AAUEBvX5/fkFAgAG+v4D+gYEBf34+PoAAAT3//kG/QABBBD//PYB+vz+CgT9/wYDEAAGBAT8AAYGAv/9/Pf9/wD2BQAG/QX7+v4ABfr5+wD9+fwKBvf7BQ0Q9P35Av8E+/z9AfkFAAMGB/8H9v77+wPwAQMCDgcL/QD99fj0/Q/3CPv89gAH/vwHA/T79gAICvYB6f4FCAX5AgoDEgMB/vP+BAgQCgAJBv4AC/gI+wD0/fAM/QQOAgj9Cf76/gX5AP/2A/8L+gYHAgsFAvsH/P8C+/X+AfoPBwAB/QEBAP0CAPT9/AIH+ggGBAX/Avz/"
---

This is an example of my googlemap module that I extended from [this module](http://drupal.org/node/29091) by [bjornarneson](https://web.archive.org/web/20051201055033/http://choirgeek.com:80/).

It creates map points through parsing local RSS feeds that Drupal produces. Normally these feeds only contain the last 15 posts, but I hacked together a helper module (fullfeed.module) that uses taxonomy.module urls (with cool term parsing) but adds _all_ content in the term (or terms) to the feed.

With each feed I can define a custom marker (.png files I created and uploaded). The markers are all default size and shadow—this is limiting, but it’s a PITA to modify it.

The workflow for this is relatively easy. Pure latitude and longitude data is inputed via location.module—I grab it from maps.google.com because I couldn’t get the geocoding from an address to work, though many of my nodes are from random places and this is much more accurate. I have a vocabulary setup just for mapped nodes (photos, videos, random thoughts, etc), and use these as my feeds. Custom icons I created and FTPed in, though you could just use upload.module and attach them to your map node.

It currently does not support lines, though I am definitely planning on adding them. but I don’t have a good idea of workflow though, considering there is not a standard RSS element and am not sure if it’s going to be too hard to either…

The module now supports lines as a nodeapi hook (like location.module adds lat/long). Each feed can set a custom line color. I don’t know workflow yet whether to keep it like this, or have color on a per-node basis.

There is still the line issue of:

- define a new namespace (I have no clue on how to do this)
- coopt an existing but unused element and pray we don’t break anything
- parse a static xml file that would somehow be specified in a node

Lastly, there is an issue with posting more than one map on a page (it breaks). This is because every map sets things in the header, and I’m not sure what is the best way to make sure that they only post the important stuff _once_ when there is a list of them.
