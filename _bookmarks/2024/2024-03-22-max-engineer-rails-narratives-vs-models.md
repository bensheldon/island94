---
link: https://max.engineer/rails-narratives-vs-models
date: 2024-03-22 07:29 UTC
published: true
title: Rails — narrative vs model centric approach - Max Chernyak
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "cf4a8005a7700714"
  vector: "BP37AwUF9QkNCvsIAQUJ/w7+B/0K/f8H+vgD/wPzAwAB/wIEAvj9+wQD/wIM9Pj8/v/9BAP++gH6+AX8/gj7/gX6+w8GBQD+/PcB+v/97/j8/gT/9/r7BAb///wDCPoH/Pj//wD/BfwH/vsA+v0DCAEGEwMC/v4FCwb/CAIABwAIB/4DBAn+//0E/Qv9BQX97gYABf//+QIJBQYD8AABAAD8BgX//wIA8vnv/AIGAAb2/v8AAwH9/AT0Cf4N9Pb/+wMA/wz+9wQG/fz69gH5EP/49v8GBgH79vz+CAkDCQAD/PwHCfED/wIA+fv4BQH4BfcACP4I8PsNAff/+fn/AAr89wkA/gMFDPb5/v0JAQL9A/cF//0A7wD9/gMCCgP9BPcE/gP7//8DCAYG9/b6+u/6BwYAD/UFAQP6/wgJ9wD0/wUB/AkIBvoK/P/4CgAADfz+AQkO+Pz7A/MFA/sFA/wQBAMDDP36AwILAP8C/O8IAPT2/AMGBgH9/f8J/fsH"
---

> alternative way of building apps is narrative centric. Instead of creating a web of nodes with ripple effects, I want to write short stories, each living in an entry point (whether that’s a controller action, bg job, rake task, or test). Each story has a beginning (the initiating request/call) and an end (the response/output), with side effects in between. I love seeing a complete story where every major plot point is clearly visible at the controller level.
