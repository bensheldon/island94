---
title: "Low-effort prototyping"
date: 2024-03-26 06:28 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "017255b4aa5913fc"
  vector: "+wAG/wLy9ggEA/r9///+9wj7AQD68wL//QH9/An/Agv9+gkJAAgD+/39+goH/Af0+vX3+P/z/QQKAgH//fj89AoCCQADDgcG+gkI/gb/A/YEAvsB9gABCAn7/wP2+AEFCf/7AgIGDfT++v0B/AT+AAEJ/gP8+ggRBAMABP4B/AD/Cv4FAPYLBf0BAQH8Cwv0/AH4/vjrAv0J+gQC+QD9CP0E/foJ9QoE9wQDAwEFBQD1AAENA/oB+gP0Bgn/AvMQ+AQBDQcB/vkC6g4FCfz++wAM+f4F9wAE9wD3/PoD+wAE8gMICvv78P39/f34APz3/wAP/QkE+vz5Avf////5+wIAAwr+DAf7/wD5/P/++/gGCw4JAPf5+wb2Agz9/QX+A/8FBQcA/gX7Af4C/v4A+f8DAfz4CvYC/gUCAQMMAAAH/wr6DP0CBwL9B/YJDgcEA/z2+QIJ//n69f8EAvz7BPwIB/b///3/+wQAAALy9fsABQQEAAMEDP/6/wkG+v4C"
---

From Bunnie Hung's blog about [exploring and designing an infrared chip imaging rig](https://www.bunniestudios.com/blog/?p=7035). I thought this is an interesting distinction between "low-effort" and "rapid" prototypes. I think the analogy in software would be a ["Walking Skeleton](https://wiki.c2.com/?WalkingSkeleton") that is production-like in architecture and deployment but does very little, versus building a demo using lightweight scripting and static site generators. (bolded text mine)

<blockquote markdown="1">

**Sidebar: Iterate Through Low-Effort Prototypes (and not Rapid Prototypes)**

With a rough idea of the problem I’m trying to solve, the next step is build some low-effort prototypes and learn why my ideas are flawed.

I purposely call this “low-effort” instead of “rapid” prototypes. “Rapid prototyping” sets the expectation that we should invest in tooling so that we can think of an idea in the morning and have it on the lab bench by the afternoon, under the theory that faster iterations means faster progress.

The problem with rapid prototyping is that it differs significantly from production processes. **When you iterate using a tool that doesn’t mimic your production process, what you get is a solution that works in the lab, but is not suitable for production.** This conclusion shouldn’t be too surprising – evolutionary processes respond to all selective pressures in the environment, not just the abstract goals of a project. For example, parts optimized for 3D printing consider factors like scaffolding, but have no concern for undercuts and cavities that are impossible to produce with CNC processes. Meanwhile CNC parts will gravitate toward base dimensions that match bar stock, while minimizing the number of reference changes necessary during processing.

So, I try to prototype using production processes – but with low-effort. “Low-effort” means reducing the designer’s total cognitive load, even if it comes at the cost of a longer processing time. Low effort prototyping may require more patience, but also requires less attention. It turns out that prototyping-in-production is feasible, and is actually the standard practice in vibrant hardware ecosystems like Shenzhen. The main trade-off is that instead of having an idea that morning and a prototype on your desk by the afternoon, it might take a few days. And yes – of course there ways to shave those few days down (already anticipating the comments informing me of this cool trick to speed things up) – but **the whole point is to not be distracted by the obsession of shortening cycle times, and spend more attention on the design. Increasing the time between generations by an order of magnitude might seem fatally slow for a convergent process, but the direction of convergence matters as much as the speed of convergence.**

More importantly, if I were driving a PCB printer, CNC, or pick-and-place machine by myself, I’d be spending all morning getting that prototype on my desk. **By ordering my prototypes from third party service providers, I can spend my time on something else. It also forces me to generate better documentation at each iteration, making it easier to retrace my footsteps when I mess up.** Generally, I shoot for an iteration to take 2-4 weeks – an eternity, I suppose, by Silicon Valley metrics – but the two-week mark is nice because I can achieve it with almost no cognitive burden, and no expedite fees.

I then spend at least several days to weeks characterizing the results of each iteration. It usually takes about 3-4 iterations for me to converge on a workable solution – about a few months in total. I know, people are often shocked when I admit to them that I think it will take me some years to finish this project.

A manager charged with optimizing innovation would point out that if I could cut the weeks out where I’m waiting to get the prototype back, I could improve the time constant on an exponential and therefore I’d be so much more productive: the compounding gains are so compelling that we should drop everything and invest heavily in rapid prototyping.

However, this calculus misses the point that I should be spending a good chunk of time evaluating and improving each iteration. **If I’m able to think of the next improvement within a few minutes of receiving the prototype, then I wasn’t imaginative enough in designing that iteration.**

That’s the other failure of rapid prototyping: when there’s near zero cost to iterate, it doesn’t pay to put anything more than near zero effort into coming up with the next iteration. Rapid-prototyping iterations are faster, but in much smaller steps. In contrast, with low-effort prototyping, I feel less pressure to rush. My deliberative process is no longer the limiting factor for progress; I can ponder without stress, and take the time to document. This means I can make more progress every step, and so I need to take fewer steps.

</blockquote>
