---
link: http://jan.kneschke.de/projects/mysql/groupwise-max
date: 2008-04-01 20:56 UTC
published: true
title: "~jk groupwise max"
tags:
- mysql
- reference
- tips
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "ea088455196bf438"
  vector: "AgH++/f6AQL2Av0FBPsBBQUK9PH7+f4AAwYBBgT58/8IBf4B9/YH//0ACAIDB/X8/gv9BggLB/XzAP0A/AAFAfz9/gj9CP0B/QYBA/wCAQEA//wEAP7/BwsM+RD/A/oD/AEDBv0FBAD09v4BA/X7BAjzAvkGCwj8CwACDAMZBAD4/xr0+PL7A/oF+wID/P0A+gLv+wH7BAb/+gQC/AT+/fP/AgIGAwwL/fUDBQQG+wT2A/X0Af/9/QgFAAz3/P4LAQH1+AUFCQcNAvz8DAwC//sDAPX4Cfz6+QD/Awr//QALBgT4Avz/+v0GBgEJ/gAA//oM/ggF/hMF+/sF+wUI9foD/vQA/QUF/fsBCwsBA/wA+/n+BQkDAPsBAvz9BgIK/fwBAfkC/PwEAf8K9wX2/wEDAwL5/gD/APv19v37+QD5+vH0GPsADQT/AAUC//kA/fsDAP0F+/gD/vsGCPr+/gEE/AT6Bv/9+v0D+/UEAAMA+QH1Afv4AfgNAvgEBf8H"
---

One of the common problems to solve in SQL is "Get row with the group-wise maximum". Getting just the maximum for the group is simple, getting the full row which is belonging to the maximum is the interesting step.
