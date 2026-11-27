---
title: "Javascript is a management problem"
date: 2022-01-11 11:17 PST
published: true
tags:
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "230d0fb235b5935f"
  vector: "+fwFAAX5+Qn++/kH/AEI+wP8+v359gQGAPnr+f/5BQn8BvsF9/z8+/QB9QkC9Pv4/f798gL2+/j+AQMG/f8CCQn+/fr5AwD4CAcE8/YEB/8C+wARB/8C/QkG/v8KBwD79/31BAEEDPwCAAQCBwUECAb5/fwFAA0QAAj99QUL9QD7DwEE9/oCCvQB/xIFARD6AQcH+gH4/P4AAP8G9wX6A/kG//kA9gUD8f/6+wEEAfv2/vwJBg4J/gH3Bv7++PMD/AQCBv39Bf4A+/z3CQMC/AIBBgAA/gYF+Q/8AQYB+wD69/gCAwD//gP/9wEE/PgG//UIAAMI/goC/PT0+fsD+QUAAgD4AP4C/vv9/QcF+PwG/AMCB/Tz+gMA9QcH/v8BAgECA/0C9/cAA+wJCvj7+AUKDAQCBfoA/gT9AvYEAQADAv/9Av0ABAsP/gH3Ew0L/Ab5Av8N+gEJ+vkEBf34BwAHAQIABAP7/wMKAv0D9gIF/wgJ/gYBBQD5AQUN+P0G"
---
I have been on board with low/no javascript for a long time for a variety of observed and experienced reasons, and grasping around for a succinct explanation. Baldur Bjarnason captures it in [“The Single-Page-App Morality Play”](
https://www.baldurbjarnason.com/2021/single-page-app-morality-play/):

<blockquote markdown="1">

*The problem is management.*

It is a management problem. Truly.

The Multi-Page-App forces the team to narrow the scope to a level they can handle. It puts a hard limit on their technological aspirations. Mandating a traditional Multi-Page-App under the auspices of performance, accessibility, or Search-Engine-Optimisation is a face-saving way to force the hand of management to be more realistic about what their teams can accomplish. When we can accomplish the same by advocating for a specific Single-Page-App toolkit or framework, that’s what most of us nominally on the ‘Anti’ side do. I regularly advocate for Svelte when I think the team can handle its long term implications in terms of complexity. (That might change as Svelte adds more features.)

The problem with Single-Page-App frameworks, even the ones like SvelteKit who could claim to be more Hybrid than just SPA, is that they are very, very eager to enable ‘scale’ of any sort. Features, app size, code complexity, integrations, etc. They are desperate to make sure that you can keep using their framework if you become a mythical ‘unicorn’ startup and your project grows into the next Facebook. So they put a lot of hard work into making sure that there is no upper limit to the scope of the app you can make with them.

Which, when they present it as ‘scale’, sounds like a good thing. But it’s absolutely a bad thing when you’re in an industry that’s as mismanaged as ours. We can’t handle complexity. Having no upper limit to it is extremely bad.

</blockquote>
