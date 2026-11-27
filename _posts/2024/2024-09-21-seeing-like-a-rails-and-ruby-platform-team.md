---
title: "Seeing like a Rails and Ruby platform team"
date: 2024-09-21 08:17 PDT
published: true
tags: [Rails, Ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e2fab41df1592967"
  vector: "9Pj9Awn9+gr5AvYM//8GAQ/+9wIC+v8J+f39+//1/goDBvcGB/v6//r/9AL7+wz6+vkA/v/7A/4O9f0AAQf3/wX7/QkF///++gT//wQC/Pr7AwAJ/wAGBAoEA/sPAAUEBvn+Bf8ECvsAAf4HAfwGBP/8BfwFAwkLBg8IAAEI9QD/BfMH+gH9/AIFCg8ABQ7+9wcFC//59wMFAAT/+gECBQQEAfz4+f/2Av7yBgv+BQf+9AUGEA37+ATzB/8B/PwIBP4BBwYB8gf2BPzzAgD+Af4K/gT9/wv+9Aj9/QEBBQAG9AEJA/j99P/39PwB+wH5+fUD/PwN+PwD/uj7//cCBwX39gf5AwQCCv/4+/8F9f/9AgMA+/gFAAL/AQgBBQX89fkG+wT7//77/wAC//j0+vQAAgf+CPwGA//6+vIC+AAECgAGAgACCAALBwL5CgcI/QHy/gAC+gT5+P0EB/8LBP8FAfz6/wgEAgEABvn08/72/vkF9g0JCQH2AQIB8v3/"
---

When I’m not hacking on GoodJob, I work at GitHub, where I’m the engineering manager of the “Ruby Architecture” team, which is filled with fantastic rubyists. Our team mission is to:

> Make it easy for GitHub engineers to create, deliver, and operate best-of-class Ruby and Rails applications, and share the best of it with the world.

This is an adaptation of a post I published internally at GitHub, and its ensuing discussions, to explain what a team like ours _does_ when we’re supporting other teams and giving technical feedback. I imagine this is similar to other big companies’ Rails and Ruby platform teams, like [Shopify’s “Ruby Infrastructure” team](https://railsatscale.com). I hope this is useful in thinking about your own Rails and Ruby work, experience, and career development focuses.

### Before you “architecture”

The rest of this post is a big ol’ list of deep Ruby technical topics. To avoid premature optimization and architecture astronautics, I want to just quickly ground some expectations of any technical change you lead:

* Is it clear what it does, especially to others, who may be yourself in the future?
* Does it follow established patterns and precedent throughout the codebase, and is it internally consistent with itself?
* Does it accomplish the business goal? Does it work?
* Does it not prevent other components from accomplishing their business goals? Does it not break or negatively impact other stuff?

I write these things out because it’s very common, as a technical feature goes through multiple reviews and revisions, to lose sight of its original goals or purpose or business constraints. So set yourself up for success by being clear on that stuff up front, and push back (or go deeper) if someone tells you something needs to change _for technical reasons_ but it compromises your intended non-technical outcome.

### Architecting Ruby, the list

**A brief note about my authority on this.** The following list comes out of my experience working on a big Rails and Ruby monolith at GitHub, which has largely co-evolved with Rails and Ruby over the past 15+ years, and alongside 1k+ other engineers. (I’m also a consultant, and worked in a lot of software labs, and untangled a lot of other people’s applications too; and [not-Rails stuff too](https://speakerdeck.com/bensheldon/real-world-dashboard).) Many members of the team are core maintainers of Rails and Ruby, and we [treat the Rails Framework as an extension of our application](https://island94.org/2023/01/framing-open-source-contributions-at-work). Our team is responsible for integrating upstream changes in Rails and Ruby within GitHub’s vast monolith. **We upgrade and integrate Rails and Ruby main/dev/trunk changes weekly!** ([Never repeat, never forget.](https://github.blog/engineering/infrastructure/upgrading-github-from-rails-3-2-to-5-2/)) This continuous practice produces a deep familiarity with how change happens, and where friction builds up between an application and its upstream dependencies. Performing these upgrades over and over leads to experience, and repeated experience leads to intuition.

 *(btw, please reach out if your company has a practice of continuously upgrading Rails main/dev/trunk and running it in production. GitHub and Shopify and Gusto are trying to form a club and we want you in it.)*

There is a general order here, from most important to least in broad strokes. Remember, nothing here is intrinsically bad or should never be done; but in those situations there should be well-considered decision points.

* **Global namespace and Library/Dependency Privacy Violations**
  * Avoid monkeypatching or reaching into private methods or objects.
  * The most appropriate place to make changes is upstream.
* **Safety, Security**
  * Avoiding thread safety issues, like globally held objects and privacy violations, not leaking data between requests, or retaining big objects in memory. [Profile](https://rubykaigi.org/2024/presentations/jhawthorn.html), [profile](https://www.youtube.com/watch?v=pQ1XCrwq1qc), [profile](https://island94.org/2024/01/the-answer-is-in-your-heap-debugging-big-rails-memory).
  * Seeking object locality (or avoiding globalness) by storing objects on instances of controllers and jobs (or their attributes) and embracing the natural lifecycles provided by the framework. Frequently a developer desires not to call `SomeObject.new` at the usage-site, but to have a DSL-like callable method already ready in the appropriate scope (eg. `current_some_object`). We love a good DSL and they can be difficult to get right.
* **Code Loading, Autoloading, and Reloading**
  * Code autoloading is [one of the most important design-constraints in Rails](https://github.blog/engineering/infrastructure/upgrading-github-from-rails-3-2-to-5-2/) that can vastly affect inner-loop development (the “hands-on-keyboard” part) and production availability because of impact to application boot speed.
  * Designing for code loading and autoloading is critical to design, file placement (app vs lib vs config) and dependencies interactions
* **Internal to the Ruby VM constraints**
  * Even though Ruby makes it easy to introspect the runtime (`descendants` or `subclasses` or `ObjectSpace`) they shouldn’t be used outside of application boot or exception handling (and sparingly even then); they may have performance implications or be overly nuanced and non-deterministic in their output. Using `callers` and introspecting the Ruby callstack is a particularly expensive operation.
  * While infrequent and not-obvious, some patterns can massively de-optimize the Ruby VM with either localized or global effects. The Ruby VM (or accelerators like YJIT) are unable to optimize certain code patterns, and some patterns may cause VM-internal caches to churn inefficiently or to retain objects and their references unnecessarily (this can get tricky so please partner with us!). You probably want examples:
    - OpenStruct (though probably isn't a reason to use it at all)
    - `eval` and `class_`/`instance_eval`
    - Modifying singleton classes (using `extend` on objects) ([example](https://bugs.ruby-lang.org/issues/19436))
    - Anything that adds to the callstack (call-wrapping, complicated delegation)
    - (handwaves) Things that YJIT isn't yet optimized for, things that [deoptimize object shapes](https://railsatscale.com/2023-10-24-memoization-pattern-and-object-shapes/), which is the result of new fast-paths being introduced which now mean there are slow-paths that didn't previously exist.
    - Native extensions that don't release the interpreter lock
    - Metaprogramming generally
    * None of these are intrinsically bad (except OpenStruct and poorly done native extensions), and framework and platform level code definitely make use of them. And they're also constantly changing because of upstream Ruby work. And are maybe ok in isolation but a problem when copied as a pattern or introduced as a part of the platform for broad consumption. Something John Hawthorn has said:
      > A thought experiment I like to try is asking myself how I would implement this in another language without [Ruby magic]... Adding that constraint can help unblock thinking of simpler, more "normal" approaches without expensive metaprogramming.
* **External to the Ruby VM constraints and dependencies (memory, compute, file descriptors, database connections, etc.)**
  * Database stuff alone is a lot. The design prompt everyone is largely working from is “how does one architect an efficient, stateless application that sits between an end-user client and stateful data sources and manages bidirectional transformations of data?” Sounds hard when you put it that way, right?
  * Thinking about resource lifecycle, pooling, and how they interact across the various concurrency models available to use (process forking, threads, etc.). We do expect the frameworks and platform libraries we choose to keep these out of mind for most development tasks 😅
* **Design of the thing, for use**
  * Rails’s model of “convention over configuration” frequently means that how an object is structured and where it’s placed can have an outsized impact on how it behaves: e.g. within App, Lib, Rack Middleware, Other Library Middleware (Faraday, jobs system, etc.), Rails Configuration/Initialization/Railties, and more!
  * …and how those conventions relate to Maintainability, Developer Usability, and Conceptual Integrity.
  * Sometimes what may appear as simply an aesthetic decision can have a functional impact.
  * Identifying atypical or disordered usage patterns. Sometimes a desired behavior can be more of a happy accident than an enforced intention, and it might change upstream because no [one expected it to be used that way](https://www.explainxkcd.com/wiki/index.php/1172:_Workflow).
* **Dependency Stewardship**
  * In addition to Rails and Ruby, our monolith depends on hundreds of gems, double hundreds of their transitive gem dependencies, and several other runtimes and system libraries.
  * The nature of a monolith is that _we go together._ If some dependency isn’t compatible with the latest Rails or Ruby, or any other dependency upgrade, we must adapt. We work upstream, we patch locally, and worst case, we remove and replace the dependency with something more maintainable. All of this takes time and effort and resources.
  * We want to choose dependencies that are well-maintained: their maintainers proactively respond to upstream changes, are responsive to issues and PRs, and [importantly in Ruby](https://en.wiktionary.org/wiki/MINASWAN), are nice. (And to whom we are nice too!) That’s more important than benchmarks.
  * And dependencies should be well architected too, obvs.
* **Automating and Scaling: Packwerk, Sorbet, Rubocop**
  * We do our best to encode our knowledge and shape the application through tooling; that’s how our team scales! We send our custom rules upstream, too.
  * But it’s complicated! Sometimes that means that developers may focus on designing their code [in response to the automated tooling](https://island94.org/2024/09/the-novice-problem) and ending up with a less effective design or even introduce global risks and impacts to the application. At worst, a developer might even glaze over the linter’s intent by smuggling their design through a spelling or arrangement the linter doesn’t recognize 💀 Unfortunately the most important things are often the most abstract and arguable and difficult to detect or automatically warn about. We regret when we do have to tell folks that an approach is untenable in a PR or even after the fact when we notice production metrics have degraded.

### A conclusion about lists

I like making [lists of things](https://island94.org/2017/01/Engeering-Practice-Ad-Nauseam.html); I find them helpful. I also realize that [not everyone experiences lists the same way I do](https://island94.org/2019/07/truths-about-the-interpretation-of-falsehood-articles). For me, the purpose of a good laundry list is to be a quick reminder (“don’t forget to wash the handkerchiefs”) and not not an exhaustive list of actionable instructions (“the exact and best temperature to wash this t-shirt and that pair of jeans”). So please reach out to me ([Mastodon](https://ruby.social/@bensheldon) / [Twitter/X](https://x.com/bensheldon)) if:

- You think there is something that should be added to the list, or explained in more detail
- You’re curious how something in the list might apply to a specific thing you have

I’d love to chat. Thanks for reading!
