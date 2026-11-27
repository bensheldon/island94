---
title: "Impenetrable legal language"
date: 2022-10-23 10:40 PDT
published: true
tags:
  - language
  - writing
  - plan language
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "1f021c48e4a9eff4"
  vector: "/QUA+f0LCgoHBwUFAgMO/gMC9QcFEP4FAgD2/Af++QkGDAUAAP4A+v39+gQB/PsM9gDy/foH+fv6B//7+P4BCPv+BgDzCfoD+wf6AAb/AOv8AP79/Pz+/wf/AvMR/Qb8/QMIBgoHA/f9/AD2/v77Af/4/gMABA/7AAj//v73AAD5//MLBgL/BfoFAwAABP4C/QH7CQQHBQX1/gH1AQD+/woFBgL8+QEA9P8G/AQF+AMF/wQCBf8GBfUG+gX/CwcA+wLxAgn5/gLyCv/8Av8B+/YDBAn8+Qj6CAMF+vr8BgD7/fQK8gAE+gf1+vj8+gH7AP8JCQj69wX/APf9/QP7APgA+PcH//r4AwAABf72+PYDAAH+AP7zAgP1//0JCAH9CPn+//32/+/29QgHB/Py+Qb+/A0CCPz+BA0GBPwL+AD3Cff/AfcB9PkD/P759fwJ/QT5DfwK9Pz9CAEJBgUADf/5/v3/AwADAgACARMB9AQG+wIABAMDAwkE/v0KBgv/"
---

From the paper ["What did I sign? A study of the impenetrability of legalese in contracts"](https://mollicaf.github.io/publication/martinez-2021-what/) via [Assaf Arkin's Labnotes](https://labnotes.org/weekend-reading-any-desk-is-a-standing-desk-if-youre-short-enough/).

The description of "Center-embedded clauses" was particularly interesting to me in regards to plain language.

<blockquote markdown="1">

Each legalese text was drafted to contain the following language properties that have been identified as difficult to process and common to legal texts:

(a) Low-frequency legal terms – Words that are infrequently used in everyday speech provide processing difficulties for readers relative to higher-frequency synonyms (Marks, Doctorow, & Wittrock, 1974). Legal texts are laden with “archaic words” such as aforesaid, herein, and to wit (P. Tiersma, 2008), which have been shown to be frequently misunderstood by laypeople (e.g. P. M. Tiersma, 1993). Each legalese text was constructed to contain several instances of legal jargon, which were replaced with high-frequency synonyms in the plain-English versions.

(b) Center-embedded clauses – Center-embedded structures have long been observed to pose processing difficulties on a reader (Miller & Chomsky, 1963; Gibson, 1998; Pinker, 2003). The tendency for lawyers to “embed” legal jargon “in convoluted syntax” has been observed not only to be prevalent in legal texts but as a potential badge of honor for those who wish to “talk like a lawyer” and be accepted by their profession (P. Tiersma, 2008). Each legalese text was constructed to contain multiple center-embedded clauses (“Artist and Tour, said parties being hereinafter referred as...”), which were written as separate sentences in the corresponding plain-English version.

(c) Passive-voice structures – Relative to their active-voice counterparts, passive-voice structures are acquired later by children (Baldie, 1976), and may continue to pose difficulties for adults (Ferreira, 2003). Gozdz-Roszkowski (2011) found passive structures to be more prevalent in contracts relative to other legal and non-legal genres (such as newspapers). Our legalese texts each contained multiple passive-voice structures (“This agreement has been formed by the parties”), which we converted into active-voice structures in the corresponding plain-English versions.

(d) Capitalization – Non-standard capitalization is ubiquitous in provisions such as warranty disclaimers and limitations of liability, which “must be conspicuous” in order to be legally upheld (American Law Institute and National Conference of Commissioners on Uniform State Laws, 2002). Arbel and Toler (2020) found that most standard form agreements used by major companies contain a provision in all-caps. Although the use of all-caps provisions is ostensibly for the benefit of the reader, evidence suggests that they do not aid comprehension (Arbel & Toler, 2020). Here we included at least one chunk of all-capitalized text in each legalese passage (“THE WARRANTY IS HEREBY DISCLAIMED”), which was replaced with standard capitalization in the simple version.

From the set of legalese materials, each passage was encoded in terms of legally relevant propositions. From these propositions, each passage was then translated into a “plain-English” version, which differed only with respect to the four surface properties described above, resulting in 24 total passages.

For each contract pair, 12-15 comprehension questions were drafted. The questions were multiple choice with four options. These questions both targeted comprehension of specific important legal propositions, as well as more general understanding of the legal content. To reduce a response bias for a given register, we controlled the overlap in form between contract excerpt and comprehension question. Both types of comprehension question were drafted in a “neutral” register. Passive/active structures were replaced by nominalizations. For example, “shipment of the goods on the part of merchant” instead of “the goods were shipped by merchant” or “merchant shipped the goods”). High or low frequency synonyms were replaced with a third synonym (e.g. “renter” instead of “lessee” or “tenant”).

</blockquote>
