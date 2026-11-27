---
link: https://gelnior.wordpress.com/2012/04/28/how-to-quickly-start-a-single-page-application-with-node-js/
date: 2012-05-01 02:53 UTC
published: true
title: How to quickly start a single-page application with Node.js « Gelblog, addicted
  to the web
tags:
- nodejs
- java
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "abc4b6e28bd7b41f"
  vector: "+P0GEAf++xD3AvQE/QAEBwn9Bv37+wYE/fz8BAP5Bf//A/USCPH39fgM+QcL8wH/APsI9vz1+Af7/wQI/gQH+wUB9AQFAQD/+/328/kF/Af3//4L/wQHA/7/APsKAwAF/wT7AAEFEP75/v8EAfkAAAIC/v8H+Q8OAwsDAgkABQD+Bv4MBfgF/e8N/w0B/wHw/QYJ/vn8+/wO/wYI+/0CAPUJ9/z++/j8+AP1+//7AvwI//sDCgv6+AcBCAoE+/T9A/z5AQUA/QIL/AcA+Qf5/vwE/goLAAX9/gz6/w38/wAE//0F/v3//AYE/vYGBPsL/PkL/fsO+ff5AvoB9P3xAQr4+/z6Dgr3AgH+/P/+9AD6AvMA/fH/+Ab9/wP9/QX/B/H2+AL89gMOCwD7B/0GAf4IAvsABvz9AgP+BgUE+gD6APP9/AUGDQP////4CPwJ/gX9/gQIAggC/wUAAf33BP8H//4ABP0GBwb++AL8/PsF/wP7/v0ICQH7AAL+AQn8"
---

A problem I experienced while starting coding with NodeJS environment and Express framework is that I had difficulties to quickly make a well structured app. I spent too much time on organizing my modules and writing helpers. Paradoxally with Express, I like the fact that I am free to do what I want and don’t encounter too much constraints due to the framework. At last, it was harder to design front end code than back end code.
To deal with that, I used two tools that fit in my requirements :
RailwayJS : a lightweight framework on top of express. It offers the structure and the vital functions I need to write a good  backend and configure express properly.
Brunch : an application assembler to organize and build cleanly my front-end code.
