---
link: https://pglocks.org/
date: 2023-08-23 12:01 UTC
published: true
title: Postgres Lock Conflicts
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "069cf63d866af9d3"
  vector: "/vf8/QQD//ICAQEJ+fMG//389/sBAvYI7/4DBPj49P0DBfwEBP7+9vwC9/36++z++P31Bfr/CgQMBQIH/QbzBQX/BPsA+gH+9v4ACwD+/fT6AvgB/fsA/RED/AAJ/gEIBQX5+AkABwIA/P3x+voFCAcBAgT8AAwEA/sC/P32/QAE8AD/AQP1BPYKCP8AAAMFCQkHAgYC9w8HAP36BgP1BwkNAwr7/vf6+fv4AQn18/0ABgUDAwQD/f8DBxIG/wH+Cf77Bv4K8vsCBAT/+QQD///5/gXx/v4K/wH/DAYIDAD+/P0EBP779Pz2AQH9BAMB/AfzDf0A/wkD+f7+AQkKBPsH/vMD+wT9AQQQAv0F/PgBAQIB+P0F+/8C/Pz5CAQICP0E+QYDCgj/BP8C+fj6Aw/+AwrwBv0E/f3++/D6AQAE+fz8Bwf/+QYL/wL8APf0APkC+fT7AQP9+/kEBgEK8wf7DwP8Agb/AQL/AwAFBPz1A/YDAwj/CwX7C/4GAAIB"
---

PostgreSQL Lock Conflicts

This tool shows all commands and locks in postgres. If you select a command, it lists the locks that it acquires, commands that conflicts with it and commands are allowed to run concurrently with it without conflict. If you select a lock it lists commands that acquire the lock and what are the other conflicting locks.
