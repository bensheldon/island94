---
link: https://inessential.com/2021/03/20/how_netnewswire_handles_threading
date: 2021-03-22 04:54 UTC
published: true
title: 'inessential: How NetNewsWire Handles Threading'
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "8abf7618ba14b7ba"
  vector: "/v0F/Pz7+QEGAv8FAPwC+vz1/fP1/gAACQHx/gT//vz5CPMD/QIDAvj/8/v49/z+A/359///D/8A/v/9Bv/6ARP8CAkK9AAB/goF//wDAwMDAwINBfoAC/j8AgoK+AIH/APzBAL4A/4GBQcA+gL5CPwCAvn5BQkQAQb+AAoGBQAID/8DAf7+CPD9Afz9/wX4/QABCALu/wj8/QQDBf//BQAG/fv9+QQB9QX3AgMG+vb6AgECBQcCAwn3/QYDAPQG/AcGCQQC9/j3/f4E//cBBAUA/wP8/wECBREE/QUHAQD7+vcDC/74+vr9A/72Dfz6CQAF/gT/9/8C/vT2/P8E+wXyCAn0AAEEA/n7+wME9vvxCgACBPgB/Ar1B/3//AAH//wJ+/UK/gj7/PoC+wHz//QHAwTz/goC+Pv/+PQIAgAEB/gDBP/5/REPDPn9/RAL+gf79w4C/gkC+AgM+wD7AwECBQIABQT//wYCBwgE9/0B9wYJBAkBDQj9/P0DA/r9"
---

Some developers I’ve known seem to think that being good at concurrency makes them badass. Others seem to think that senior developers must be great at concurrency, and so they should be too.

But what senior developers are good at is eliminating concurrency as much as possible by developing a simple, easy, consistent model to follow for the app and its components.

And this is because concurrency is too difficult for humans to understand and maintain. Maybe you can create a system that makes extensive use of it, and have it be correct for one day. But think of your team! Even if you’re a solo developer, you and you-plus-six-months makes you a team.
