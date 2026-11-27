---
title: Put Your Civics Where Your Houseplant Is
date: '2012-08-14'
tags:
- civics
- engagement
- gamification
- portfolio
wp:post_type: post
redirect_from:
- 2012/08/put-your-civics-where-your-houseplant-is/
- "?p=3018"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e1e3e8b2e70844c1"
  vector: "/QEG/gj+BAIABv7/APwF+wQC9Qb6/AEIBP38+P4FCAUABfwK+/oD7gLxBP79+wT4AfUB/wj/+gADB//8Bfz8A/0H+gQC+gECBAL//fz/AfsIBAIKAQD9BAoF/wgI/PgBA/r8C/cLAPsE/fL+BgX7Av0BCf0EAQX/CwAA9REE/QAGEAQJ//37/AP+BxAICAcD6/wJBgfzAAAE8wYC/wECAf75AfgB+QL5/AUCBQUNCQH8Bw8EAP38+wHx/fIG+vwH+wH3/wH+Bv/z8f4AAPX7Bwv5+wAT+gL3+gADBf8H9wD89QEGBvf29QkC+QD/Ev3yBwD6//0R8wUDAPn/BPYA/AD6AAsD+PcBBPv9/e7++gXxDQf/AQIC+Qn/AAUCCfcH/vQHAf0CBfv19gIIBP/7+fwABfcA/vMDAAn6Bv4JAgD+AfsBA/8H/wICBgD6BQn+Bv3zBwL79foA/QAAAgkCAQID+vwD+Qn/AAIE//v9+v4J/v3xBQUGAQgPDAMFBPQD"
---

![](/uploads/2012-08/civicsgarden-large-600x266.png "civicsgarden-large")

The core assumption of engagement applications is that people will do an activity consistently and repeatedly if you just structure the experience and incentivize it correctly — even if it’s asinine. The justification for _civic_ engagement apps can be similarly foolish: people will perform a potentially beneficial activity that they aren't currently doing if we give them the ability to do it on the internet (or via SMS, or iPhone, etc.). That's why I built [Civics Garden](http://civicsgarden.herokuapp.com).

A few months ago a Code for America email thread came around asking how "If you could tell the story of how government works, what would you say?" I pushed back with the idea that one cannot know government without participating in it, and since we are a government of, by, and for the people, the best place to start would be reflecting on one's own civic life and civic actions.

A tried and true method of reflection is journaling. Hundreds of millions of people keep a journal called Twitter, reflecting and writing on their days experiences, tribulations, meals, and cat sightings (this is not a comprehensive list). If people naturally do this, why not ask them to reflect specifically on their civic actions---voting, volunteering, checking out a library book, picking up a piece of trash, smiling at a stranger---and write down that reflection (however brief) on a regular basis?

Projecting from my own nature, people are fickle, lazy, unreliable creatures. That's why gamification is the hotness. "How can I get you to look at my ads every day? I'll make it a game." Sure, this is no different than historical incentives ("How can I get you to work in my coal mine? I'll pay you money."), but now it's on the internet where advertising is easier to place than coal mines. One form of gamification I really enjoy are virtual pets: like [tomagatchi's you feed with Unit Tests](http://www.happyprog.com/tdgotchi/), or [flowers you water with foreign language vocabulary](http://www.memrise.com/). They encourage you to perform an activity because you instinctively (unless you're a sociopath) feel good when they're healthy and bad when they're sickly... despite the fact you know they aren't actually alive.

Civics Garden combines these concepts: by signing up, users adopt a virtual plant that they keep healthy by regularly "watering" it by writing down their civic deeds. If they go too long without a journal entry, the plant will wither and eventually die. Just like owning real houseplants, it has exhilarating potential.

![](/uploads/2012-08/bamboo-states-600x218.png "bamboo-states")

I built Civics Garden with Node.js and MongoDB using Twitter for authentication. Each new user receives a healthy bamboo plant to caretake by writing short journal entries. To keep people reflecting regularly, one's plant will wither after two days, and die after four--though users can replant it as many times as necessary. To keep them coming back to the site, users receive a tweet from [@civicsgarden](http://twitter.com/civicsgarden) to let them know when their plant needs refreshing. As an minimum viable product (MVP), it's high-on-concept/low-on-looks, but Diana and Emily helped with the graphics.

I've tested it internally with Code for America fellows and it should be a rousing success. All of us, as active civic participants performing important civic deeds should be able to briefly but consistently reflect upon and record our actions, right? See for yourself on Civics Garden and [test your ability to reflect on a healthy civic commitment](http://civicsgarden.herokuapp.com).

…or maybe people just don't like bamboo.

![](/uploads/2012-08/civicsgarden-result-600x408.png "civicsgarden-result")
