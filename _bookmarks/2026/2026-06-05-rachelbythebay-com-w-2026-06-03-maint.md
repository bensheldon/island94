---
link: https://rachelbythebay.com/w/2026/06/03/maint/
date: 2026-06-05 13:41 UTC
published: true
title: ''
tags: []
---

This is also yet another case of an "edge-triggered" system vs. a "level-triggered" one. The former has just the one chance to make those tickets come to life, whereas the latter is constantly looking to make sure things are set up correctly according to business logic.

Miss an edge and you're screwed. Like, oh, say, did you schedule a cron job at 2 AM? Guess what, if you're someplace that observes "daylight saving time" on its machines, then once a year, that cron job won't run... because there *isn't* a 2 AM. It goes from 01:59:59 to 03:00:00.

Meanwhile, a level-triggered system might miss the first opportunity to take a whack at something, but it'll catch it again on the next pass, or the one after that, or the one after that, and so on down the line.
