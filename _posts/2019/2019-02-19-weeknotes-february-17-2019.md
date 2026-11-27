---
date: '2019-02-19 07:32 -0800'
published: true
title: 'Weeknotes February 17, 2019'
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "d37767984ff6619a"
  vector: "AQkB/wYEAQAHAvAD+wUB+wj89QD2+vkF8gP4+gH7/f8F/gIICgAA+wf2/QAC8Av48/7/+gP/BQgJAv/6/Pz4BwD7Bw37/fj5Bv0K+gD8B/cMAwAK9PwBBAn+9gQE+QcGAf8GBgMKBff/9/oF+wj8A/z3Dgb5BQYHAAcG/AADAgAECP0LDAAFAv3/Bwz/BA757wT//Pr2/v0DAf8C/f/+A//0/gH5+Qf77wH7AAIKD/L5/wT8Dvz9+wbxBwD//fcLAQv8AQX6Af7++AQH/v/+Af4FAwAI+gEF/g38AQIJ/wD+/fr+APj27gwE9fwCA+/1BPgC/QwI6wMABwD4/vn5+AH6AgL8BfsBAwL4/gAF/vr9BgL5/AD+AQYB/wYACP4IBPwHAfr++/369QAG/vr7AvkACP7/DQP9/wD1/PoH/QD+/gEAAPv8AQUKA/YECQsFCQHx9wgAAP0D+AEIBP38BvcDAvcEAAgL/QAFBvn/7Qn8+wP3DAEGBAkKAAUIAf0F"
---
This week I created a [Dockerized development environment for Panlexicon](https://github.com/bensheldon/panlexicon-rails/pull/212). I find it’s forever a struggle to bridge the Docker-for-development and Docker-for-production workflows and configuration, but this is Docker-for-development.

I’ve been working on “project planning as narrative”, having written out a long story about an accessibility project that has yet to kick off. Here's an excerpt:

> This led to a collaborative discussion that was also tinged with reasonable fear: how can our team ensure that we’re taking into account the newly collected design considerations? We knew that this would involve some new skills: screen-reading, keyboard navigation, low-vision simulation, and more.
>
> It’s easiest to learn new skills when they’re grounded in practice, so we placed their usage within the context of our delivery pipeline:  
>
> 1. Design: Screen-reading, expanded awareness of content/action hierarchy, inclusive design patterns. [Design]  
> 2. Prototyping: Expanded usability testing community. [Design, UX Research]  
> 3. Development: Inclusive design patterns, validation and automated testing. [Engineering]  
> 4. QA and Acceptance: screen-reading, keyboard navigation, low-vision simulators. [Engineering, Product Management]  
> 5. Support: expanded awareness [Client Success].  

I was reminded of this long story about [Windows Vista](https://hackernoon.com/what-really-happened-with-vista-4ca7ffb5a1a) via a [Highly highlight](https://www.highly.co/hl/gxpczO2Kh0EtlG). The thoughts from my notebook (that I then [tweeted](https://twitter.com/bensheldon/status/1095699532447268864) about:

> What would principles of continuous delivery look like if applied to project planning and management? What would be necessary for a project to live in a continuously deliverable state?

I read another long article from [Christina Maslach on Burnout](https://itrevolution.com/understanding-job-burnout-christina-maslach/).

<blockquote markdown="1">

If there’s one image that I’m talking about today that I hope you remember, it’s this — we have found that the fit, the match, or the balance between a person and the job, is critical for burnout in six areas. They are not listed in order of importance. They’re listed in order of which one people think of first.

- **Workload** is the one that everybody thinks of first. It must be they’re working too hard. They’re stressed out. The imbalance between too many demands, too few resources to get it done. But there are five other areas that turn out to be just as important.
- **Control.** In other words, how much autonomy you have in your work, how much choice, or discretion to figure out how to do it the best way or innovate in some way.
- **Reward**. People think of things like salary, benefits, perks, et cetera. We’re finding in the research that social reward is sometimes more important, that other people notice that they appreciate what you do and let you know that you’ve done something that’s really meaningful.
- **Community.** These are all the relationships that you have at work, with other colleagues, your boss, clients, whoever. Are those relationships functioning well? Are they supportive? Do you trust? Do you have ways of working out disagreements and figuring out how to move forward, work together well on teams, et cetera.
- **Fairness.** This turns out to be a very important one. Is whatever the policy is, whatever the practices are, here in this place, are they fairly administered in terms of who gets the opportunity? Are there glass ceilings, or discrimination, or other things that block people from moving forward when they should have that chance?
- **Values**. Which sometimes turns out to be one of the most important. This is meaning. This is why am I doing this. Why am I here? What do I care about? What is important to me, in terms of what I think is important for our society, the contributions I make, and so forth? With burnout, it’s not just about being exhausted and working too hard and being tired. It’s often that the spirit, the passion, the meaning is just getting beaten out of you, as opposed to being allowed to thrive and grow.

These six areas offer entry points into what could we could be doing differently, that might actually create a better, healthier, improved workplace to support the things we want to achieve.

</blockquote>

I follow several blogs that are all-in on Event Sourcing; reading [“Event Sourcing is Hard”](https://chriskiehl.com/article/event-sourcing-is-hard) was refreshing:

> **What’s the take away here? Should I event source or not!?**  
>
>  I think you can generally answer it with some alone time, deep introspection, and two questions:  
>
> 1. For which core problem is event sourcing the solution?
> 2. Is what you actually want just a plain old queue?
>
> If you can’t answer the first question concretely, or the justification involves vague hand-wavy ideas like “auditablity”, “flexibility,” or something about “read separation”: Don’t. Those are not problems exclusively solved by event sourcing. A good ol’ fashion history table gets you 80% of the value of a ledger with essentially none of the cost. It won’t have first class change semantics baked in, but those low-level details are mostly worthless anyway and can ultimately be derived at a later date if so required. Similarly CQRS doesn’t require event sourcing. You can have all the power of different projections without putting the ledger at the heart of your system.  
>
> The latter question is to weed out confused people like myself who thought the Ledgers would rule the world. Look at the interaction points of your systems. If you’re going full event sourcing, what events are actually going to be produced? Do those downstream systems care about those intermediate states, or will it just be noise that needs to be filtered out? If the end goal is just decoupled processes which communicate via something, event sourcing is not required. Put a queue between those two bad boys and start enjoying the good life.  

I was heartened to read this about [“How the Seattle Times is empowering reporters to drive subscriber growth”](https://digiday.com/media/seattle-times-empowering-reporters-drive-subscriber-growth/):

> Over the past year, the news publisher, which grew its digital subscriber base 38 percent to 40,000 in 2018, has been trying to get small teams of reporters to think more entrepreneurially about driving subscriptions. It wants them to not just monitor which kinds of content visitors read on their way to paying but also to experiment with new content and packaging formats designed to keep readers engaged.  
>
> In 2017, the Times gave its newsroom staff access to a dashboard that showed reporters which stories they published were driving subscriptions. Next, the Times’ executive editor, Don Shelton, formed several teams, called mini-publishers, which paired editorial staffers with members of the paper’s digital audience, product and business intelligence teams to figure out what kinds of content the audience likes, how to make more of it, and so on.  