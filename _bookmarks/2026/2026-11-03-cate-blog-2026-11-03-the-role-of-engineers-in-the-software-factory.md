---
link: https://cate.blog/2026/11/03/the-role-of-engineers-in-the-software-factory/
date: 2026-11-03 16:16 UTC
published: true
title: The role of engineers in the software factory
tags: []
---

Which is all very tidy, but the process often isn’t. I went from under-snapshotting to over-snapshotting before finding (I hope; still TBD) a middle ground. I spent hours reviewing Chromatic diffs. Phone-width checks flaked because fonts hadn’t loaded yet. Browsers disconnected mid-run. I cut snapshots that added nothing, and found a few stories that weren’t capturing what we thought they were.

This is where the real learning curve is. It’s also where the work is. Turning on mobile snapshots was one decision; making them catch the right things without failing on fonts or burying me in diffs has taken two weeks and is still in progress. It’s why I think software engineers will still be employed despite how good Claude is at writing code: maintaining systems of this size is just hard.

Even when the bug is fixed, the system still needs work. Which is, I guess, why some people find AI so wasteful: what a vast amount of work to not have a button in the wrong place. But the point isn’t the button; it’s a system that ships product to your standards.
