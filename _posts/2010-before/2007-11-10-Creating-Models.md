---
title: Creating Models
date: '2007-11-10'
tags:
- biology
- education
- math
- modeling
- philosophy
wp:post_type: post
redirect_from:
- node/172
- creating-models
- 2007/11/creating-models/
- "?p=172"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "4a3a5349a812a523"
  vector: "AAb+/QMA+QkKDAYEBAv+AfMG8/8CAvoA9f7++f0EAgUG+/UFAAP+BQMCAAMG/PcCBvr6/fYGCfTz9vD2/QP9/gcE+Qb9E/wE9wb/+QAIBQkGBAgEAPv/Agn4+gUJBv4OBvsFCPj2AvwB9QAEBgD/BwAIBPIE/QH/BAIE+QkG/gD9/g4LBQD6BxAH+P0FCQIE/AoB/P37//0EB/38+/8HBfb3+Qv8/wH1+gQBAAEFCfvz/v8ABvr/BgAE+QYB/AgFCPz89goBAALw/v33DPb9Av75Bfr9AAn++ff7AQP+/wD3AfX4AAP6Bf35AAYJA/kA//T+/vUF8vn7C/kBAgD5+AAA+wkJ/wb7/wD2/gr/BwQG/wQC+gAA/QHtAgD2+/gR9gEABgH6+gX6AgD4/AH+AQD2Cvf59gj//wnxAP4I9wAICwr9AQH0BQEE/AkADgMEAgH6AP8H+f0X/gQFAf/4B/wR+wAA+wX5AAP2BBEDBP0A/AIG//77Af0EAPoDAPkB"
---

I'm taking Mathematical Models in Biology and we had an interesting problem in our last class. We were broken up into groups and asked to create a model around malaria infection. We received some information on mosquito behavior and lifecycles, infection rates and patterns, and effects. That was it.

The primary tenet of mathematical modeling is simplification. We quickly realized that when trying to simplify the process, we needed to know what information we wanted to gain from the model. The standard (and incredibly simple) SIR model, for example, answers the question "how many people will be infected at any one time?", not necessarily, "how many will recover or die?".

To put it into mathematical terms, if we're going to reduce the number of dimensions (by simplifying), we want to make sure that the information we're left with has useful meaning _for the situation_.

Which also leads me to thinking about reductionism and holism.
