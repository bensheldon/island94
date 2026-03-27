---
title: "So you're thinking about performance"
date: 2025-08-05 15:42 UTC
published: true
tags: []
---

I see this general question come up in two ways: How can I convince my boss/CTO to let me do performance work? Or how do I convince or incentivize my peers so that when choosing between doing performance work and not doing it at all the points in the software development lifecycle, they do the perf work? How can I best justify/self-beneficially celebrate the performance work I have already done or the work I intend to do regardless of what other people explicitly tell me? If you’re doing the latter, p75 is the correct answer. Non-p related you might also do something like sum total request time across all requests in a given time period and show the difference, cause then you might be able to make an infrastructure-related number too (“this change reduced total weekday web utilization by 10% and therefore reduces the number of webservers we have to provision / reduces COGS / shifts growth planning”). If it’s the former though, that’s harder. Cause you probably want to measure improvements to p75, and you also want to lock in p99 and max, so that no one is incentivized to make p75 faster at the expense of a minority of requests (seen it happen!). Though I guess while I’m standing on my soapbox, I would also suggest: If you’re talking about web stuff, go with Core Web Vitals. I think that’s easiest to justify, there are already targets that you’re probably not meeting. It’s ludicrously documented. If you’re just looking at backend server request latency, choose a scaleabaility/capacity metric as your topline number, and then do what I said earlier about targeting p75, but with a backstop at p99 and max. Whew, I’m gonna copy and paste this to my blog :smile:

<blockquote markdown="1">



</blockquote>
