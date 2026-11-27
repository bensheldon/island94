---
title: "OOP the easy way"
author: "Graham Lee"
link: "https://www.goodreads.com/book/show/41591808-oop-the-easy-way"
rating: 3
date: 2022-03-05 09:18 PST
published: true
layout: book
tags:
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "6a91b2281bceb52d"
  vector: "+AUEA/73Bw7+AfIAAPsIBQj9+QgI/AcC9Av++wX8BhMCBv0NCfz8/PcC+gQF+AL39/fs+fj6Aw4IAff5/fz/AgIABv39CP0CAggIAQL9AfcCDfwH/gH/BgED+fT+/hH+BvT+BP0JDfT89/77Af35+f//+v/1BAUEAP7/DQX/+AD6BAgJB/oL/QMEAAj+CQ777Qb1BAcFAPUEAwD2/AT9APgB/fv/9Af3/wcEAAYCBf//AP//CPf++PkF/wUFAwMD/wH0/gf9/ALuA/oBA/sA/QMGAP7+AAn//AsB+/3+/wAE+vb//AD78fr69f4IAQD18/oFAQQK8/YDBfcB/wQB+/n5AwMGAf0BAfr2/wD7+gIG/AkFAe8AAgn0/wIABQMCAwMD/AL0+fvzAQ0L/v76/f/5BQv7/QAH/gT7//wO/AD5+gcJBwb6/PcE/wQDDAwCAQD2Cwz6+QQB/f8HBgcACP0HAv8DB/78BQoABgkD+/z2BfkD+gr6AvwA+gcGEAEB"
---

I came to this book with certain hopes that were left unfulfilled, but I read it in a few hours and enjoyed it.

Fulfilled: cuts to the core that Object Oriented Programming conceptually starts with sending messages to objects, and the internals of how those objects _respond_ (methods, delegation, class hierarchies, etc.) is an implementation detail best deferred/ignored as long as possible. This was something I already agreed with in a sort of stubborn System 2 Thought Process ("no brain, think about it the other way") when designing code, and it was lovely to have that reinforced as a thing to do.

Unfulfilled: The human ergonomic benefits and _how to think_ about objects in a deeper way than arguing the importance of the left part of the sentence (message sending) over the right (object/language implementation). This hope (for a better mental bicycle than "no brain..." ) came from the introduction:

> Because OOP is supposed to be a paradigm, a pattern of thought, and if we want to adopt that paradigm then we have to see how different tools or techniques support, damage, or modify our thoughts.

And the hope was reinforced by enjoyable ripostes like this:

> A contributor to this objects-as-data approach seems to have been the attempt to square object-oriented programming with “Software Engineering”, a field of interest launched in 1968 that aimed to bring product design and construction skills to computer scientists by having very clever computer scientists think about what product design and construction might be like and not ask anybody.

Yeah!

An argument that I wanted explored more is that the aligning the way we think about the user-machine interface with the way we think about the programmer-implementation interface is ergonomic (building the muscles, deepening the mental groove):

> It means relinquishing the traditional process-centered paradigm with the programmer-machine relationship at the center of the software universe in favor of a product-centered paradigm with the producer-consumer relationship at the center.

And...

> Behaviour-Driven Development marries the technical process of Test-Driven Development with the design concept of the ubiquitous language, by encouraging developers to collaborate with the rest of their team on defining statements of desired behaviour in the ubiquitous language and using those to drive the design and implementation of the objects in the solution domain. In that way, the statement of what the Goal Donor needs is also the statement of sufficiency and correctness - i.e. the description of the problem that needs solving is also the description of a working solution. This ends up looking tautological enough not to be surprising.
>
> ... The theme running through the above is that sufficiency is sufficient. When an object has been identified as part of the solution to a problem, and contributes to that solution to the extent needed (even if for now that extent is “demonstrate that a solution is viable”), then it is ready to use. There is no _need_ to situate the object in a taxonomy of inherited classes - but if that helps to solve the problem, then by all means do it. There is no _need_ to show that various objects demonstrate a strict subtype relationship and can be used interchangeably, unless solving your problem requires that they be used interchangeably. There is no _need_ for an object to make its data available to the rest of the program, unless the problem can be better solved (or cheaper solved, or some other desirable property) by doing so.
>
> ... Some amount of planning is always helpful, whether or not the plan turns out to be. The goal at every turn should be to understand how we get to _what we now want_ from _what we have now_, not to _already have_ that which _we will probably want sometime_. Maybe the easiest thing to do is to start afresh: so do that.

I agree with a "just get on with it" argument _and_ I'm seeking a deeper practice of metacognition than powering through.

By the end, _OOP the easy way_ argued for the need to _start_ seeing if the true paradigm of OOP is actually any good, and that left me back where I started before the book. I wished it had done that work of "asking anybody" already.

Hopes and wishes aside, it was an enjoyable technical read, mainly because it's dishy, referring and discarding concepts by their progenitors name. This could be criticized as vagueness if one is not invested in learning the personalities involved (for example, a concept is breezily described as "Meyer-ish"), and that kept me moving forward.
