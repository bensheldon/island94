---
title: Two interviews and Information Technology thoughts
date: 2026-08-11 15:27 UTC
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "917cd3c719819427"
  vector: "8gcF/gf3CwcC+/QBC/wEAgz0/f0DAf0B9gUB9//8+xAACfgFAwb++PP2/wb8+Af29vzy+gj5/f8HAfgDAPf8BgkA+AQB/QD+9wIJ9/wFCPsPA/oL/gH9AQP9+vYGBhIA//cCBv0MAvL3+QAGBP78Af39B/j+B/0HAwj6/gL99wABCvwTBf78BQEIBg8DCxP77gUAAgP6/f4KAPwABP/xAgD/BQMA9AYE9wQABAMDCf/1/QAJDAD6/QH1BQT/Av4CAP8C/w4C+wD6+QD++wgBAgL5Af8FCAL7+Qj+APwEBQD8+fkCCvgF+QL8+/4B/vf//Pb+AQMM8PwABPj3BgL+9f7+AAkI/P7/Bv74/AL78wH+/QcE//f5+gb4Awr8AggA/PcFBvX6//b6/AgBA/j0A/3/BwACCPwI/Pj2+vEA9gD9/wT/AP/5A/z/A//5Dg0K+wD3+goF9wECAf3/AgP8B/0MA/MA+wQC9wUBCQP++AD+Av3/AA0RAQX9+gMGAfwH"
---

*The following is one of those posts where I share some concrete memories/experiences that I associate with some musings, but otherwise doesn’t really have a strong point other than I want to write it down.*

When I worked at Code for America, I helped design and deliver two different technical interviews.

