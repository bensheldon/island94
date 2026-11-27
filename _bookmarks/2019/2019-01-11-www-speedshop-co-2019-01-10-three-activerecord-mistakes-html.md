---
link: https://www.speedshop.co/2019/01/10/three-activerecord-mistakes.html
date: 2019-01-11 00:47 UTC
published: true
title: '3 ActiveRecord Mistakes That Slow Down Rails Apps: Count, Where and Present'
tags:
- rails
- active_record
- sql
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "8a53e07c22da78f9"
  vector: "Av38CP4CAf8EAwAHAf0BCwr7/gAE/wQH//oD+gH9+gL3BAT+A/0A/QYDAwQBAP8BBfr4BwADBP36+PoJBgQA/Pn++wMICAIJ8QT8/gXx/Pf3+/j+Bfz+7gL7BgQCBf8CAwD6BwAJAwP4BQQK9QEDAwMDA/sK/f4ABQgG//769gAJ/fsH7gj/CgUGAwsCAwb9AgECCvv29wgBBP8F+f79Bff4BwADAf39+gkC/f0F/wn+CgcC/BH19AEDBQEH7/v+AwP7/gYBAQsA+wny/Pv2BP/+9wj8AwX2/gcDBvv7BQAI/Qf/CvQGBQD1AvUEAA4B/fQGDfEP+wX/Aff5+PUC/gL89Q4B/gTwDgP7AfsD+gX8DwP2/P0O9/v7BQH6Dv34+/kIBgcA+AUA/AAH+f33Avj+Af/3DAP99wcD/gD/+AADCwb6AAAHD/n/CAH5BAb5APnzAfwI+wEC/wL6CfgKAAYDCP/+Af0B/gEBAf/8+PEE+vL98wT2Awn/A/0F8/AM"
---

<blockquote>Look for uses of present?, none?, any?, blank? and empty? on objects which may be ActiveRecord::Relations. Are you just going to load the entire array later if the relation is present? If so, add load to the call (e.g. @my_relation.load.any?)
Be careful with your use of exists? - it ALWAYS executes a SQL query. Only use it in cases where that is appropriate - otherwise use present? or any other the other methods which use empty?
Be extremely careful using where in instance methods on...
