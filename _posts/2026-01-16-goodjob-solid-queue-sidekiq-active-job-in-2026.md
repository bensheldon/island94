---
title: "GoodJob, Solid Queue, Sidekiq, Active Job, in 2026"
date: 2026-01-16 15:26 UTC
published: true
tags: []
---

Hey, I’m Ben, the author of GoodJob. Last year at RailsConf I hosted a panel discussion between myself, Solid Queue’s Rosa Gutiérrez, Sidekiq’s Mike Perham, and Karafka and Shoryuken’s Maciej Mensfield called “The Past Present and Future of Background Jobs”. You can [watch that video here](https://www.rubyevents.org/talks/panel-the-past-present-and-future-of-background-jobs). 

In this post, I’m writing my personal perspective on how you, dear developer, might decide what background job backend to choose for Rails and Active Job. But everything in context. And oh boy, it’s all context.

### A sober look at how technical decisions are actually made

I’ve worked in software engineering a long time and seen a lot of bullshit justifications for… doing stuff. 

- It’s “more modern”, meaning newer, I guess.
- It has more features, or a unique architecture.
- *Everybody*’s doing it. Or maybe, this particular _someone_ is doing it. Or _nobody_ is doing it, except for the successful ones. 

All of this has some flavor of: I want to be different than everyody else, but also the same as the people who are succeeding.

There’s an assumption that the generation of knowledge is _efficient_. Meaning that all possible problems and solutions have been rigorously measured and stress-tested and their upsides and downsides unearthed; that people of equivalent smarts have spent equivalent time running out equivalent unflawed methodologies and sharing the results across equivalent channels. And our work is to place that preexisting knowledge on the platters of a scale and note which way it tips. 

Also true: familiarity breeds contempt. The grass is always greener. And despite things being inherently complex, where the goal should be less “work your way out of the job” and more “don’t work yourself into an early grave”, your managers—whether actual people or your own intrusive thoughts—will not accept that.

Alternatively, I know, from such evergreen classics like Glass’s *Facts and Fallacies of Software Engineering* and Weinberg’s *The Psychology of Computer Programming,* it’s rare to deeply track our own technical and operational bottlenecks, the full business contexts, the skills and resources of the team and the broader talent market, and integrate those details into the decision-making process. Most folks start with the solution they want, and work backwards in their argumentation through whatever technical decision process their engineering organization requires. No one shows their work ’cause there’s no work to show; they read the assignment and the answer just popped out.

But not you, of course.

There’s another dimension to this that I think is really important to note: **Decision making for new projects is vastly different than existing projects.** 

- With **New Projects**, the decisions don’t really deeply matter cause nobody knows how it’s going to go and everything is speculative. But also because of bikeshedding and the Law of Triviality those decisions become the most forcefully argued over. It’s really hard for a room of technical people to plainly say they just want to do it one way cause they know it, or try something different for the hell of it and then figure out an effective social compromise instead of debating to death some hardboiled technical justification.
- With **Existing Projects**, you have some data and some context and continuity to base your needs and your decisions on. But there is also an inexorable pressure to _do something different_ and you end up picking a solution-at-hand rather than more deeply digging into a problem area where the solutions are more elusive in the sense of “I’m searching for my keys under the streetlight not because I lost them nearby but because the light is better”.

Bringing it back to Rails and Active Job, let’s look at a really big differentiator.

### Omakase

Solid Queue is a default gem in Rails. If you run `rails new`, you get Solid Queue. That’s a strong signal that it will work, and that the Rails team confidently stands behind it as much as anything else in the Rails framework. Solid Queue is Ruby on Rails’ chefs’ choice made for you; it’s omakase.

“Eliminate valueless choices” is a powerful principle, as part of the Rails Manifesto. Solid Queue is a good choice, *especially* if you don’t have to choose. This alone is an incredibly powerful reason to Solid Queue. **You probably chose Rails for the lore.** There’s a manifesto. And it’s actually good. Conceptual integrity is important. Make the center hold.

But if you’ve been following the Rails discourse for a while, you’ll know not everyone agrees that omakase is _best_, or best for them. Lots of people quietly (and loudly!) go their own way. *Callbacks are the worst,* they comment underneath every single Reddit post. *Nobody actually uses ActionMailer. Why isn’t there a Services directory?  That pattern encourages methods that are too long! All those Concerns, are you for real? Nobody does it that way anymore. It’s not modern.*

More recently 37 Signals has started releasing source code for several of their applications, and yes, they’re for real and yes, they do still do it that way. But Rails is a big framework (“Batteries included”) and you don’t have to use everything (“No one paradigm”). You can swap something out and remain lore canon.

And really, Solid Queue slots into a real sweet spot. It’s both _new_ and it’s the default. Solid Queue can occupy the unicorn stall that’s both excitingly cutting edge and boringly conservative all at once. This will be a different discussion 5 years from now even if nothing has changed other than the year on the calendar.

But, maybe you do _need_ to order off the menu! And we should dig into that.

### Incomparables

Given the infinite rainbow of the human experience, there has to be someobody who does not collapse their categories. I have yet to meet them.

People want a simple decision tree that starts with “Postgres, MySQL, SQLite or Redis?” It’s not so simple. 

- Postgres on Heroku? Digital Ocean? Neon? Fly’s umpteenth attempt at it? Self-managed? How? Co-located?
- MySQL? MariaDB? Behind Vitess? Planetscale?
- SQLite? Litestream? Did you apply the *good* patches? How’s your IO?
- Redis? HA? How? You didn’t choose "Flex" did you?

And any one of these can have the DBA who swears by that one deep-cut config and won’t budge. And while there is wisdom in sinking engineer-years into completely rearchitecting your system to sidestep a problematic technical peer—oh, I’ve done it—there’s no way you’re gonna write those words in the justification doc. You’re slapping down “more modern” and your junior (or junior-minded) colleague is tweeting “more modern” and HackerNews will cite that a decade from now. 

Knowledge is not efficient. You’ll always find another subfloor and several sheer walls of complexity below and beyond whichever one you just pried open. This stuff is not enumerable, so any _good_ decision tree you’ll receive will, on its surface, appear to be a gross and useless simplification despite the experience that went into it.

### In conclusion

As we’ve deeply explored together, you find yourself in one of two scenarios regarding background jobs:

- The backend doesn’t matter. Pick whatever, or pick nothing and use the default. Give whatever nonsense justification you want that serves you best. No shame, all respect if you can recognize this for yourself. You can stop reading now (I know, we love the lore).
- It does actually matter, a lot. And successfully navigating this will be the crowning achievement of your career. 

If you, dear developer, find yourself in the second bucket, here’s my advice. 

- **If performance matters, like actually matters, use Sidekiq Enterprise or Karafka.** *But it’s complicated*, you comment. *It costs money. No one uses it anymore. It’s not modern.* Shush. Sidekiq Enterprise and Karafka are, hands down the best for performance outside of building it in-house (a legit choice we won’t explore here). You can make it complicated by trying to precisely nail down what is meant by “performance” (throughput, latency, resources, spiky, steady, whatever), but if you use the word superlatively--“most performant”--your choice is made.
- **Otherwise:**
  - **If you’re using MySQL or SQLite, use SolidQueue.** it’s your best option for those databases, and it’s really good in an absolute sense too. And it’s getting even better. it should have GoodJob-esque batches soon. No shade, all love.
  - **If you’re using Postgres, use GoodJob.** It’s full featured, and those features are implemented simple-like because they use Postgres-only features; there’s no workaround complexity for other databases. Want to break all the rules of encapsulation and fiddle with the job data? It’s one table. FANG uses GoodJob. It’s modern.

Because I’m close to GoodJob (familiarity!) I know the limitations too. You’ll have to go around PgBouncer. One guy profiled Postgres several years ago and pointed out where in the performance stratosphere Advisory Locks fall apart. It’s all true. 

And there is a lot of relational-database arcana that I don’t think GoodJob nor Solid Queue have documented that you *could* do. Like vacuuming your tuples and stuff like that. I don’t do it, but some people swear by it. Every system falls apart if you run it hot or weird for long enough, and relational databases are no different than Redis or Kafka.

I _could_ laundry-list any number of downsides and problems people have had with GoodJob… and you probably won’t experience them. Rosa and Mike and Maciej can tell you the same about their own backends. If and when you do experience something bad, it’s likely you’d experience something else bad on any other job backend _and then you’d have to work through the problem_ and it’s likely that problem is unique to you, either because of your unique setup, or a trivial, personal failure to have simply googled it earlier.

And to solve that problem, you’ll probably do some research. And ideally you have a strong community of peers that think like you think, and work on similar systems to the one you work on, and you talk to them and sometimes help solve their problems too. They won’t have _your_ specific answer, but they’ll have some suggestions about what to look at and what to try looking at or googling for you, and _maybe_ the change you make is to change your Active Job backend, but it probably isn’t.

So the takeaway here is that today in 2026 there are a small number of really, really good Active Job backends to choose from, and the most important consideration is that you make friends along the way.
