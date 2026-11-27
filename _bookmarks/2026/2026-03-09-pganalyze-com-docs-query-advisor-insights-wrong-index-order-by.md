---
link: https://pganalyze.com/docs/query-advisor/insights/wrong-index-order-by
date: 2026-03-09 16:57 UTC
published: true
title: Wrong Index Due To ORDER BY · pganalyze
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "0bf40019fb953ff8"
  vector: "Bf8MCAH/A/gHAv8T9/fy/AP7/Pr8BPn+9/76/QX78g39Du/7/+/++wAMAQb9+fn7A/vtBwT6/f71/gYD/P/49wLyC/wCCA0F+Ab4Bvr6AgD//f/8//P59wUABgH7AQoECgcEAQMMAAb99/wDAvr/BQb7AAQDAwT++wf+AgAKAAAF+wr59/3+A/8HAAIDAQb+AQj8/gP5BwD1BPn/BgP3BQUACgYAAQQA//8E+QIC+gL8Efr/AxAG/wkG/QoE+wIDBf8CDQcEAAUD/gv5AQkB9AD/DP70+QIO+PwCDgn9BQD49QH8AvkH7wADA/sH/QYH//r2//cJBAsAAAL++wUFA/8E//72+gIG+QcIBQH9/v8EBPsI/wYE+/IH9AP+DPwAAAIF+Af4+/gABPkE/Qz7/AcBBwf6BPoA9wcF9/z8AwD++vgBA/gAC//9//r7/QPy9Pb5/vAB//oBBwAHCQEJ/f0ABv4HAPr1+vgDAPj//QALAfb8+wIJAvYD//gG9/cJ"
---

When queries combine WHERE conditions with ORDER BY and LIMIT, Postgres sometimes optimizes for quick sorting instead of efficient filtering. This can result in scanning massive amounts of data when only a few rows are needed.
