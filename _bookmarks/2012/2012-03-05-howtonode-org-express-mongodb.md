---
link: http://howtonode.org/express-mongodb
date: 2012-03-05 15:51 UTC
published: true
title: Blog rolling with mongoDB, express and Node.js - How To Node - NodeJS
tags:
- nodejs
- javascript
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "6ff3ade87a585482"
  vector: "+v4ECwkA+gb8BvMLAAMHBgT9CQP6/AYFAwf7/QH8BP38APMFBfD6+QAA+P4L9/gJ///+7wH9/A77+f8ACv0BCAD9AA0KBP4M+/n1+Qf3/wr+BfsL9/gGBPkBAv8F+vwEBgME+wIHBvsDAfwEBQAFBvT+AgAK8gUMBQwC+gwLBwAIA/4KCQb9/OsBAgoBBQLwBAIM+wAE/goMAAgI/P0C/vcH+fz09wL7+wr7+gEKAf4H+vn6AQz6+wXzBfsF+/v6AQH8AgUDCP4B/gAH9vn4BwX6+AUIBwX/AgoECw72/AD5/vwJAwD3Bf/69/wACfcJ+fAA//cC+QAGAPv99fX6+QgABAD+Bgb5Af39+//78Qr+++76Afz99vkCAwj/AgIA/e/+/vb+AQsGAwj/B/cE/gAMAv0D/QP3+wP7A/YCBQD3+/UGAgEK/woNA/7+A/4EB/r/AgQBAgME/gECAfn0Av8CCv37Afz9A/wG/vj4/vsABgf2CwUDBAH/AwID/gUB"
---

In this article I hope to take you through the steps required to get a fully-functional (albeit feature-light) persistent blogging system running on top of node.

The technology stack that we'll be using will be node + express + mongoDB all of which are exciting, fast and highly scalable. You'll also get to use jade and stylus for driving the templated views and styling! We will be using npm to ease the package management and installation issues.

This article will be fairly in-depth so you may want to get yourself a rather large mug of whatever beverage you prefer before you settle down :)
