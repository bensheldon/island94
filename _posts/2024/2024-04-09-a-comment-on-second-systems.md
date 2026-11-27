---
title: "A comment on Second Systems"
date: 2024-04-09 13:33 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "49fd3f8451d41b87"
  vector: "+wEL+wn09AsH/vgHDPsI/Pv1A/38+PQF/Qf5Afz7ARAE/v4EBgf9+PL7Af8A+gj4+frz9Qz6CggAC/X6/vv4BAII/v77BQIA/wQHAP0JBfUHAvcG9vv6+AP8BwAM/w8BBv4CCf4ECfsG+f8B/gAC/QEAAP7+CAYMCf8B/gYGAQD3A/oJ//QDBAL+AwQEBhUB8f8H/vwCBPcBAwT++wAFCP4C+wML9wz/+wX6Agn/BAD3+QMMDQQB+wD3CQf+AgAFAgQKBwEF+ffx+gT2BgAC//wE/QMIAwEB9AcB9gINBQD29fsBBPf59f3/BgEABvr4AvT+/A8G9/0BAvX7Avv+/AYFDQP1+/sA/vr3+wMB/fr/+QYF//f7+Qj+BwYB+//6/wEAAvkA/P3q/f0J/f7y9/MBB//+APr//wH9+/UI/gAABgYHB/76BfwBAQMIBwsL/v70+wwB/fr59/r+AwL+Av8GCfMDBgf5+wH9CAL59AP9/wgD/gwI/wUB+wUDBAMF"
---


I recently left this comment on a Pragmatic Engineer review of Fred Brook's _Mythical Man Month_ in ["What Changed in 50 Years of Computing: Part 2"](https://newsletter.pragmaticengineer.com/p/what-changed-in-50-years-of-computing-8d0). This was what I reacted to:

<blockquote markdown=1>

**Software design and “the second-system effect”**

Brooks covers an interesting phenomenon in Chapter 5: “The Second-System Effect.” He states that architects tend to design their first system well, but they over-engineer the second one, and carry this over-engineering habit on to future systems.

> “This second system is the most dangerous system a [person] ever designs. When [they] do this and [their] third and later ones, [their] prior experiences will confirm each other as to the general characteristics of such systems, and their differences will identify those parts of [their] experience that are particular and not generalizable.”
>
> The general tendency is to over-design the second system, using all the ideas and frills that were sidetracked on the first one.”

I can see this observation making sense at a time when:

- Designing a system took nearly a year
- System designs were not circulated, pre-internet
- Architects were separated from “implementers”

Today, all these assumptions are wrong:

- Designing systems takes weeks, not years
- System designs are commonly written down and critiqued by others. We cover more in the article, Engineering Planning with RFCs, Design Documents and ADRs
- “Hands-off architects” are increasingly rare at startups, scaleups, and Big Tech

As a result, engineers design more than one or two systems in a year and get more feedback, so this “second-system effect” is likely nonexistent.

</blockquote>

And this was my comment/reaction:

<blockquote markdown=1>

I think the Second-System Effect is still very present.

I would say it most frequently manifests as a result of not recognizing Gall's Law: "all complex systems that work evolved from simpler systems that worked."

What trips people up is usually that they start from a place of "X feature is hard to achieve in the current system" and then they start designing/architecting _for_ that feature and not recognizing all of the other table-stakes necessities and Chesterton Fences of the current system, which only are recognized and bolted on late in the implementation when it is more difficult and complicated.

The phrase "10 years of experience, or 1 year of experience 10 times" comes to mind when thinking of people who only have the experience of implementing a new system once and trivially, and do not have the experience of growing and supporting and maintaining a system they designed over a meaningful lifecycle.

</blockquote>

Which also reminds me of a [recent callback](https://www.simplermachines.com/exploration-tidying-ecto/) to a [Will Larson review of Kent Beck's _Tidy First_](https://lethain.com/notes-on-tidy-first/) about growing software:

<blockquote markdown=1>

I really enjoyed this book, and reading it I flipped between three predominant thoughts:

- I’ve never seen a team that works this way–do any teams work this way?
- Most of the ways I’ve seen teams work fall into the “never tidy” camp, which is sort of an implicit belief that software can’t get much better except by replacing it entirely. Which is a bit depressing, if you really think about it
- Wouldn’t it be inspiring to live in a world where your team believes that software can actually improve without replacing it entirely?

</blockquote>
