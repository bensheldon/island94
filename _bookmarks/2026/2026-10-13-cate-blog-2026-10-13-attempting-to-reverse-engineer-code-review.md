---
link: https://cate.blog/2026/10/13/attempting-to-reverse-engineer-code-review/
date: 2026-10-13 14:39 UTC
published: true
title: Attempting to reverse engineer code review
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "dfcc80a3f30b5edd"
  vector: "/QL6Bwz9/QH6CQEA+vz2AQv1+wP5+wAB/AX1/Pv/+ggBCvgFB/gBAfgGAQgF/ADy/f0EBwb4/f4HAQIB+//7AwQA+/sD/fcCBAEFCvcC/ukC/wAOCv8G/gkGA/sCAg4F/vwBCAILA/v+AAL9AgT9CgP+DQECAQIJAf8H+xQLAQD+/f4H+f4FBPwE+gUDCAgL+P/3AwPyAPr89fYD/wT0AgUG/v0AAAQAB/35+AEB+/z5/AoKDgT3/wX0AQoJEvn/AAT+A//29Pvy/AD/AwME+Af/A/n88/j4/vn8/wn9CAD09PkG9PT39AUA9/AEBPv78/wJABENBQX6CQb7AvgEAAMDCP/4Df8K/Qf8+v4HAPz8+v4DBQXy/gX9Bw///QP4+gENAAAB+vz0AwMK/fj6AADxAQMB+/v+AAEA+AD2/AD/AQYHCfz9Bv7+AwT6+QkF+gn3AAb++///+QcAAwUFBfz89AQO+Qf//f/8/f3++AH/+QgA/A0KBPf7AAMCAwgC"
---

So what is review doing? Enforcing things the team hasn’t necessarily agreed to. Some of what reviewers raised was really shared: everybody flagged leftover dead and debug code. A lot of it wasn’t. Dependency injection, the architecture rule that came up most, was raised by only half the reviewers. Asking for missing tests was something seven of the twelve did over the 20 months, but in the six weeks I audited, review asked for tests only about 14% of the time, mostly humans. And in 16 places a reviewer’s norm got pushed back on, and in a few of them reviewers wanted opposite things: for instance, whether a feature flag should be read at runtime or once at launch.

These are all reasonable stances to take, and it’s possible they were situationally dependent in ways that I don’t have insight into. But from this data, and for an individual onboarding, it would be hard to distinguish a team norm from one person’s preference. It’s muddier still when, as here, some of what read as a reviewer’s judgement was actually AI output transferred via C+P.
