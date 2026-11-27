---
title: "Spectator Sport, a brief introduction to an upcoming Rails plugin"
date: 2024-09-29 05:44 PDT
published: true
tags: [rails, spectator_sport]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "239272b29c65d8cf"
  vector: "+fr7AAoEBAX9BvUEAQUEART3+v/79QQH+vz6AwD2Av8HBP0FAPbx/f/5+gkA+QP9/gH39gr3+/0C+fz8Cv//AQH/+wkFAfkF/AMA+Pz6AAEH+vsG/f4GAgH++AULBPwFA/z+DwYIBvv6//0TBgX+CfoACwj4AwwHDRABBQ/+/QAIDfsI/wT///cBCBEDBgz68wQH/wT1+goD/gAGBAL+9/38Cfj78wP99QLw+voHBQH6/AMCDAb1/QfzBvYH+Pz/9gAGBwv4+wj7+P79/P3/CQf9+QAA/Qf39Q38CP4EBAD6+/8HB/oD/Aj99fn6//n3APb+BAEP+fsFBfz/AP8H///3+QcBBP7/BwH7+/wJ+QP9AQD//fX/+////Ab/CvkBAfoFBfn+/QX8/AQHAAP8//YDD/gHBv0C9gP6B/cFAwD6BPwE/PsGAAQDCPb5DgYB+wDzAAYCAPsD/PcBAfkCBf/+CPj4/gID/AQDBAEB9vX/+/v3AQoLCwgJ/gYI9fYJ"
---

**Hi! 👋 I'm Ben Sheldon. I'm the author of GoodJob, an Active Job backend that I'll humbly share is mildly popular and known for its broad features and ease of use. I'm working on a new plugin for Rails: ✨**

**Spectator Sport** creates and replays video-like recordings of your live, production website, via a self-hosted Ruby on Rails Engine that lives in your application.

