---
link: https://medium.com/@tair/how-to-upgrade-to-rails-5-657b3bfd83#.ql03cvfrd
date: 2016-05-16 20:17 UTC
published: true
title: How to upgrade to Rails 5 — Medium
tags:
- rails
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "1d69a428aab172d2"
  vector: "Bv0F/QkB9QLyD/cJ+/wCBAf+/AP6+gAD/v/7+fr4AAUI/v/9EfoCAAj7+QX+/gH7Bf/+/Pr79/cCAP//AAn+AP/7+QUKA/n89+/89woB/Afw/f7++AEA/wH3CAADCf/+9/v7AgT8Cfr6BAoK/fQEAfkCBwL1/QcBCQ4K//AD+AD7CPkO+Ar/9v0DAwn9Awzy8gkMCgMA9wMPBAv+AQL7AAr6BAkBCf75APrz/QoHAwAD+AD4Bg719Qf8B/YE/AH9/wMCCAwI9gkBDf3z/AP8D/0B+AQAAg0F/goC/wMAAwAH9f8M+vgHAAT3+gMD//n5+/kIAf8D+wICAv38//IEAQL8+Qn/Cfv+CfwB/f8GAfv4AgP2//MC+AcG+QcACAT5+/sE//gF+QAFBwAA/wcH9/cAAf8BBQMABAH2/Pb8+AAEBgIF/Q0CBgUA/v36CAQG+P8C+PcEBP///f0DBvYNAfn+BAT2BgQH9/wB+Pb5+/76/voE+AcECwD+BPgE+/gK"
---

Last week I have upgraded our Dockbit application to Rails 5. The codebase is rather small, so it’s been a relatively painless process. In this post, I would like to summarize the practices that I follow when upgrading to major Rails releases, which have been pretty common for me since Rails 2. I also wanted to gather all the things I had to consider in one place, hence this blog post.
