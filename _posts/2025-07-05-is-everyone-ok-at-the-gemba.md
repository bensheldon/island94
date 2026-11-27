---
title: "Is everyone ok at the gemba"
date: 2025-07-05 17:35 UTC
published: true
tags: [working]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "d2be6a88189bf076"
  vector: "+QEFBAX9CQv/+/MCBPv4Agf29gL5+gL/+QoC9Pn/Af8FBwENBgkH9/z5/P0A+gj39vPv+Qb+AAoIAwMA/vr7BQYF+wf1Av/8AQgFAP39BfoJBf0L/vsEAwoE/P4D+RMBBP79CAAIBPH8AAL+/QH5//r8DAL7CfwFAwQGDwUE+AABCfwO+/77AwkPBgwIAwUG8Pz4AwP5/fn+/gP7AgD7A/8CAQj7+AcA9gIDAgMHBPf0Av8EEgP+/f/7BPgKAvEH+gD5CAj9///z+gD///4C/Ab+AfYE/wIBAhH89/8L+QAD+/cFCgH89AAA9gD9AAHyBfsB9wUL9gD5Cf/8+gEDAAD+AQj6/PwC/Pzy+Pz8/fj5/v8A9/z6/QsAAgkDAgf/APoFA/0D/Pr2+wML+vjz9f/3Bgb9DQEE+f4A9fYD+wADAwUCBPb4/v0EB/f9BhIM/APz/A7/9//+/fkI/wf+Bv0BAvwC+gkD9wYMB/0A9gH9AwT8AwoLAAMG9gQFAvQA"
---

The following is the bones of a half-written essay I’ve had kicking around in my drafts for the past 3 years, occassionally updated. I recently read _two_ things that said it all better anyways, but if you read through you get my perspectives as someone in software cooking the goose.

