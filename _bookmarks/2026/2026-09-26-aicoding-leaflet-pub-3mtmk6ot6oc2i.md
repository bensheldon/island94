---
link: https://aicoding.leaflet.pub/3mtmk6ot6oc2i
date: 2026-09-26 15:51 UTC
published: true
title: Most of Your Architecture Was Just Expensive Code - The Phoenix Architecture
tags: []
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
