---
link: https://baweaver.com/writing/2026/05/31/beyond-enumerable-for-want-of-better-windows/
date: 2026-06-09 14:23 UTC
published: true
title: 'Beyond Enumerable: For Want of Better Windows'
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2b1a43585b993b12"
  vector: "+f31BQIA/An+BfQJAAEAAw7++wH9/wED/AP5+gH6/wkFCfr6APz6+vQM8AH7/Qb7Avf9Cv37APn/9vz//v7/AQT4AwMH/wED+wMB+AX7+QD6Avj/BAMCBwEEAgENBgUDBgH3AwECC/kC9goF/vkI+QX//vgFAhAHCwoEAfsE/AD//fYKAgQI/QUABhIABxAE/gf6BAH/+wD8AP//AgADBwIADwD/AAfsAAb+AwL7/Q39+gYFBQcC8woE/wn+/QYHAfb5DgEI9wv5DPvzBPP4AgIK9gH+/wIC/fcA/gX7/wAE+wIE/AEE8/749wMPARH29/L/9fgJ+/0AAer9Av0F/gAB9gEKAPr9Bv//Av8J+/8CCAgD+gAF9/YAAAP9BAEC8gIC/v/w+Pr3/wMOBPv5APL+/QcKAAD8+wEE+fwJ/AD+AQAA/gT9Bf8FC/r5CgkH/vr7CwH8+AT4APcC/gIKAQUKAP/1DPj8A/n7Avv28/36AfIDAQUBCAHzAwYE9/oJ"
---

> There’s a broader lesson here worth naming. Sometimes the most Ruby-like thing you can give your users requires un-Ruby-like things underneath. Mutable state, manual iteration, yielding into blocks instead of returning composable objects. That’s not necessarily a compromise. The 600k-object version was “more Ruby” in its internals (Enumerators! Enumerable! Snapshots!) but it cost more in every dimension the caller cares about: memory, speed, and cognitive overhead of understanding what gets allocated where. The version that feels like Ruby to use is the one that made deliberate, pragmatic choices about what happens inside. Good abstractions aren’t obligated to be built from the same patterns they present. The standard library makes this same tradeoff everywhere: Array#sort is C, each_cons is C, Hash is C. They present a Ruby-like surface backed by whatever implementation serves the caller best, and nobody objects.
