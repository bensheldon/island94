---
title: "Conflicted and commingled"
date: 2025-10-26 23:39 UTC
published: true
tags: [stories]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "0496217c6a8cbaa6"
  vector: "+gf/+Aj+BgcH//8P/AP7BAP79Q///gMC+QQC/ff7Bw38AQf79wgEAQT6/gP+9wkIAQDz9v77+/4FBfn+AP8BBAf/BwQCAA4A/gUABgMKDPX///z8APkC/Qf8AfQN/QMFAwEJCAgJ+fMB/P3+AQL8CQgGBQoEBQT+AAj1A/z+/AADA/4IBQL1/PgJ+wUJ+vQF7/0I/fv+/wnrAgQCAv4ABQYHCAb7+gUF/wMEA/4E8v32Av7/E/78Afr+BAYED/sO8gLy+QP3AQIC/Pv4AAED/wj5/wLs+P70/Qz99gMABQD99gD+Bfv79gH7+v8E/fn+C/z//wwE/AL4CQTxBAD/BPgD//8Q+Pz0AP34Awz7+/0M/v//CAAC+wP9AgkFAPT9+vz//QT8A/n+9A0I//rs/Qb0Bwb9CQH9+wUD9gADBQAJAAEA//QC/f4HBAf7AgUG/Pj6BP0F+Pv+/wP++wP2AAAE+fD9Awf59AP/Bwr7+gkHAwQA/fgABAMC9/ML//z9"
---

More than a decade ago, I was seated on the jury of a civil trial for "complex litigation". I’ll try to keep this quick, but the case does come to mind more frequently than I would have imagined at the time.

In this trial, the plaintiff. a pharmaceutical company. was suing the defendant, a chemistry professor, for fraud. The chemistry professor, as part of his day job at a university, would create a bunch of novel molecules (put a carbon there, or an extra hydrogen here) that the university would test for various interesting bio-medical properties, and then license them to pharmaceutical companies for commercialization.

In this specific instance, the pharmaceutical company licensed a molecule from the university, and then turned around and invited the chemistry professor to join their scientific advisory board and gave the professor some company stock/equity. Fast forward several years and that molecule is now a very valuable drug. And the university _also_ licensed a _different_ molecule to a _different_ company that the chemistry professor _also_ had some equity in.

The alleged fraud was that the chemistry professor didn’t tell that first pharmaceutical company about the other molecule or the other pharmaceutical company… and should have? That was why it went to litigation.

The big picture wasn’t why it stuck in my mind so much as what we did during the *six week* jury trial: we read a lot of really, really old emails that the plaintiffs would paint as evidence of ill-intent and the defense would explain that nothing was very serious in the first place. I’m making the following exchange up, but thematically it was this over and over again:

> Plaintiffs: You must not have been taking your duties very seriously when you replied: “I hope the wine is good winkie-face.”
>
> Defense: Can you read the whole exchange?
>
> Plaintiffs: This was in reply to the scientific advisory board chair writing “The meeting will be brief and then we’ll have dinner together at [nice restuarant]”
>
> Defense: Now this very serious advisory board that you allege our client was taking so unseriously several years ago that you are suing him for fraud today. Was there any written agenda or minutes or notes from those meetings?
>
> Plaintiffs: No.

Lots and lots of that: some personal correspondence recontextualized in a trial against a background of potentially billions of pharmaceutical dollars at stake. Of what I learned:

- Poe’s Law is everywhere: don’t be cute anywhere it might turn into discovery.
- Conflicts of Interest and commingling of personal and employer and contractual stuff can cause lots of problems. And also that creating conflicts of interest _is a strategy_ for muddying the water.
- Complexity causes problems.

On that last point, during the trial there was an entire plaintiff subplot of “but maybe actually it’s the same molecule.” The plaintiffs spent a whole day at least explaining benzene rings. Which was all of a theme to make the chemistry professor appear extra deceptive, like “it’s just one more carbon atom, how dumb do you think we are?!” And then at the end after several objections the judge was like “I’ve already ruled that they’re different molecules and the university owns them and can license them to whoever they want.” Any potential for confusion seemed to be taken advantage of in arguments to set a tone.

Anyways, I’ve been telling this story a lot to people in the context of Ruby Central / Rubygems drama. Usually with the explainer of “totally random, but did ever tell you about the really long jury trial I was part of? It was a lot.”
