---
link: https://cate.blog/2026/11/03/the-role-of-engineers-in-the-software-factory/
date: 2026-11-03 16:16 UTC
published: true
title: The role of engineers in the software factory
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "4e407a816667f811"
  vector: "+wMH/gP6Bf7+BP0FAv39/Abx9AX7AwX7Awb8/AT6AAgKBfwICv8F/v8A/QUH+wj4BPfy/AAH/gMDBQYFAQL2BQsCAwH8B/sGBAkB/Qf2/vwB9QYLAwME9QUF/vgJ/v0CCQABD///A/n9/wT7/fsC/vv7BvX4AgX/BwL6Afv3BAAFDfwJAPwAAAYDDAzxAAoH9wj8CP/1+wL8/AUAAv/1Awz9//379wEG9gr5/gUEBfvwAAEGB/z8AQnuAQkDAfkM+wwDC/8A+vz5///9AfkF+gcE9vYO9/70CAr1+QP8+QD3+/QH9/z/CQQF/AH7AP36C/f89AkKAwn7Cvn3//QI+fcGBPz2EQEE/f78CgABAfsD/wgCAwH/9wAB/AP//Pv4/wD/B/z3Avb8Bvj//P379/r5BvwEBwX3Bf35AvUL/QD8/gMA/AP5BwMKBv3+DxEIA/vzCgIBAQL+/P8MAhQJBgL7A/cJAAgD+QgAA/r6+wb9AAQAAQkL9gIAAAcM/AAG"
---

Which is all very tidy, but the process often isn’t. I went from under-snapshotting to over-snapshotting before finding (I hope; still TBD) a middle ground. I spent hours reviewing Chromatic diffs. Phone-width checks flaked because fonts hadn’t loaded yet. Browsers disconnected mid-run. I cut snapshots that added nothing, and found a few stories that weren’t capturing what we thought they were.

This is where the real learning curve is. It’s also where the work is. Turning on mobile snapshots was one decision; making them catch the right things without failing on fonts or burying me in diffs has taken two weeks and is still in progress. It’s why I think software engineers will still be employed despite how good Claude is at writing code: maintaining systems of this size is just hard.

Even when the bug is fixed, the system still needs work. Which is, I guess, why some people find AI so wasteful: what a vast amount of work to not have a button in the wrong place. But the point isn’t the button; it’s a system that ships product to your standards.
