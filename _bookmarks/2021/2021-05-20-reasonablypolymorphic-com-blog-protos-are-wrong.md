---
link: https://reasonablypolymorphic.com/blog/protos-are-wrong/
date: 2021-05-20 16:00 UTC
published: true
title: 'Protobuffers Are Wrong :: Reasonably Polymorphic'
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "a7025e95fe126233"
  vector: "//0J9vv4Awn8APf6/AL59Q33/vz+9AL/AwL/8AP6/AYCAAIBAAMA/Qbz9AIC/gP8/v79+AAB+f4FBAQJ9vkB/wwLDPz+Af8E+QoBAv8FCPkA/PsL//0AAgT7/wwBAf39AfcG/gkJEfv9/gELCAUAB/8DBP/0/g0HAQD6/f3/9AD7Bv/79/7/BPv59wn/Dw8D/QMG/f75A/kE+vME9wT6/AUDAPcC9f8AAQcG+v4AA/j4AAUKBf0CAQb4Bgn8Cv8N+f//Df0DBP4N/PoBAv34BP8CCPv9AQ3++Qj3/AH/+AD/Av8NAPsM+v0A+wUE/P75//AF9QgB/AcAAfUA+QH+/Ab7CfwBAwr+//z68gcA+voBAhEO//b3AwUH/gEB+AH/9gAK///8+/kEBPIFAv8CBQQHCAIHAvUB/wT6+u4GAQAK/QYHBPYBAQYBCvb1CwsJ/vP0+foK9vwF+QMG/fz4AfoAEf0AAwEFAQIA/wr99A4ADwYB+wgG9vn6+gcM/gf6"
---

At the root of the problem is that Google conflates the meaning of data with its physical representation. When you’re at Google scale, this sort of thing probably makes sense. After all, they have an internal tool that allows you to compare the finances behind programmer hours vs network utilization vs the cost to store
x
x
 bytes vs all sorts of other things. Unlike most companies in the tech space, paying engineers is one of Google’s smallest expenses. Financially it makes sense for them to waste programmers’ time in order to shave off a few bytes.

Outside of the top five tech companies, none of us is within five orders of magnitude of being Google scale. Your startup cannot afford to waste engineer hours on shaving off bytes. But shaving off bytes and wasting programmers’ time in the process is exactly what protobuffers are optimized for.

Let’s face it. You are not Google scale and you never will be. Stop cargo-culting technology just because “Google uses it” and therefore “it’s an industry best-practice.”
