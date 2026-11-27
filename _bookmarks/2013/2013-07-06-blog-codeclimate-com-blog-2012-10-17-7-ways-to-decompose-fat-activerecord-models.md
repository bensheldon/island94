---
link: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
date: 2013-07-06 14:50 UTC
published: true
title: 7 Patterns to Refactor Fat ActiveRecord Models - Code Climate Blog
tags:
- rails
- development
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "f787d8ae60b1fd69"
  vector: "8v/9Cv/+//z3BgMB+AEHBAEF+/8QAwAE+f0EBAb1BQsDAP7+A/78BwX6AQEI//0F//P7+fYFBvsC8vz5BgP7AwAA+f4KA/sI+QEBBv33/vb0AAEBAgP9//4D//8K/u8FDfwCAf8HBgAC9/8FBQEAAAD8APf7AQMGBwQBAf4B+QAI/vwEAvv5/QgN/Qz5Dgf69hD8CP8I/P4DEP/8+wIMAwECCPwG/QLzA/75AQEFBQYF/QgBBAr/+f8BBwIIBgP//gH79gcNBQ3y/wL4B/jxAfoB+gLzCgr89vn9+v3zBwAGAAEAAPb7/gP5+fgI/Ar69/UBA/YE8QMBAu79AP/5+gj+6gMABf/7Cvr/AwT3+AQBBAf88vgACf32/QL7BAMEAAIF9v32Bgr+Agz49wL+BPD6BxH+BQADAAn8CgII9gD9/AgF/QUHBQL/Cwz9CAgB/AL0BAIC/QQDAvwECQQMAQkFBgf+AvcC//v5BAb/9/cCAfgF9wr0AQb8AwAL/wII"
---

You’ll also note that many of the patterns described here are quite simple. The objects are just “Plain Old Ruby Objects” (PORO) used in different ways. And that’s part of the point and the beauty of OOP. Every problem doesn’t need to be solved by a framework or library, and naming matters a great deal.
