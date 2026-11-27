---
link: https://baweaver.com/writing/2026/08/09/beyond-senior-creating-hope/
date: 2026-08-10 14:22 UTC
published: true
title: Beyond Senior - Creating Hope
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "48421cb4de2efdb1"
  vector: "/wAL///88gj+B/sMAf8GAv3w+AD6+PYL/AT3/f/8AA4CAgMKAQD7/f38/fv/8w30/PcA+QX6B/4HA/sJ+AD9/QcAAwEABgT69vwHBAH+CPsHAf0I/v4E/Az5/vwNBgUDBfsECAEGBfr6/AIJ/P0AAAL++/78/QIMAgr8Bf4T/AAA/fwEAP8CA/sDBwkF+w71+gj9AAP0//8F9/4DCwMABfwCAAT9/P/59gb3AQwBA/7y+f4J/wQABQX3CP8D/PYCBQgIAgAD/Pz6/AD8AAMF/QIH+v4E/wr6+Ar6BAIIAwD+9Pn+CP389//+Afr8B/H6Ef4FBAsO7f8BBu/1+/35AgEF/gj4//z6/v/7/wgE9PwCAvr+BQD++QH1+wMFAQEABQQH8wH4Av/3AAYL7v3x/AAD/wT7BQQBAQD18fADAQACB/sAB/X9DAQPAwX+DAIF/gH1/QEI//j8+f0EBPz/AAEFAAH+B//8BAwEBAb88gz99gcE/hQIAAP98QQE9P0C"
---

In my career I have spent a substantial amount of time around large Rails monoliths spanning from hundreds of thousands to millions of lines of code. I’ve watched companies go from enthusiastic to dejected to deeply fatalistic about monoliths as they evolve.

The monolith is too big, Rails is slow, the tests take forever, everything is hopelessly coupled, deployments are dangerous, and no one can hope to understand the entire thing any more. All of those complaints have some truth to them, but there’s also something subtle changing in the language used around this time: The monolith stops being a system containing thousands of tractable problems and itself becomes THE problem.

Once things hit that stage people stop asking questions about what endpoints are slow, what dependencies caused the latest incidents, where engineers are losing time, or what boundaries are creating the most friction to the organization. The problem has become so large that people begin to believe that no individual intervention has any meaning, and so the organization defaults to survival mode.

---

We were an acquired subsidiary on a Rails monolith, and the problems facing us were very rarely scale as much as business cases, so the inclination to break out services would have become a multi-year distraction that did not materially move the business forward.

---

At one company there was a particular table that would consistently brown out the entire database every few weeks, and teams had invested substantial time in extracting it as a service to reduce these issues. The problem wasn’t the monolith, the problem was the thrashing behavior of the database queries being run in one giant unbatched job with significant write contention on mutually locked rows. What should have been a localized optimization became a two year project that failed to deliver on its promises, and in fact made the problem worse, because the team was more fixated on the end-state they wanted rather than the next most logical improvement that would have lightened the load and given them more optionality.