Spectator Sport uses the [rrweb library](https://www.rrweb.io/) to create recordings of your website's DOM as your users interact with it, from the perspective of their web browser's screen (html, css, images, dynamic content, mouse movements and clicks, navigation). These recordings are stored in your Active Record database for replay by developers and administrators to analyze user behavior, reproduce bugs, and make building for the web more engaging, satisfying, and fun.

**Here's a proof of concept demo.** It’s very, very, very, very rough and early, but everyone I have demoed it for says “wow, that is totally different and much better than I imagined it when you first explained it me”: [https://spectator-sport-demo-1ca285490d99.herokuapp.com](https://spectator-sport-demo-1ca285490d99.herokuapp.com)

🚧 🚧 *This gem is very early in its development lifecycle and will undergo significant changes on its journey to v1.0. I would love your feedback and help in co-developing it so fyi it's going to be so much better than it is right now.*

**You can help:**

- Leave a [comment on the GitHub Discussions post](https://github.com/bensheldon/spectator_sport/discussions/6)
- Contribute to the [gem's development](https://github.com/bensheldon/spectator_sport) by opening an issue to discuss, or contributing a feature via PR
- ⭐️ the [GitHub repository](https://github.com/bensheldon/spectator_sport) to help elevate its visibility
- Subscribe to my [email announcements list](https://scattergun.email/public/mailing_lists/eXKwMBZ6YkdlXra3/subscribe)
- Sponsor my development with $$$ via [GitHub Sponsors](https://github.com/sponsors/bensheldon)

### Who is this gem for?

I'm writing this on the weekend following Rails World 2024, on eve of Rails 8's release. The Rails team is tackling the hard problems of making it easy to deploy your website into production with tools like Kamal, and addressing operational complexity with the Solid suite. What comes next?

Spectator Sport intends to transform your relationship with your website _after_ it is deployed to the web and real people have the opportunity to use it:

- See how people are actually using your website, directly.
- Remove the _necessity_ of defining funnel metrics or analytics up front, or the _necessity_ of interpreting user behavior through a limited lens of aggregated or averaged numbers.
- As a developer and product-maker, more fully engage your sympathetic senses, _in addition to your analytical senses_, to ultimately be more effective and fulfilled when building for the web.

**Launching a website kinda sucks.** I've been a solopreneur, and web-marketing consultant, and "founding" engineer, and "growth" engineer at VC backed startups and product labs, and a participant and mentor in entrepreneur communities and mastermind and accountability groups for 19 years. People are not ok.

The fast *development* feedback of imagining and building the thing locally, the dopamine rush of making something nice, one step at a time, for other people to use... that all drops off a cliff once, well, you put it out there for other people to use. The *post-launch and release* feedback: it’s not there.

It sucks! People feel it! They're confused, they're sad, sometimes mad, looking for help, wanting to be seen by others, spinning on valueless technical changes, sharing tangential hot takes and engagement baits. Developers are going anywhere but directly to the people they’re building for. One reason, I believe, is because their visitors' and users' activity on their website is largely invisible and unknowable, and the only way to see it is through a foggy, confusing and deeply unsatisfying window of abstract metrics and aggregation.

**Building for the web should be a spectator sport.** More than _only_ a fantasy game of metrics and aggregates and guesses and spread-table gambles. It should be fun and engaging and direct. We should simply be able to observe and react and cheer and cry and fall on the floor and get up and make it better and go again. Believe.

There are constraints to what _I_ can do to achieve this vision, with this gem. I'm focused on building for Ruby on Rails. And specifically hobbyists, soloprenieurs, small teams, SMBs (small and midsize businesses), and unique applications, including:

- applications with limited budgets or the inability (because of geography or policy) to contract or procure a 3rd party service.
- applications in government or healthcare or on an internal intranet with unique data or privacy constraints who don't have the budget for a BAA (business associate agreement) or other compliance contracts
- applications for which operational simplicity is paramount and don't have the resources to operate a more complex self-hosted solution

### We have the technology

Browser recording isn't new. Fullstory was my own introduction to it nearly a decade ago, also Tealeaf and Sentry and PostHog and Highlight and Matomo and many others, some of which are no-cost self-hostable as a separate service, though often with complex dependencies. Many of them use rrweb too.

**I believe Spectator Sport is the first no-cost, self-hostable browser-recording tool that works anywhere your application runs (Heroku being the narrowest target I can imagine).** _Tell me what I'm missing!_

If my adjectives themselves aren’t compelling and your website already has massive scale and a rich revenue stream and/or no concerns about 3rd-party data subprocessors, I highly recommend checking out PostHog (just $0.005 per recording!) or Sentry (enterprise gated, but integrated into Sentry’s other features which are fantastic).

### A good job, again

I mentioned in my introduction that my other gem, GoodJob, is well-regarded. I think we can do it again with Spectator Sport:

- Focus on solving a class of problems developers experience over a long period of time, not building a specific technology tool and calling it a day.
- Serve the vastly more solo and full-stack dev teams with limited time and budgets who will benefit from something tailored to their largely consistent needs (easy, good, inexpensive) and are nice and appreciative when you deliver, than the very small number of experienced folks with big budgets and unique needs who inexplicably have time on their hands to be outspoken in telling you it will never work _for them_.
- Provide a wide offering of polished features, using boring, existing tech to do the complex bits (like Postgres advisory locks in GoodJob, or rrweb in Spectator Sport). The value comes from the usability of the integration. A full-featured, cleanly designed web dashboard really impresses too; Dark Mode is the epitome of a non-trivial feature to maintain that demonstrates care.
- Maintain a narrow compatibility matrix, focus on "omakase" Rails (Active Record, Active Storage, etc.) with a sensible EOL policy. Complexity kills. Relational databases are great. [Squeeze the hell out of the system you have](https://blog.danslimmon.com/2023/08/11/squeeze-the-hell-out-of-the-system-you-have/).
- Be exceptionally responsive and supportive of developers who need help and meet them where they are. Be personally present because the library can’t speak for itself. Make mistakes, [change direction](https://github.com/bensheldon/good_job/issues/255), communicate intent, move forward.
- Keep the cost of change low, release frequently, build up, iterate, document and test and provide deprecation notices, follow SemVer, and defer application-breaking changes as long as possible.

I do want to try one thing new compared to GoodJob: I want Spectator Sport to be compatible with Postgres _and MySQL and SQLite_. I believe it’s possible.

### Front-running the criticism

Here are the things I have worked through myself when thinking about Spectator Sport, and talked about with others:

**Is it creepy?** Yes, a little. There is overlap with advertising and marketing and “growth” tech, And many service providers market browser recording as a premium capability with premium prices and sell it hard. Realistically, I have implemented enough dynamic form validations in my career that I no longer imagine any inherent sanctity in an unsubmitted form input on a random website. Conceptually, Spectator Sport observes _your website_ as it is operated by a user, it does not observe _the user_. [Every webpage deserves to be a place](https://interconnected.org/home/2024/09/05/cursor-party), and this just happens to be your CCTV camera pointed at it, for training purposes.

**Is it a replacement for usability research?** No, of course not. Spectator Sport can only show you half of the picture (or less) that you get from real usability research. When you do [real usability research](https://sensible.com/rocket-surgery-made-easy/) and ask a subject to do something on your website, you ask them _to explain what they’re doing, in their own words, based on their own understanding of the task and what they see through their own eyes._ Browser recordings alone can’t give you all that. You still have to [fill in the blanks in the story](https://www.gamedeveloper.com/design/rimworld-dwarf-fortress-and-procedurally-generated-story-telling).

**Is it safe?** I think so. I intend all user input to be masked by default, be secure by default, and provide comprehensive documentation that explains both the why and the how to lock down what’s stored and who can access it. Spectator Sport is shipping the DOM to your own database, and it’s likely the same data already lives in the database in a more structured way, and is already reflected back through your application too.

**Does it use a lot of storage?** Not as much as you might fear. If people’s big scaling worry for GoodJob was “it will be too slow” I already think Spectator Sport’s is “it will be too big”. I’ve been running the proof of concept on my own websites and 1.5k recordings took up ~500MB of storage in Postgres. Retention periods can be configured, data can be compressed and offloaded to Active Storage. I believe it is ok, and worth the squeeze.

**Can it do xyz?** Maybe. [Open an issue](https://github.com/bensheldon/spectator_sport) on GitHub. I’d love to discuss it with you.

**Wouldn’t you rather do something with AI?** I dunno, man. I freaking love watching recordings of my websites being driven by people and thinking about how to make the website easier and better for them. I think this is an immensely satisfying missing piece of building for the web, and I think you will too.

*Tell me what I’m missing or overlooking!*

### The call to action, a second time, at the bottom

Something I learned a long time ago, from watching browser recordings (true story!), is that visitors will go deep below the hero’s call-to-action, read all the lovely explanatory content, get to the bottom… and bounce because the call to action wasn’t reinforced.

**So, please:**

- Leave a [comment on the GitHub Discussions post](https://github.com/bensheldon/spectator_sport/discussions/6)
- Contribute to the [gem's development](https://github.com/bensheldon/spectator_sport) by opening an issue to discuss, or contributing a feature via PR
- ⭐️ the [GitHub repository](https://github.com/bensheldon/spectator_sport) to help elevate its visibility
- Subscribe to my [email announcements list](https://scattergun.email/public/mailing_lists/eXKwMBZ6YkdlXra3/subscribe)
- Sponsor my development with $$$ via [GitHub Sponsors](https://github.com/sponsors/bensheldon)
