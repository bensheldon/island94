---
title: "Consider Thruster with Puma on Heroku"
date: 2025-07-25 18:18 UTC
published: true
tags: [Rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "ca78b54198e5d97f"
  vector: "//v0AwL99QH/CP0D+f0FBwr2AwH2AfoF//f6+wD5A/r3BQQMBv31CQ/19wIAAvsBBPb5CQMCBPsDBgABAgIA+QH/AgIEBgQI9Pn0+AT1+Pz+/O4C+wIC+wMBB/wBBgD/Avr6/gD/+gUDBAkJ/gcAA/4NAhEA/wQCAQMGAAD9BQD9Af349gIA/wAA9QEA+gPzBQgMBQf37/wCAQT+/AMDCQMFCPf8/vkAA//rAvb0/v79BvoI/gT+9Ab4BQAE8/v5Bv0ABwEJ9gQB+wHw/AX/A/wG8gQBCgQB+AT+BQ7++gD/9gAODQIDBv39/P3+9gkAAgICAQIGBvsFAvr99v8IBPoG+Qv/EQH+EP34B/4J+f35Cgj8AAoIA/z/AgEP+PkDBfkMAwoABgP+EfkC+f/5CvQR/P7+Cf8FBAMABf0B+gAN9vsJ+P/7/QICBwD//gb4CPz++wH++f72CAME+PMJAPkBAQ34//4G//8BAAED9v79/v36/f8IBf7zAQIMAvIE"
---

To briefly catch you up to speed if you haven't been minutely tracking Ruby on Rails performance errata: the Puma webserver has some mildly surprising behavior with the order in which it processes and prioritizes requests that are pipelined through keepalive connections; under load, it can lead to unexpected latency.

Heroku wrote [~3,000 words about this Puma thing](https://www.heroku.com/blog/pumas-routers-keepalives-ohmy/), and [very smart people](https://github.com/puma/puma/issues/3487) are [working on it](https://github.com/puma/puma/pull/3506). All of this became mildly important because: Heroku upgraded their network router ("Router 2.0"), which _does_ support connection keepalive, which has the potential to reduce a little bit of latency by reducing the number of TCP handshakes going over Heroku's internal network between their router and your application dyno. People want it.

When you read the Heroku blog post (all several thousand words of it), it will suggest working around this with Puma configuration like (1) disabling connection keepalive in Puma or (2) disabling a Puma setting called `max_fast_inline`, though I'm pretty sure this has the same effect in Puma as disabling connection keepalives too (last I checked there wasn't consensus in Puma as to what parts of the related behavior were intended but surprising, and what was unintended bugs in the logic).

Anyways, there's a 3rd option: **use Thruster**.

- Requests on the Heroku network between the Heroku router and Thruster running in your application dyno can use connection keepalives (sidenote: I'm 98% confident Thruster supports keepalives because [Go `net/http`](https://github.com/basecamp/thruster/blob/10e33f6f5a2476231c00a59be209f7a58e98dc1a/internal/server.go#L9) enables keepalives by default and Thruster doesn't appear to explicitly disable them)
- Requests _locally_ within your application dyno between Thruster and Puma can disable connection keepalive and there shouldn't be any network latency for the TCP handshake because it's all happening locally in the dyno.

No one else seems to be blogging about this---a fact pointed out when I suggested this in the Rails Performance Slack. So here ya go.

1. Add the `thruster` [gem](https://github.com/basecamp/thruster)
2. Update your Procfile: `web: HTTP_PORT=$PORT TARGET_PORT=3001 bundle exec thrust bin/rails server`
3. Disable Puma's keepalives: `enable_keep_alives false`

I was already using Thruster with Puma on Heroku because of the benefits of x-sendfile support. If you're worried about resource usage (because Thruster is yet another process) it's been pretty minimal. I looked just now on one app and 13MB for Thruster next to 200MB for the Rails app running in Puma; seems tiny to me.

```bash
$ heroku ps:exec -a APPNAME
# ....
$ ps -eo rss,pss,cmd
  RSS   PSS CMD
    4     0 ps-run
11324 12792 /app/vendor/bundle/ruby/3.4.0/gems/thruster-0.1.14-x86_64-linux/exe/
 2960  1095 sshd: /usr/sbin/sshd -f /app/.ssh/sshd_config -o Port 1092 [listener
 2220   407 /bin/bash -l -c HTTP_PORT=$PORT TARGET_PORT=3001 bundle exec thrust
199336 187215 puma 6.6.0 (tcp://0.0.0.0:3001) [app]
 8316  1821 ssh -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o HostKeyAlg
 9172  6346 skylightd
 8244  1367 sshd: u16321 [priv]
 5548  1296 sshd: u16321@pts/0
 4444  1178 -bash
 4036  1964 ps -eo rss,pss,cmd
```
