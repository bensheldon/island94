---
link: https://rachelbythebay.com/w/2026/06/03/maint/
date: 2026-06-05 13:41 UTC
published: true
title: ''
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e1bb38d2acbda536"
  vector: "+/wBBQr2+ggK+/sAAP0BAP/y/vv8+/0G9v0ABwQGCP4AAQUGC/8BBQb8/gICA/4B7vwDAPwACBQADwr/9P31/f0D+wEGAQgB/AIK/wH7+f/78/39BvsGBQkFB/8IAQgKBAEBAfr89gIOAvgL+/gD/Q36/gf3Awf+Af7+9gUBBAAC/fv1Avv3/wgD+v39+wT4A/v9+wH8+P75BAIFBAT9CgQC/Qz/+vn0+wH/AAH2BP32CgEOE/3+/wb5BAsK8/oDAggH9gMHCwQB+QD5CAP+/wf9BvoM+vwB+gT+/AwS+gAD+f8J/AX8+QMD/QD8AgPyDvv+AAcF7gEHBPcF+wP59wYCAggBAv0BBgH+APwS/RH2//cFBQcG/gD+9ggF9voEA/z+8gr/Awf09fr9+QX2APX8AgXyAvv8Bfv9//kO/AAABAH/Cv0J/PwFBvP+/AUJAf78BQQCBP38BAEWBQb5/AUA9wP/A/0CCvz7BP0B+gUB/wT6AvoJ+gf3AQcEA/X/"
---

This is also yet another case of an "edge-triggered" system vs. a "level-triggered" one. The former has just the one chance to make those tickets come to life, whereas the latter is constantly looking to make sure things are set up correctly according to business logic.

Miss an edge and you're screwed. Like, oh, say, did you schedule a cron job at 2 AM? Guess what, if you're someplace that observes "daylight saving time" on its machines, then once a year, that cron job won't run... because there *isn't* a 2 AM. It goes from 01:59:59 to 03:00:00.

Meanwhile, a level-triggered system might miss the first opportunity to take a whack at something, but it'll catch it again on the next pass, or the one after that, or the one after that, and so on down the line.
