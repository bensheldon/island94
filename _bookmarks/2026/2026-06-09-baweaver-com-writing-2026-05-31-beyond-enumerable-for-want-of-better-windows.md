---
link: https://baweaver.com/writing/2026/05/31/beyond-enumerable-for-want-of-better-windows/
date: 2026-06-09 14:23 UTC
published: true
title: 'Beyond Enumerable: For Want of Better Windows'
tags: []
---

> There’s a broader lesson here worth naming. Sometimes the most Ruby-like thing you can give your users requires un-Ruby-like things underneath. Mutable state, manual iteration, yielding into blocks instead of returning composable objects. That’s not necessarily a compromise. The 600k-object version was “more Ruby” in its internals (Enumerators! Enumerable! Snapshots!) but it cost more in every dimension the caller cares about: memory, speed, and cognitive overhead of understanding what gets allocated where. The version that feels like Ruby to use is the one that made deliberate, pragmatic choices about what happens inside. Good abstractions aren’t obligated to be built from the same patterns they present. The standard library makes this same tradeoff everywhere: Array#sort is C, each_cons is C, Hash is C. They present a Ruby-like surface backed by whatever implementation serves the caller best, and nobody objects.
