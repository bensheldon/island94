---
link: https://explosion.ai/blog/against-llm-maximalism
date: 2023-09-10 16:34 UTC
published: true
title: Against LLM maximalism · Explosion
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "ea77e4103ab51b05"
  vector: "A/4F/Az/+gf/BvwHCAgQCxED//oBCAD//AUCAAX7/wz5AwAG+wD6/fr9//8L+v//9AH0+AIC/AIG/vf2+vb1//8B/AoCBgcE/wn6/wr9C/sCCf8DBPsABgD/B/cC/QECBPcBAf8H/fT7/wEACfYECAD9BO0J+QQH9Af/Bfv6+gAG//oECAEECf4AAAT+/AsA+AP9/gD3BvwABggCCwMD/PkJBQn1BQT3+wMEAfoD/vX7/A/7+fsDAvn7AggA/QIHCP79/gXxA/77Awb1CvoABAgEBQEJ+fv6+gz8+/4Q/gD3//0I/vn5BAD7/PwB/QL79/n+AgQM7gj9Be38AgYE+/v88gEGBQMHAQf3Af/6+voSA/76/Pj6+Abv+vv3Bgj9B/z9A/j1AAH0BAT9APv3+Ab7AwsACQr+AQL9Bv4MAQDz+gT//P/7Egj/AwLz/wYFDQD8AwgF+wIR9PwGAAP5BP0LBAIF9Pf2/wv8BAP/AvT8A/z9AwEFBAr+Af//BQIK"
---

However, LLMs are not a direct solution to most of the NLP use-cases companies have been working on. They are extremely useful, but if you want to deliver reliable software you can improve over time, you can’t just write a prompt and call it a day. Once you’re past prototyping and want to deliver the best system you can, supervised learning will often give you better efficiency, accuracy and reliability than in-context learning for non-generative tasks — tasks where there is a specific right answer that you want the model to find. Applying rules and logic around your models to do data transformations or handle cases that can be fully enumerated is also extremely important.
