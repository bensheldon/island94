---
link: http://www.reddit.com/r/pics/comments/daat6/whole_lotta_boobs_d_de_another_comic/c0yqg1s
date: 2010-11-22 19:34 UTC
published: true
title: Smart Image Cropping Using Entropy
tags:
- image
- howto
- webdesign
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "b435d2b5ef058b42"
  vector: "/w4M+BP1BgQBAAgHAwr3+foF9f4J8AMABf8BAwQBCQsPB/78+Qb/Av78Av0GBf759v/5A/UJBgYG+v0CAwX2/woAAfb4+AEC/AEF9vz9//7++wEA/vkD/QcB/Pr4CQT3+e0B/wP6/AEPBgb/DQEGAfsE/PkBA/7z/AH3BAj+BQD7/P0ABwH9+fwCAf4DDAj5/Av+CfcBBwT9+vX+AQT7/vv9AQQAAgP+AQYM/AEHAgX4BQX7CfsC/wn+AgAD/fkFB/4F/gAH/AcD/PwEAQL9/fQICerzAPn/+Pz+/AYI/QD9Bv8K9PoCBfn5+AL+9vkBAv35BAII/gQBC/8N/QH17wX3AwH5AAUA/f7++foEBQ8ACv0HAA38CvMFBAT++wT+9wf6BPoIBg0OAfv+BAUD/vj7Agf/Av7vBvz+Agn/AwAG9gX7CAEKAwD3BQXwAQX5/wT9APn3BAD8B/YBC/gGBAUHBwX0/f/3AwAI+gIACP0CEAkA9wQF8gb6BAsBBfv+"
---

Basically, A) if the image is taller than it is wide (like the parent image), it B) goes through the image, slicing off 10px at a time off the image, either off the top or the bottom, based on which slice has a lesser entropy.
