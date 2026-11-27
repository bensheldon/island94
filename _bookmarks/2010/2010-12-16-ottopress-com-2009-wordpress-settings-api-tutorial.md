---
link: http://ottopress.com/2009/wordpress-settings-api-tutorial/
date: 2010-12-16 23:39 UTC
published: true
title: WordPress Settings API Tutorial » Otto on WordPress
tags:
- wordpress
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "250f78a322923f8f"
  vector: "+QDwB/z++gH5/QAFAvsHBfz38f779gP9APn7AAcHBAb+APb7B/n6AP/5AAn4CPz+9/j/+/kCAAP/C/b7AfT6CvsL9AMB++0D+f0E9PkA/PsKBgQNBP3/+AUJ+wT7+P0F/Pr0/QD//voH+wELBg4ABAP1BAEBAhUDAgMA9/kE/AAI+v8B/gP6/f8BBf/9Cwb8AwIKBAUF//0OCAgO//r/Cf4ABP//APz6APv3/AII/v8MAvsB/gkI+/b++v4E+Af8/An5/wD3+Q37/PQHBQT+/Qz+/AT9/QcC+QAGCgQH+QAF+gAHBf0EAg8F/f7/9AMC9voE+fsE/QP++/IC/fsCAvoE/wP8EAH5AQD0AQYN+vnzAgb1AgH9/wX8AwIG9vUL9Qj6BQMR/PsG+AYCCvT5C/oIAP78A/wCBwX7BvwD/QD59AD//QYJ+wII/QD+CPv6CAIFAgP7/wIN+PkM+AQAAAj99g35+v7yCfwF/vwADP8F/wENBQEHAgEMDQD6DAH8"
---

When writing the Simple Facebook Connect plugin, I investigated how the Settings API worked. It’s relatively new to WordPress (introduced in version 2.7), and many things I read said that it was much easier to use.
It is much easier to use in that it makes things nice and secure almost automatically for you. No confusion about nonces or anything along those lines. However, it’s slightly more difficult to use in that there’s very little good documentation for it. Especially for the most common case: Making your own settings page.
