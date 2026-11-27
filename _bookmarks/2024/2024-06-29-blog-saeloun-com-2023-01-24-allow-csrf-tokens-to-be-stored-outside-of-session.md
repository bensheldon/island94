---
link: https://blog.saeloun.com/2023/01/24/allow-csrf-tokens-to-be-stored-outside-of-session/
date: 2024-06-29 20:00 UTC
published: true
title: Secure CSRF Token Storage in Rails 7 using Encrypted Cookies
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "f334d73ae3e9ca92"
  vector: "9v7vCP/8CwL6Bv4D+wUHAQMH+gUEAAIP8/D/+v4BBfz+AAb9BfgJ+P4E9//zBA/+/fwBBP/86fD99QIHAv0I+/P9+QYEBAYB+/cE/gP2/v4D+AcFBPv8Bgf8AQf/A/r4A/36BgAFA/8LAAEJBgcHB/8MAwX7AgcDCQcCAv/6AwABBfkF9AP//gr6Bf8GBP3/9PwO/AQB/v4B+wQB+wL5AAr/EwgKBfz6Bv79BfQC+A0E//kFAQD/+Pr8AO0G8AL7/QIIBgH1+AQFAPX9BA0DBwL39w78/QcA/u8B+AL//QAC9wMKBAEKAvr98/wBBAT69AkD+fT8/QgIAPL6BAH4BAr69vr+A//9A/4AAAoJDgACCQP99PsI+wQD8/gC/Qb+AgL8+wb9AwYNBQb6BvcCBPvyARIBAgIE9f3/AAEHAAACBwME+wwD/Pn9AfwC+fAE/f39/P3/AAUDB/oFAPoC/QEC/Qb7/gUDAAD/AQAE+gL+BPwGARD+APz7BP4P+gAB"
---

> To use this feature, we need to set config.action_controller.use_custom_csrf_token to a lambda that returns the token to be used for the request. The lambda will then be called with the request object as an argument.
