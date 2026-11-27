---
link: https://rachelbythebay.com/w/2026/06/03/maint/
date: 2026-06-05 13:41 UTC
published: true
title: ''
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "6331d1ae59fec395"
  vector: "/PsABQv3/QgP+vsCAv0DAP7x/Pz9+vwI9f0BBgIDBv4A/wMDCQH/BAX5/AQABv8C7vkBAwD/BhMCDwcA8v3z/P4F+/4HAgkC/wYJ///8/v/+9vz/BvoEBAkGA/4JAwcHAwEEAPr69wUOAPcJ+/sD+Q76/Qf5AwX9APwA9wcDBQAC+/r2A/z3/QcG+/z++gT6Av79+wL6+fz5B/8FBAP+CAP+/gwC+vz19wD/A/77Av71DAIOFPv+/gP4AAoL9PoBBAcJ+AIHDAL/+vz6CAUB/gj6A/4O/Pv+9Ab//Q8U/AAE9/oK/gX7+QMI/AD7AwLyDPv+/wgE7QIGBPcH+gP3/AcBBAgBAP8AAwH//fsQ/g74AvcDBggDAAD99wkG9voDAv4B8Qv+BgP1+Pj8+QX1/fX7AgXyBP3/B/78APgO+AAAA/4ACP8I/fwACPb//QcG//z7BAQDAv36BQIZBgT6/gEB+QX/Av8AB/v7Bv4C+AkCAQD8AfwK+AX5AAkEA/b8"
---

This is also yet another case of an "edge-triggered" system vs. a "level-triggered" one. The former has just the one chance to make those tickets come to life, whereas the latter is constantly looking to make sure things are set up correctly according to business logic.

Miss an edge and you're screwed. Like, oh, say, did you schedule a cron job at 2 AM? Guess what, if you're someplace that observes "daylight saving time" on its machines, then once a year, that cron job won't run... because there *isn't* a 2 AM. It goes from 01:59:59 to 03:00:00.

Meanwhile, a level-triggered system might miss the first opportunity to take a whack at something, but it'll catch it again on the next pass, or the one after that, or the one after that, and so on down the line.