One: Albert Burneko’s [“Toward a theory of Kevin Roose”](https://defector.com/toward-a-theory-of-kevin-roose):

> My suspicion, my awful awful newfound theory, is that there are people with a sincere and even kind of innocent belief that we are all just picking winners, in everything: that ideology, advocacy, analysis, criticism, affinity, even taste and style and association are essentially predictions. That what a person tries to do, the essential task of a person, is to identify who and what is going to come out on top, and align with it. The rest—what you say, what you do—is just enacting your pick and working in service to it.
>
> …. To these people this kind of thing is not cynicism, both because they believe it's just what everybody is doing and because they do not regard it as ugly or underhanded or whatever. Making the right pick is simply being smart. And not necessarily in some kind of edgy-cool or subversive way, but smart the very same shit-eating way that the dorkus malorkus who gets onto a friendly first-name basis with the middle-school assistant principal is smart. They just want to be smart.
>
> So these people look at, say, socialists, and they see fools—not because of moral or ethical objections to socialism or whatever, or because of any authentically held objections or analysis at all, but simply because they can see that, at present, socialism is not winning. All the most powerful guys are against it. Can't those fools see it? They have picked a loser. They should pick the winner instead.

Two: Ed Zitrain’s [“Make fun of them”](https://www.wheresyoured.at/make-fun-of-them/) (emphasis in the original):

>  In my opinion, there’s nothing more cynical than watching billions of people get shipped increasingly-shitty and expensive solutions and then **get defensive of the people shipping them,** and hostile to the people who are complaining that the products they use suck**.**

### In the day to day

One of the standard questions in my manager/executive interview kit is:

*Walk me through what a good day looks like for you if this were your ideal job? And based on past experience, walk me through a bad day?* (yes, this is described in the Phoenix Project)

With some prodding, I want sus out how they think about a mix of group meetings, 1:1s, and heads down time. And ideally that the candidate can articulate some concrete artifacts of work (canned meetings, documents, etc.).

- An excerpt of a good answer: Promoting someone up a level is really satisfying. Being in a calibration meeting where I'm presenting the packet my report and I developed together. I've designed promotion processes before and building an agenda for that meeting is a lot of fun. Do you have a career ladder here? I spend a lot of time doing gap analyses. I'll spend at least a few hours every week running through my notes.
- An excerpt of a bad answer: Promoting someone up a level is really satisfying. It's important people are recognized for their work.

Good answers usually have jumping off points to talk about working and communication styles: "oh, is that something you're doing over chat or email or in a shared document? Is that a repeating thing or as needed? How would you pull that together?" Bad answers usually stay at the general level (async, mastery, autonomy, meaning, etc.) and just… stop.

Having done maybe 30 of these interviews over the past decade, I've realized there are many people who seem otherwise competent but can't talk, concretely, to what they do. Physically. Embodied. Even at a computer, what’s behind that digital window.

And I say “seems competent” cause, well, I usually pull these questions out at the end of the interview pipeline, and the candidates are otherwise qualified and their previous interviewers liked them enough to advance them to this stage. And even when the company has gone on to hire them, over my objections sometimes based on this question, they haven’t been _the worst_. The candidate I interviewed with the most memorably bad answers is now an SVP of Engineering at a major tech company. They’re doing ok.

But I do think there’s something there, that’s indicative of the moment. To break it down, there’s two awarenesses that I’m checking for:

- Materiality: an awareness of where they _are_ doing the work, and that’s also sorta doublechecking that they are aware that other people actually exist too. You read enough Ask a Manager and you realize _a lot_ of powerful people struggle with object permanence when someone is outside their sight lines.
- Operationalization: a set of personal playbooks for making things happen. For example, I’m a big fan of skip 1:1s (when you meet with your report’s reports, or your manager’s manager) and will make point of intentionally setting those up. I have lots of opinions about what a minimally-viable-career-progression system looks like: career ladders and performance evaluation processes and calibration meeting agendas and 1:1 templates. Or more discipline specific, like inventories and gapping templates and decision docs, In any job we don’t have to use _mine_ but I sorta expect an experienced manager to have them in their back pocket and be interested in talking about them.

All of which is to ask: **take me to your gemba**, ideally, and help me understand how it differs from your worst one too. *[The Gemba](https://en.wikipedia.org/wiki/Gemba)* being the location where the work happens. Pedantically, it’s where the value is actually created, like the factory floor, but in this knowledge-heavy work… who can say? Our most valuable assets go home every night, right?

### The AI in the Room

All of this comes to mind with the contemporary exhortions of like “AI is mandatory” and “you must use AI in your job” sorts of manifestos and the reply-guys of like “you either git gud with AI or you fall behind and end up living in a cave and eating bats.”

So I take the previous thought of like “lots of managers and executives have no idea what their own work actually looks like”….

…and my thoughts about my own discipline: how does software get made? [Nobody knows.](https://arxiv.org/pdf/1802.06321) On the individual level, it’s extremely rare to find people doing anything like Extreme Programming and its emphasis on pair programming and rigid collective team practices. In most of my decades of professional experience, software just expected to happen. [Nobody knows.](https://arxiv.org/abs/2307.13143)

For example, most teams I’ve worked with have huge differences in how individuals approach a problem: what and how much design or plannng they do up front, whether they start with tests or implementation, the order of components they work through, what they consider “done”. Drill down to the actual hands-on-keyboard-and-eyes-on-screen and editors and IDEs and development tooling are all over the place developer to developer. And no practices for sharing or learning from each other, and rarely interest either (“it works for me and I expect it would be painful to change”).

I have to imagine there’s a relation here, more often than not I’m talking to software managers and executives. Shared practices just aren’t _a thing_.

So I’ll simply say: it’s weird that AI is _the thing_ to mandate, rather than like a consistent IDE, or testing strategy, or debugger workflow. That _this_ is the thing, when there is so much everything-else that nobody knows.

### Accountability kayfabe

I’ll admit it’s easy to take potshots at the weird things tech executive say and do, but I see a pattern here. Just prior to these AI mandates were the layoffs, which had their signature phrase and power pose: “I’m accountable for this decision.”

“Accountability” is a funny word as it means to “give an account.” Y’know, explain what happened, what was done, when, and by whom. What’s funny is that the word has been sort of walked back from actually giving that explaination, to the idea of the burden of having to give that explanation, to just a vibe of like “I’ve got it. This one’s on me.”

I noticed that a lot. I’m [not the only one](https://aworkinglibrary.com/writing/on-accountability).

I think the thing that people wanted to know, employees especially, was just like: materially and operationally, what the hell happened here?! And when there’s not an answer, there is a reasonable spectrum between active gaslighting on one side and my recognition that the people in charge could actually have no idea and maybe not even the personal capacity to know. It just ended up that way. Things happened.

### Bringing it back around

I dunno. Just continue asking the “can you show me that?” “can we look at it together?” “how do you think that will effect things?” “is there anything you have in mind that I can do to help?” questions.
