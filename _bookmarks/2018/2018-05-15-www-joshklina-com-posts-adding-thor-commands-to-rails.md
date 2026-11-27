---
link: http://www.joshklina.com/posts/adding-thor-commands-to-rails
date: 2018-05-15 20:54 UTC
published: true
title: Adding Thor Commands to Rails
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "c19763d5a70526ff"
  vector: "+f31Af8F+Qf5DfsDBgkLBgb/BP8BC//+9fQD9P37CfcFAPsNA/z0/wYE9/f59vz2BAT+9v70/vsB9wP4CAX8/gD7/AoCAfv/9/j4+gIB+/3x//cF/A8AAgz8Avf/A/cGCgH5Afv8Afj7CfwD/fgHCP37DAUJ9wQABQgKDAsA/wAKAf8MAwT+9f0C/QsBAPn3AgEG/QUD+wwIAwb6BQAIB/0GBQr2BAP5Cvv1+vr/AQMG/wIBDwf8/AEACfgG+AMKA+0FBg0H+QMCBgb2/P/5Dvj++PoT+gb7Avv+/gMCBAAG9wQJAfsG9fDz/AX7Agb5AvgGAvQB/f8FAv8C+fn7CgL/9AIEDAH/EPr8AfoCA/r0BwH7+wAD+P8EAwT7/wP78/79+fv7/QUJAwv7//r39v/9AgMAB/sH/Pz5BQMC+wD7B///+wkD//wDBf0ABgUEBQcA+P4IBA/+BPb6B/oMAQEGCAH9AgP7AQz8+/kA+fv9//gDAQL8Cwn1////+P37"
---

> Rails provides a nice documented way of adding Rake tasks to your engine, however sometimes you may want a command line operation that requires sophisticated interaction with the user, which can be tedious in Rake. [Thor](http://whatisthor.com/ "Thor"), is a great Ruby library designed for this purpose and its already built into Rails. In this post I'll go over how to create Thor commands and make them available through the `rails` command. If you're unfamiliar with Thor, take a look...
