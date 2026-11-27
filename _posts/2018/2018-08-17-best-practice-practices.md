---
published: true
title: Best Practice Practices
date: '2018-08-17 20:26 -0700'
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "cba3cb9aa789b166"
  vector: "AAb++vwC+Qr6BQASCP4EAf7+Bgn3/gMG+QD/+Qr8/Ar//PsMAwUHBgD+/fkAAAj49/n2Avz7CgUH+gf/Av/0/P0BAQcBBvYGAw8AAwQA/vEABAsD/wcA/gX8CAH9/A8I//j6/wsB/fv+9f7+/QX/CvX8AwD+AgAF/gwQ+gACBQAF/vAD/f0B/woDA/0A+wMC8gj0A/r7AfoCBQf/+wL/+f/6CQr5/wMG+wME+wwI/vYB/gUDBPv+Agj6/gT9AvII9/38+QbtAAT09ADwBQf5/gAI/P8FAAoD/wQC/f0DAgAD+Q0PCAP78/79/vv6+fz89/QI+wECBAkB/f36//cDAAD99QL8AAMJBAf6AfYD/vb//gL3+/ED/wP7/QADCP7+A/8EBfsC6Qb2AvsFBPv7APv99wP2BQP3/AD1CfsIAgD+BQQCAAH7DfsG+QEECgT0CQPx+ggJB/cI+ggHAfz8CAIEAf0CBgoM/AIKA/L99wj99f7/DAIGDwD1APn6CfkL"
---
I like how _Rapid Development: Taming Wild Software Schedules_ by by Steve McConnell lays out exactly how "Best Practices" were selected or rejected:

<blockquote markdown="1">

### Summary of Best-Practice Candidates

Each practice described in a best-practice chapter has been chosen for one of the following reasons:

- Reduction of development schedules
- Reduction of perceived development schedules by making progress more visible
- Reduction of schedule volatility, thus reducing the chance of a runaway project

Some of the best practices are described in Part I of this book, and those best practices are merely summarized in this part of the book.

You might ask, "Why did you ignore Object-Structured FooBar Charts, which happen to be my favorite practice?" That's a fair question and one that I struggled with throughout the creation of this book. A candidate for best-practice status could have been excluded for any of several reasons.

**Fundamental development practices.** Many best-practice candidates fell into the category of fundamental development practices. One of the challenges in writing this book has been to keep it from turning into a general software-engineering handbook. In order to keep the book to a manageable size, I introduce those practices in Chapter 2, "Software Development Fundamentals" and provide references to other sources of information. A lot of information is available from other sources on the fundamental practices.

In a few cases, you might rightly consider a practice to be a fundamental one, but if it has a profound impact on development speed, I included it as a best-practice chapter anyway.

**Best philosophy, but not best practice.** Some best-practice candidates seemed to be more like theories or philosophies than practices. The distinction between theory, practice, and philosophy in software development is not clear, and so an approach that I call a "philosophy" you might call a "practice" and vice versa. Regardless of what it's called, if I considered it to be "best," I discussed it in the book somewhere. But if I considered it to be a philosophy, it's in the first or second part of the book. (See Table III-1 for a list of where each best philosophy is discussed.)

Best practice, maybe, but not for development speed. Some best-practice candidates might very well be best practices for their effect on quality or usability, but they could not pass the tests of improving actual development schedules, perceived schedules, or schedule volatility. Those practices were not included in this book.

**Insufficient evidence for a practice's efficacy.** A few promising practices were not supported by enough evidence to deem them to be best practices. If the development community has not yet had enough experience with a practice to publish a handful of experiments or experience reports about it, I didn't include it. Some of the practices that fell into this category will no doubt someday prove that they have large speed benefits, and I'll include those in a future edition of this book.

In a few instances in which published support by itself was not sufficient to justify treating a practice as a best practice, I had personal experience with the practice that convinced me that it was indeed a best practice. I included those in spite of the lack of published support from other sources.

**Questionable evidence for a practice's efficacy.** A few best-practice candidates seemed promising, but the only published information I could find was from vendors or other parties who had vested interests in promoting the practices, so I excluded them.

**Not a best practice.** A few best-practice candidates are highly regarded (even zealously regarded) in some quarters, but that does not make them best practices. In some cases, experience reports indicated that a well-regarded practice typically failed to live up to expectations. In some, a practice is a good practice, but not a best practice. And in some, the practice works fabulously when it works, but it fails too often to be considered a best practice.

In one case (RAD), the candidate practice consisted of a combination of many of the other practices described in this book. That might very well be an effective combination in some circumstances. But because this book advocates selecting rapid-development practices that meet the needs of your specific project, that specific pre-fab combination of practices was not itself considered to be a best practice.
</blockquote>
