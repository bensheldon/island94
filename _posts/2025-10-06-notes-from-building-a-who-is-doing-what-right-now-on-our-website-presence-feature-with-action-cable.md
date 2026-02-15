---
title: "Notes from building a “who is doing what right now on our website?” presence feature with Action Cable"
date: 2025-10-06 14:59 UTC
published: true
tags: [Ruby on Rails]
---

![A screenshot of my application with little presence indicators decorating content](/uploads/2025/presence-screenshot.jpg)

I recently was heads down building a “presence” feature for the case and communications management part of my startup’s admin dashboard. The idea being that our internal staff can see what their colleagues are working on, better collaboarate together as a team of overlapping responsibility, and reduce duplicative work.

The follow is more my notes than a cohesive narrative. But maybe you’ll get something out of it.

### Big props

In building this feature, I got a lot of value from:
- [Basecamp’s Campfire](https://github.com/basecamp/once-campfire) app, recently open sourced, which has a sorta similar feature. 
- Rob Race’s [Developer Notes about building a Presence Feature](https://robrace.dev/blog/turbo-morphs-presence-channels-and-typing-indicators/#presence-channel)
- AI slop, largely Jetbrains Junie agent. Not because it contributed code to the final feature, but because I had the agent try to implement from scratch 3 different times, and while none of them fully worked (let alone met my quality standards or covered all edges), it helped sharpen the outlines and common shapes and surfaced some API methods to click into that I wasn’t aware of. And made the difference between undirected poking around vs being like “ok, this is gonna require no more than 5 objects in various places working together; let's go!”

### The big idea

The feature I wanted to build would track multiple presence keys at the same time. So if someone is on a deep page (`/admin/clients/1/messages`) they'd be present for that specific client, any client, as well as the dashboard a whole. 

I also wanted to keep separate "track my presence" and "display everyone's presence".

What I ended up with was:

1. Client in the browser subscribes to the `PresenceChannel` with a `key` param. It also sets up a setInterval heartbeat to send down a `touch` message every 30 seconds. This is a Stimulus controller that uses the Turbo cable connection, cause it's there.
2. On the server, the PresenceChannel has `connected`, `disconnected`, and `touch` actions and stores the `key` passed during connect. It writes to an Active Record model UserPresence and calls `increment`, `decrement`, and `touch` respectively. 
3. The Active Record model persists all these things atomically (Postgres!) and then triggers vanilla Turbo Stream Broadcast Laters (GoodJob!).  
4. The frontend visually is all done with vanilla Turbo Stream Broadcasts over the vanilla Turbo::StreamsChannel appending to and removing unique dom elements that are avatars of the present users. 

It works! I'm happy with it. 

Ok, let's get some grumbles out. 

### Action Cable could have a bit more conceptual integrity

I once built some Action Cable powered features [about 7 years ago](https://github.com/bensheldon/open311status/pull/59), before Turbo Broadcast Streams, and it wasn’t my favorite. Since then, Turbo Broadcast Streams totally redeemed my feelings about Action Cable… and then I had to go real deep again on Action Cable to build this Presence feature. 

At first I thought it was me, “why am I not just getting this?”, but as I became more familiar I came to the conclusion: nah, there’s just a lot of conceptual… noise… in the interface. I get it, it’s complicated.

In the browser/client: You have a Connection, a Connection “opens” and “closes”, but also “reconnects” (reopens?). Then you create a Subscription on the Connection by Subscribing to a named Channel (which is a backend/server concept); Subscriptions have a “connected” callback when [“subscription has been successfully completed”](https://github.com/rails/rails/blob/b927e4d45907a3c2eaecc9a31095337856b71e95/actioncable/app/javascript/action_cable/subscription.js#L9) (subscribed?) and “disconnected” [“when the client has disconnected with the server”](https://github.com/rails/rails/blob/b927e4d45907a3c2eaecc9a31095337856b71e95/actioncable/app/javascript/action_cable/subscription.js#L13) (a Connection disconnect). If the Connection closes, reconnects, and reopens, then the Channel’s disconnected and reconnected callbacks are triggered again. Subscriptions can also be [“rejected”](https://github.com/rails/rails/blob/b927e4d45907a3c2eaecc9a31095337856b71e95/actioncable/app/javascript/action_cable/subscriptions.js#L50). You can see some of this drift too in the [message types key/value constants](https://github.com/rails/rails/blob/b927e4d45907a3c2eaecc9a31095337856b71e95/actioncable/app/javascript/action_cable/internal.js#L2-L8) . 

…as a concrete example: you don’t `connection.subscribe(channelName, ...)` you `consumer.subscriptions.create(channelName, ...)` (oh jeez, it’s called Consumer). Turbo Rails tries to clean up some of this as you can call `cable.subscribeTo(channelName, ...)`to subscribe to a Channel using Turbo Stream Broadcasts’ existing connection. But even that is compromised because you don’t `subscribeTo` a channel, you `subscribeTo` by passing an object of `{ channel: channelName, params: paramsforChannelSubscribe }` .  Here’s an [example from Campfire.](https://github.com/basecamp/once-campfire/blob/3d0a10dbdd6d24941f22595072c2021f0c2dca10/app/javascript/controllers/presence_controller.js#L13)

On the server, I have accepted that the Connection/Channel/Streams challenges me, which is probably because of the inherent complexity of multiplexing Streams (no, not Turbo “Streams”, Action Cable “Streams”) over Channels that are themselves multiplexed over connection(s), and it makes my head spin. . That Channels connect Streams, and one Broadcasts on Streams, and one can also `transmit` on a channel to a specific client in a Channel, and often one does `broadcast(channel, payload)` but `channel` may be the name of a Stream. My intuition is that Streams were bolted onto Action Cable’s Channel implementation rather part of the initial conception though it all [landed in Rails at once](https://github.com/rails/rails/pull/22586). 

I'm a pedantic person, and it's tiring for me to write about this stuff with precision. Active Storage named variants—with its record-blob-variant-blob-record—has as an analogous vibe of “I guess it works and I have a hard time looking directly at it”.

I have immense compassion and sympathy and empathy for trying to wrangle something as complex as Action Cable. And also fyi, it _is_ a lot. 

### Testing

- You’ll need to isolate and reset Action Cable after individual tests to prevent queries from being made after the transaction rollback, or changing of pinned database connection:`ActionCable.server.restart`
- If you see deadlocks, `pg.exec` freezes or AR gives you `undefined method 'count' for nil` inside of Active Record [because the query result object is `nil`](https://github.com/rails/rails/blob/b0c813bc7b61c71dd21ee3a6c6210f6d14030f71/activerecord/lib/active_record/connection_adapters/postgresql/database_statements.rb#L167), that’s a sign that the database connection is being read out-of-order/unsafely asynchronously/all whack.

### Page lifecycle

Live and die by the [Browser Page Lifecycle API](https://developer.chrome.com/docs/web-platform/page-lifecycle-api). 

Even with `data-turbo-permanent`, Stimulus controllers and `turbo-cable-streams` JavaScript get disconnected and reconnected. Notice that there is a lot of use of nextTick/nextFrame to try to smooth over it. 

- `hotwired/turbo`: [turbo-stream-source does not work as permanent](https://github.com/hotwired/turbo/issues/868#issuecomment-1419631586)
- Miles Woodroffe: [“Out of body experience with turbo”](https://mileswoodroffe.com/articles/out-of-body-experience-with-turbo) about DOM connect/disconnects during Turbo Drive

And general nits that otherwise would necessitate less delicate coding.

- `rails/rails`: [Add ability to detect a half-open connection](https://github.com/rails/rails/pull/50039) by adding a client `pong` to the existing server `ping`. Action Cable currently [filters out ping messages](https://github.com/rails/rails/blob/4b494a53e1e10f0c523266c38d4f7f22b40fa021/actioncable/app/javascript/action_cable/connection.js#L142-L143), so not possible to do a pong or heartbeat without a change or patch.
- `rails/rails`: [ActionCable: Subscribe uniquely](https://github.com/rails/rails/pull/44653) about weird behavior when  subscriptions with duplicated identifiers happen
- `hotwired/turbo-rails`: [“Duplicate requests from repeated turbo-cable-stream-source signed-stream-name values”](https://github.com/hotwired/turbo-rails/issues/559)
- `hotwired/stimulus` [How to know when every stimulus controllers are connected ?](https://github.com/hotwired/stimulus/issues/698)

I ended up making a whole new custom element `data-permanent-cable-stream-source`. All that to wait a tick before actually unsubscribing the channel in case the element is reconnected to the page again by `data-turbo-permanent`. What does that mean for unload events? Beats me for now.

### What am I doing about it?

All this work did generate some upstream issues and PRs. I mostly worked around them in my own app, but maybe we’ll roll the rock uphill a little bit:

- `hotwired/turbo-rails`: [Allow `turbo-cable-stream-source` to be compatible with `data-turbo-permanent`](https://github.com/hotwired/turbo-rails/pull/756)
- `rails/rails`: [Fix Action Cable `after_subscribe` callback to call after deferred subscription confirmation transmit](https://github.com/rails/rails/pull/55825)
- `rails/rails`: [Add `success_callback` to Action Cable's `stream_from` and `stream_to`](https://github.com/rails/rails/pull/55824)
- `reclaim-the-stack/actioncable-enhanced-postgresql-adapter`: [Fix incorrect escaping of large payloads](https://github.com/reclaim-the-stack/actioncable-enhanced-postgresql-adapter/pull/6)

### Notes, right?

Yep, these are my notes. Maybe they’re helpful. No big denouement. The feature works, I’m happy with it, my teammates are happy, and I probably wouldn’t have attempted it at all if I didn’t have such positive thoughts about Action Cable going in, even if the work itself got deeply into the weeds.


