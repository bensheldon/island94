---
title: If you replaced “accessibility” with “responsive design” in 2018, this is what you’d get
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "9716c5f74fa7a496"
  vector: "+QcKAQv//wP2+wAGAv0G/Qr59Aj7AQH+9wP3/Ab3/AcEAf4BAgD5+/L3/QcH8QP9+fEB+wf58wEFAwz//fkDDAYE//v5Avj/CwYNAP4GBv8D+voN/QP5CP35/QEABAP5A/L/AgQNCPr9AQIH/wgC/PX+A/v9/BIC/wj+9QgI9gABCfYFCfgFBP3/DQv+AxL9+wD6Af/1/gD9Av8GBv/2/gD8/vwB9gf88QT9/AEFBvr++/4JCPb/+AD4B/8C/fgH/wEEBvz9/P3/BwH+AAAE+gINDQIB8QH7/QX+AgEE/gD//P/9AfgE/xH4+QQC+O0D//gEAAoD/AX8Afj49vb+9QQBDvnx/wADBAMA/wwI/fL4AQwBBPX8Bwj3/gQIAfj+/wAE+v//APT49wQCBvz1+wUL/wECCgQA+gD2AvYKAAAEAvz9/v77+AYFAfoBDgkI+wj0AgEM//8HA/n9AgX7Af0C+/kF/g8FAQIFA/v78Qb4BQH5A/wK/gf+/gELAAQN"
---

_I took all of the conversations and experiences I’ve had over the years advocating accessibility features, and imagined them applied to responsive design._

### Imagine

Imagine a product organization where no one has a smartphone or knows how to resize their browser.

A forward-thinking engineer says “Hey folks, I know everyone is busy but I was playing around with this browser draggy thing and I dunno but I think our website isn’t very good on smartphone. Can I help?”

Their manager replies “That’s the kind of initiative we love. Let’s put together a plan.”

Here’s what their plan for “responsive” looks like

- **Summarize industry standards** for responsive design. It’s a “growing field”.
- **Do demographic research**: What are common viewports? How many people have smartphones?
- **Standardize on CSS rules for projects**: Every CSS file must have at least 1 media query. All container elements must have at least 2 breakpoints. No fixed width element can be wider than 320px. All buttons must be larger than 16 x 16px.
- **Write some automated tests and QA tools** to ensure those rules are followed.

### That’s a good plan, right?

The plan is standards based, actionable, measurable, and integrated into the development process. And engineering is championing it. That’s great!

So things move along and then…

- New customers are increasingly focused on “responsive best practices” and the company isn’t sure where they stand in the competitive landscape.
- An important stakeholder got a smartphone and begins poking the CEO about some weirdness.
- Product managers and designers grumble about deadlines and bolting-on changes when developer and QA questions get kicked back upstream.
- That forward-thinking engineer occasionally sighs and pushes through odd-looking code and CSS changes and _it’s just kinda ok fine_, but isn’t sure how it’ll fit into their next performance review.

So the company decides to hire you.

### Imagine you’re hired to fix this

What do you say? (Remember, it’s 2018.)

“Let’s get some goddamn smartphones. And let’s train our people how to resize their browsers. And then we’ll talk about our usability testing practices.”

Time to get to work! But there are still some objections to overcome:

- “Getting ‘good’ at resizing browsers is gonna take a lot of time and training. Is it really that important?”
- “Not all designers will want to specialize in responsive. Can we really make them?”
- “We have a lot of other product needs too. How do we prioritize “responsive” against the other business and UX problems we already know about and need to fix.”
- “Airdropping some smartphones won’t make us native users. We can’t really understand a smartphone user’s experience enough to make it perfect. Our company just isn’t the culture for smartphone people anyway.”
- “Making existing projects perfectly responsive will be like a total rewrite. Maybe next time we could really bake it in from the beginning.”

This is tough, right? It’s a slow and steady push. It’s amazing anyone manages to do responsive at all.

### Yet here we are for accessibility

Over and over again I see organizations fall into an approach that places accessibility as an implementation detail to be addressed at the end of the product development process.

> Because so many accessibility errors relating to assistive technologies are markup errors, and because markup errors are so easy to identify, we’ve grown up in an accessibility remediation culture that is assistive technology obsessed and focused on discrete code errors.
>
> Inclusive design has a different take. It acknowledges the importance of markup in making semantic, robust interfaces, but it is the user’s ability to actually get things done that it makes the object. The quality of the markup is measured by what it can offer in terms of UX.
>
> — [Inclusive Design Patterns](https://shop.smashingmagazine.com/products/inclusive-design-patterns) by Heydon Pickering

When talking to people, I’ve found the responsive-design analogy helps to reframe their approach to accessibility and inclusion. I follow up with technical recommendations, but it opens a door to having broader impact on product and UX practices.

Like responsive and mobile-first design, integrating accessibility and inclusion into the entire product development process offers another powerful opportunity and perspective to distill user needs, focus product value and intent, and yes, verify the implementation’s delivery.

_What challenges have you seen in producing organizational and process change around accessibility and inclusion? How are you overcoming them? I’d love to hear from you and continue sharing what I’ve learned._
