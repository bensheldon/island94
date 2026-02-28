---
link: https://norvilis.com/dear-future-me-how-to-write-code-you-won-t-hate-in-6-months/
date: 2026-02-28 21:30 UTC
published: true
title: 'Dear Future Me: How to Write Code You Won’t Hate in 6 Months'
tags: []
---

big companies, they use “Architecture Decision Records” (ADRs). They are formal documents. You don’t need that. You just need a markdown file in your root folder called decisions.md.

When you make a big tech choice, write 3 sentences.

Date: 2026-02-03
Decision: Switched from Sidekiq to Solid Queue.
Why: I didn’t want to pay $15/mo for a Redis instance on Render. Solid Queue handles my volume (50 jobs/day) fine.
Why this matters: In a year, you will read a blog post saying “Sidekiq is faster!” and you will feel the urge to refactor. You check this file, realize your constraints haven’t changed, and you save yourself a week of wasted work.
