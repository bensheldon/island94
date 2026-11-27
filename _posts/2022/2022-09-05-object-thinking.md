---
title: "Object Thinking"
author: "David West"
link: "http://davewest.us/product/object-thinking/"
rating: 4
date: 2022-09-05 13:23 PDT
published: true
layout: book
tags: [software, "Object Oriented Programming"]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "22157f2df6d02269"
  vector: "Avf++/r2AQQAA/f9BgIHAgEA+wEA/vYD8AgC9AT9/wwDBPsKAgP/9PX8+/8D/AT6+vXv+Pv9AwgL/gLz/QD9CQQH/AwCAQADBQUL/AD8AvICCP8J/AIAAAYJ9v8E+QQCBfUCCP8JCvj79gEBA/74/vH+Bf0FAgAABQYHAA79+QABAvwKDf4AAgEDAA8ACw3+8QH8BAIA/vv/BQL5AQUBBfr+BAYB8wr4/gAA/gYCBgL3AwL/C/bx+wL/AvcG/vsJBQP9/Q3y+QXzBPj8Avz9AfkD9Pz+Awf++wv8+v4K/QD5+PkGB/n69P339/oDBv3zAfv/AAUM+P4GCfb3///9AQX4/wME/AH8/f3z/wMA+gH//gEB/e4AAwv4CAgABPwK/v//BPr5+//z+wD5/P76/AD9BwT9AAAG/P71AvMM9QD7AwgMAgX3AfUG/PsCDw4EBPvvAhL8/gID+fUEBAgCD/8JBvwABQX+AAUIBgkA+QL/BPwG/wkHBwcDAAcGCvsD"
---

I'm looking for a book that helps align the practice of software development with the rest of my life, In the sense of a humanistic neural plasticity, an approach that harmonizes rather than hegemonizes (or ignores) the rest of my life.

<blockquote markdown="1">

This book is based on the following beliefs:

* Agility, especially in the form of extreme programming, is essential if the software development profession, and industry, are to improve themselves.
* XP offers a way to create "better developers" to improve the intrinsic abilities of human beings to develop software for use by other human beings—a way to produce "master" developers.
* XP cannot be understood, and those practicing XP will not realize the full potential of the approach, until they understand object thinking and the shared historical and philosophical roots of both object thinking and XP core values and practices.
* In particular, programmers and technical developers will fail to realize the full potential of XP-based development without a thorough understanding of object orientation—the "object thinking" promised by the title of this book.

</blockquote>

I initially found this book searching for "Sapir-Whorf" on the O'Reilly Bookshelf. To the extent that it approaches things humanistically, this is it:

> **Inheritance**: Humans naturally aggregate similar things into sets (or classes). Another "natural" kind of thinking is to create *taxonomies*—hierarchical relationships among the sets.
>
> **Responsibility**: If an object states that it is capable of providing a given service, it should perform that service in all circumstances, and the results should be consistent... Responsibility implies that an object must assume control of itself.

This wasn't quite the book I wanted, though I enjoyed the introduction and the conclusion. The middle was a bunch of methodology that, well, was fine, but I probably won't think about again; the conclusion does admit that the methodology and modeling section is written primarily as legitimating material for academic formalists and can be transcended and discarded. So that's cool (but I would have appreciated that being said upfront than afterwards).

> * All methods are someone else's idea about what you should do when you develop software. It may be useful, from time to time, to borrow from those ideas and integrate them into your own style. It is essential, however, to transcend any method, even your own idiosyncratic method, and "just do it."
> * Software development is like riding a surfboard—there is no process that will assure a successful ride, nor is there any process that will assure that you will interact propitiously with the other surfers sharing the same wave. Published processes, like published methods, provide observational data from which you can learn and thereby improve your innate abilities—just as observation of master surfers enables you to improve yourself.
> * No model has any value other than to assist in object thinking and to provide a means for interpersonal communication. If you can model your objects and your scenarios in your head while engaged in writing code, and if those mental models are consistent with object thinking, great! No need to write them down. If you and your colleagues use a visual model on a whiteboard as an aid in talking about scenarios and in clarifying your collective thinking about those scenarios, and you erase the board when you're done meeting, also great! If your models are crudely drawn and use only a subset of the syntax defined here (or a completely different syntax that you and your colleagues collectively agree upon), still great! Model when you must, what you must, and only what you must.

Here's the good stuff, though it doesn't have much of a developmental model:

<blockquote markdown="1">

* Decompose the problem space into behavioral objects, and make sure the behaviors assigned to those objects are consistent with user expectations. This requires understanding why users make distinctions among objects and the *illusions* they project on those objects. User illusions (following Alan Kay) consist of how people recognize different objects in their world and, having recognized an object, what assumptions are made about how to interact with that object and what its responses will be.
* User illusions should be maintained; your software objects should not violate them unless you can construct a plausible alternative story that shows a different set of domain entities interacting in different ways or having different capabilities. Business reengineering involves exactly this kind of activity—using domain language and user illusions creatively to craft new stories, some of which might lead to new software.
* Decompose your problems (applications) in terms of conversations among groups of objects. Everything of interest in the domain is currently accomplished by groups of objects (people and things). Any artifact you construct must participate in a natural way in these same groups. Perhaps your artifact is simply replacing an existing object in the domain with a computer-based simulacrum, in which case it must know how to respond to and supply some relevant subset of recognizable and intuitive interaction cues. Perhaps it is an entirely new object, in which case it will need to be "socialized" to conform to the existing community.

</blockquote>
