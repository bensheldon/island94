---
title: "Framing open source contributions at work"
date: 2023-01-26 16:51 PST
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "91e3aa8807b5e7d7"
  vector: "AvkBARAI/g39BvoPAv0BBQUD+/vz/QMM+wD7/v72AgQF//wBB/z7/P3/+wIB+g74A/0F+//5/fwB+P3/CQkB+wX39wj//gb9+/MBAAQCCAMDAPsB+AAHAQkCAAMO/v0BAv77CP/7Cvn6BQEKBwAI/wADCAD5+wQGCQ4EAfgG+gD7DPgL/P8DAPj9AQ0FCAj0+AMGBQP6/AAL+AED+AEJCQD8+ff9+AD69gLyARQHCwT79gIACQn5+wLzBPgA+vgE+wMNAwgB8wP5Avnz9gsCC/8D+gMGBQcDAA0B/wEJCAD/9QQCAPr+9QT7+/0B/vjv+/8CAPsI+vsKA+z4A/oCCv309wn1+AP8CQIC+/wI/AH/AQP8AvUH/goC/Af/Cwb9+vcEBgL5/QD/Bv8H+gT2/Pn4Bv0CBfz9Av3uAPkCAwADCfz++gH9BwUIAv/5CPsI+AD7/wUHAAH8+QIDAfkLAAAJBPsEBQcJAgkG+fD49/z4+v0B9ggEBv3/+/z/7v0E"
---

Excerpts from the excellent RailsConf 2022 keynote: [The Success of Ruby on Rails by Eileen Uchitelle](https://www.youtube.com/watch?v=MbqJzACF-54) [reformatted from the transcript]:

<blockquote markdown="1">

Upgrading is one of the easiest ways to find an area of Rails that can benefit from your contributions. Fixing an issue in a recent release has a high likelihood of being merged.

Running off Rails Main is another way to find contributions to Rails. If you don’t want to run your Main in production, you could run it in a separate CI build. Shopify, GitHub and Basecamp run it.

Running off Main may be harder than running off a release because features and bug fixes are a little in flux sometimes. If you are running off of Main, a feature added to the Main branch could be removed without deprecation. This is a worthwhile risk to take on because it lowers the overall risk of an upgrade. When you run off Main, you’re less likely to fall behind upgrading because it becomes part of your weekly or monthly maintenance. Upgrading becomes routine, second nature rather than novel and scary. Changes are easy to isolate. It’s just slightly less polished. Like I said, I still think it’s pretty stable.

Another way to find places to contribute is look at your own applications.

- Do you have monkey patches on Rails code that are fixes bugs or changing behavior? Instead of leaving them there, upstream the fix and delete the monkey patch.
- Is there infrastructure level code that doesn’t really pertain to your product? It’s possible this could be a great addition to Rails. When I wrote the database in Rails, it came from GitHub’s monolith. It made perfect sense because it was getting in the way of upgrades, didn’t expose any intellectual property, had nothing to do with your product features and  
something many applications could benefit from.
- Lastly and most importantly, keep showing up.  

… Ultimately, if more companies treated the framework as an extension of the application, it would result in higher resilience and stability. Investment in Rails ensures your foundation will not crumble under the weight of your application. Treating it as an unimportant part of your application is a mistake and many, many leaders make this mistake.

…leaders see funding open source risky is because they don’t actually understand the work. … Often, leaders worry if there’s a team working in open source, other teams are going to be jealous or resentful that that team is doing “fun” work. …

Maintainers need to make changes, deal with security incidents and also handle criticism from many people. Maintaining and contributing to open source requires a different skill set than product work. That doesn’t make it any less essential.  

…Many product companies don’t like words like “research” and “experimental.” They can imply work without goals. Use words like “investment.” And demonstrate the direct value will bring. Make sure it is measurable and will make the application and product more successful. A great example of measurable work is a change that improves performance. If you can tie contributions to direct customer improvements, it’s easier to show leadership.

…As I started contributing more and more and pealing back the layers of Rails, the impact is limitless. I started looking at how applications stretched the boundaries of what Rails was meant to do.

…Ultimately, I want you to contribute to Rails because it’s going to enable you to build a better company and product. The benefits of investing in Rails go far beyond improving the framework.

Investing in Rails will build up the skills of your engineering team. They will developer better communication skills, learn to navigate criticism, debugging skills and how the framework functions. It will teach engineers about the inner-workings and catch bugs.

Monkey patching is far more dangerous than I think most realize. They break with upgrades and cause security incidents. When you write a monkey patch, you maintain a portion of Rails code. Wouldn’t it have been better to patch it upstream rather than taking on that risk and responsibility.  

It will give your engineering team the skills they need to make better technical decisions. You’re ensuring that Rails benefits your application and the company for the long-term.  

…Contributing to Rails is only _not_ essential if you don’t care about the direction the framework is headed in. We should be contributing because we care about the changes.

We want to ensure our apps are upgradeable, performant and stable.

Investment in Rails also means you won’t have to rewrite your application in a few years because Rails no longer supports what you need. When you fail to invest in your tools, you end up being unable to upgrade. Your engineering team is miserable. The codebase is a mess and writing features is impossible. You’re forced into a rewrite, your engineers want to write Rails and you can no longer let them do that. You have to build a bunch of features before you site falls over.  

It’s not Rails’ fault you made the decision to invest elsewhere.  

If you build contributing into your culture, the benefits are clear:

- Your engineering teams’ skills will improve.
- Rails will evolve with your application because you’re helping decide how it needs to change.
- Your application will be more resilient because there’s low tech debt and your foundation is stable. Active investment prevents your application from degrading.  

Building a team to invest in Rails is proactive. Rewriting an application is reactive. Which one do you think is better for business in the long run?

</blockquote>
