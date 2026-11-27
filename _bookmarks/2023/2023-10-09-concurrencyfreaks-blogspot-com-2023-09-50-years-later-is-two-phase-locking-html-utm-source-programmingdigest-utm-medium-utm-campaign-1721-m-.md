---
link: http://concurrencyfreaks.blogspot.com/2023/09/50-years-later-is-two-phase-locking.html?utm_source=programmingdigest&utm_medium&utm_campaign=1721&m=1
date: 2023-10-09 01:11 UTC
published: true
title: 50 years later, is Two-Phase Locking the best we can do?
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "a7abea4bcaa73d2c"
  vector: "9QME/v4I9AT8AQMM+/sO/QT6A/0G+P3+AQT5BgMAAAb2+vn3CQL9+AEA+QIC/AMC/vgDBgAIBAQEA/wF/f8DAQUEBvsFA/r5CfoDAQD5BAEE9gH7+/X9AQHyABERBgQJ+gb8+QcFAvYD9Qb4AgAJCAQD/gP3BBD+BfcBAQX9+gD1B/AG+gT7APoBA/QABAzzBAUPAQb4Av0U+QnzCwT8AvgJ/Pv2+gD8+QT99g7+/gX1+fsK8wIHAgb+CAn4//8C+wwA+/0EAfYE9f/+DAYEAwABAA8G/P8I8wcGBAIGAQD9/f4EAPoA/AgBBwD+Bf/7BvgOAQr7/AwJAvD5+gnz+Ab/Av4C9/YFBQL0/v0GCgH5AwID+fYE9v7/8f4LAAECAwEL9vcICAMDAP8F/fr7AfgE+gIB+fwD/PX2/vv+/wAGAAj9APv3BgcKAAD8AvwGBvz+/wIC/f7+Awn/Cfv59AAP/fr9Dgf/A//+CAD6+vz8Av0GBAIHCgACAg0A9vcA"
---

> Ok, 2PL is easy to use and has strong isolation, so this means we're ready to go and don't need anything better than 2PL, right?
I'm afraid not. 2PL has a couple of big disadvantages: poor read-scalability and live-lock progress.
