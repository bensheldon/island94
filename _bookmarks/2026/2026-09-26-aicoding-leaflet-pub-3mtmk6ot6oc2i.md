---
link: https://aicoding.leaflet.pub/3mtmk6ot6oc2i
date: 2026-09-26 15:51 UTC
published: true
title: Most of Your Architecture Was Just Expensive Code - The Phoenix Architecture
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "5823fb66bd0000a8"
  vector: "AAL9+gH3+gcKA/YEAAAB/wH9+AAAAfP/+wgD/AP5Bg8EBAYMAfoE/fYGAAAD/P70+/T1/f71/AgLC/T5+QD+AgID+v0J/AL9A/kIAwIKBfIG/vgOAwMG/QwAB/sGABgJ+vb8CvsCBP0BAAgE/v0AAAYCB/3+AwAJAAD9BwABAQD8BAIABfQI/wX/Cv/9Bg3/8P4EAPoFBfT+BP/+9/8BCf8I/AUB9AD7AAMC/w79+fvx+QULDgH4+P4CBAcC/wISBgT7CgYE+wD1APv2/fn++fwK/QIJ/AIBAQz++f0KBwD79/j5+Pfz8vkA/wQD//z4//MC/QgN9f8ABfgKDv39Av4EAwz+Af/99vj4+wj+AAIC9wgGA/v+BwoDBgb+A/v5/gL++Pv//QLrBgQC+AT4+fj8AwAD//39AAH9//kA8gAAAAYLB/oBCPkA/P//DwYG/fj5+Af5+P759v0IAAoHCAQF//0I+gjy/QUGAAf89wECA/8F+AQJ+wb2AQkBAwH3"
---

But the history of software has quietly mixed together two very different reasons a thing can be hard to change.

Some decisions are hard to change because their meaning is deeply embedded in the system.

Others are hard to change because rewriting the implementation is expensive.

---

Which gives us a useful test:

If I regenerated the system tomorrow and this changed, would I care?
If the answer is no, the thing may have been an implementation choice masquerading as architecture because changing it used to be expensive.

If the answer is yes, ask why. The answer will usually point at a boundary, invariant, authority, dependency rule, interface, or safety property that gives the system its shape.

Call it the regeneration test for architecture.

---

In 1985, Peter Naur's Programming as Theory Building argued that the primary product of programming isn't the program text. Programmers build a theory of the problem and its solution. A mental model that lets them explain the system, modify it, and reason about cases the source never explicitly captured.

This is one of the deepest roots of the current cognitive-debt worry.

When a programmer builds software by hand, some of that theory develops almost by accident. You remember the awkward branch because you wrote it. You know why the abstraction is strange because you tried two others first. You can picture the call path because you spent an afternoon stepping through it.

Agentic coding can strip out that incidental learning.

---

Architectural judgment has historically been learned partly by writing software, making mistakes, debugging it, and living with the consequences. If agents increasingly remove that apprenticeship path, we'll need another way to teach engineers how to form the theory that architecture depends on.

I don't think we know what that path looks like yet.

For now, the important thing is not to confuse preserving the theory with preserving every line we happened to learn it through.

If human understanding stays tied exclusively to today's generated source, we've built an architecture that depends on the scarcity of code.

That scarcity is disappearing.