**The first interview**, which I feel confident I can take credit for wholly, was security related. Me, the interviewer, would first have the candidate read about [Cross Domain Referer Leakage](https://portswigger.net/kb/issues/00500400_cross-domain-referer-leakage), and then we’d talk about it:

- How would you summarize the vulnerability in your own words?
- Describe to me a scenario for how an attacker would exploit this.
- Can you think of any apps or services you’ve used or worked on that could be vulnerable to this?
- What are some various ways that we might mitigate this? Are there any non-code changes, or things that you would estimate as more or less effort? Thinking of a typical app you’ve worked on, how might we address it?

…and then we’d go into an actual Ruby on Rails codebase, pinned to a specific commit from whence the codebase had that specific class of vulnerability, and talk through making a code change together to mitigate it, if not actually making the change then and there with tests and so forth (time permitting).

I particularly liked this interview because it involved some technical reading comprehension, the implication that project responsibility was broad (hey, you’re gonna have to be aware of things!), and the particular problem itself I find very technically satisfying because it involves weird browser security model stuff (but still simple, relatively speaking) and also the solution involves booping around redirects, which I think is fun.

As background, Code for America at that time was largely a Ruby on Rails shop, though we tried to be programming language and framework agnostic during the hiring process (to my mild disagreement). That said, we did emphasize experience with full-stack frameworks similar to Rails, like Laravel or Django or Java Spring, and especially emphasized full-stack *web development*. We were also, at the time, heavily pair-programming oriented (lots of former Pivotal Labs peeps), so these interviews were performed in front of dual-monitors+keyboards (or remotely with remote control) and the emphasis was on clearly communicating intent as much as it was on manipulating the code.

**The second interview**, which I don’t remember if it was my original design, or if I simply spent a lot of time shaping it over the years, was more of a traditional “here’s a feature ticket, let’s do it together.” That feature was like “As a user of the dashboard, I want to be able to filter [this list of records] by those authored by a specific user within our organization.” I think the provided design was maybe a picture of the page and a “filter widget goes here”-arrow below the heading and above the list of records.

During this interview, the main beats were like:
- For the visual affordance, what makes sense? And hopefully they’d ask about the design system and we’d talk about how many potential users there might be and I’d guide them towards like “a select dropdown”.
- How is it manipulated by a user and how does the select option value get transported to the backend server? (does it auto submit, is there a submit button)
- How do we filter it on the backend and display the result? Are there any validation or security or record lifecycle considerations we should make?

The last question always had a lot of substance to it, because it would be like “well, if we use their username as the value, what happens when they change their username?”, or “What happens if someone slaps in a user that isn’t a member of the org?” and so forth. All the sorts of things you’d hopefully enjoy nerding out about with a (potential) longterm colleague.

I’d always finish the second interview with an open ended question of like: *Now that you’ve seen some of our administrative interface and we’ve talked about the data and uses… and thinking of your own experience building and using applications generally… what ideas come to mind for how we might further improve the functionality and usability of this interface?*

**And this is the bit where I think about information technology.** Because a lot of the thing I’m trying to evaluate for people (engineers, but also designers and product managers and pretty much anybody working adjacent to “tech”) is ***What would you say we are even doing here? Like in the big sense?***

And to answer that myself, it’s sorta like the [Pushing Patrick I’ve mentioned before](https://island94.org/2025/08/everything-i-know-about-ai-learned-by-reading-the-aws-bedrock-client-ruby-sdk-code): we’re taking a data-based representation of something from over here… and then we’re putting it over there. And along the way the thing we’re building is:

- First off, we’re being **reductive** by taking a conceptual thing and reducing it to some limited representation of it in the data
- Then it’s being **collected** and **aggregated** so that some subset (or *all* of it, universally) is in our system
- It’s being **enriched** in some way by adding additional internal or external data to it. And maybe being **conflated** or **deduplicated** as well. And maybe this is happening **explicitly** by additional data entry, or maybe **implicitly** by some behavior of the system. Maybe **immediately** or **over some time horizon, short, long or in perpetuity**
- And then it’s being **listed** and **filtered or scoped** and then specific parts of the data are being **projected** or **displayed** in lots of different ways.
- And all together it’s ultimately driving towards some sort of **monitoring and decisional process** that leads to an **action** either within or outside the system.

And then for those of us building it, we’re trying to figure out how to do it in a way that is **functional (it works)**, and **usable**, and **ultimately adds value** by being **faster** or **cheaper** or **better** or simply **more possible** than it would be if people did this without the Information Technology thing being built (e.g. **than the status quo**).

And you might be thinking: *hey Ben, that sounds like more of a business, product, and design problem than a software engineering problem.* And yes, I would agree with you somewhat, but I sorta think the “Software Engineering” domain is pretty uninteresting when untethered from the rest of it. As well as the thought: any backend, non-user facing system or library or object or function still has users: those users are the developers who have adopted or integrated or wrote and maintain the code that calls it. Same same.

I can’t help but think, nearly every time I write a `predicate?` method of [Umbrella Today](https://thoughtbot.com/blog/umbrella-today) ([good and bad](https://island94.org/2011/06/data-divides-and-umbrellafication)).

![Screenshot of the Umbrella Today website answering “Umbrella Today?” with a large “YES”](/uploads/2026/umbrella-today.jpg)

I’ll offer that there is a dimension I have been thinking a lot about how it integrates into that previous definition of Information Technology, and that’s **stickiness and engagement**. On one hand, if you’re getting value out of one side of it, then it shouldn’t be soul-crushing to use. But if you’re using it purely for the **delight and high** and the actual value or benefit is fleeting… that seems… bad?

One reason these things come to mind is that I’m coming to the [15 year anniversary of writing Civic Tech Patterns](https://github.com/codeforamerica/civic-tech-patterns), which has been a longterm project to bully a very small group of very bright people into not wasting their time (I choose these words very specifically; it’s not an approach I would choose from scratch today). At the heart is this same project of trying to engage people in “no really, what are you trying to do here?”

And with AI agents and generative chatbot agents and the like too, where many of the experiences of “Information Technology” (as I define it above) is put into a black box and what comes out is often… bad? But also sticky and delightful? For some people? Arguably? I dunno.

If anything, in addition to these thoughts pervading my own direct work, I think of this moment where:

- More and more people are ostensibly building “Information Technology”-style tools (with generative tools) and I see a potential gulf between *looks like* a thing that has historically performed Information Technology and (what I believe) is the actual goal of *performs the function of, really well,* Information Technology.
- Maybe my conceptualization of Information Technology is lacking something, or doesn’t quite encompass this new Generative+Agent thing many folks are trying to make happen. Of which I think Information Technology is ultimately about **converge** and Generative+Agent stuff seems more like **diverge** but I dunno.

Hence my writing this out, cause on that last bit, I dunno. And given how rarely I seemed to interview people who _got it_ (at least according to me) for the last generation of Information Technology, I can’t say that it’s much of a change if this next generation doesn’t get it either. And probably that’s ok.

**Random note:** While looking through my (other) notebook, I found shorter commentary along similar lines that I [commented on Reddit in reply to someone being grumpy about producing a portfolio of side projects](https://www.reddit.com/r/webdev/comments/qlheml/comment/hj5s9ae/):

> I'm not the commenter you're responding to. But I am also a hiring manager and want to try to meet both of you in the middle.
>
> The thing that I want to evaluate, by seeing some non-school projects, is that the candidate has an understanding of how *Information Technology* can be used to solve a problem. Some of that is technological (does it work), and some of it is telling the story (eg input or take data and transform it in a new or novel way that solves a human-understandable problem). It's "design" to the end of demonstrating you understand the overall problem space of how technology is applied to a problem. And calibrated to what's expected of someone coming out of a (effective) bootcamp.
>
> And when I've got 150 candidates for an entry level position, the candidates who can communicate that effectively will stand out.
