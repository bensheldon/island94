---
link: https://norvilis.com/dear-future-me-how-to-write-code-you-won-t-hate-in-6-months/
date: 2026-02-28 21:30 UTC
published: true
title: 'Dear Future Me: How to Write Code You Won’t Hate in 6 Months'
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "f8ac6461f9b82aea"
  vector: "9wT6Av/+9wP4BPsG/voAAgT8/v0F9PUCAf0IDP38AwgG9wQR+/f+/fn8/AAG8vr/BQP2/Pn+/Qf6/Pnx/Pv7/wEEAgcCBvv+APsBAQgB/+79APYL/PkFAwr6EgAP8/0G9QADBAAAA/kA/gAJ//4ACAL2BAv3/AIEBAby/Af5+wAEAQMDBgMGAfcHBAf8AAf4/Aj9Avzw9PsKBQj9/v4JA//9Agfy/wT5+Af2AQMHB/0I/wAECgT++AQCCgn+/v0K+Az+9Aj4/QIM/QT7Afz8/P0C+gAS9wgBBAL4+gMABAAA+PwH/vz+CQ0B/gUB/voC/PEBBfcK9RACCgAD/ffz8/n7A/n9Bf8LCvf5/P/9/v/9+PwD/wMB+wL9ABD8Agn//vkH9wIA/gIABQL6AP//CP4GBAgDCQH9+/j5+wgK+wD//gwCBvgEDPoCEfv8AAUKBAX2+wcBAQQFAg4IBAEAAA4GBfb+BgYC/QX2/wj68PYA+/z5BwQI/QQCBQMI/vcH"
---

big companies, they use “Architecture Decision Records” (ADRs). They are formal documents. You don’t need that. You just need a markdown file in your root folder called decisions.md.

When you make a big tech choice, write 3 sentences.

Date: 2026-02-03
Decision: Switched from Sidekiq to Solid Queue.
Why: I didn’t want to pay $15/mo for a Redis instance on Render. Solid Queue handles my volume (50 jobs/day) fine.
Why this matters: In a year, you will read a blog post saying “Sidekiq is faster!” and you will feel the urge to refactor. You check this file, realize your constraints haven’t changed, and you save yourself a week of wasted work.
