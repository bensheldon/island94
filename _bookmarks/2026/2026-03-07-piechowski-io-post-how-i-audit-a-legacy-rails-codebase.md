---
link: https://piechowski.io/post/how-i-audit-a-legacy-rails-codebase/
date: 2026-03-07 00:09 UTC
published: true
title: 'How to Audit a Rails Codebase: Legacy App Playbook'
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e169797d924e110f"
  vector: "/v8AAwwFAP/0BQIH+/j3AQX/AgL2//wJ+vwBAvn7+wIFCAr7CvoC+v39+wH88gD3AQX7+Af2//kD/v0FBQT6BfoE9AYA+/f/8/r8A/8C//X6+PkN/QUFAwMEBP4IBAX6/fgDB/8GBvX/BwICAQb/B//7Ef39CQAEDBEE+wEFBAADCvoF+AQABv8EAhL6+gMB9ggHBAPx/gMJAQQIAAT9AQr6Agf7AP78+Pv3/AP/AvwB/gQDAQz6+AD2A/sQ/wD67P0E+wYF+//6/P32+QUCAQfxAgH/AgcA9wj1AwL9CQD79QEC+/D3BQIA+f3+APf4AfUIAPwO///8Bvz3+/MCBQUK9/8A+wcAEgUB+/oGAgQEAvv+Bf34BwX9/Q8BCwAAAfkNAf/6+QHxA/4M8vj29gT3AwUFA/j7AQPz9fL3AAABCQMABv8ADP3//v3yCwX7+wP7Af4M//34+voMBf4MBgP4/wH//wUC/AUF/vT79vj9/Pr/AAsCBwED+/cJ+v4I"
---

Questions for developers:

“What’s the one area you’re afraid to touch?”
“When’s the last time you deployed on a Friday?”
“What broke in production in the last 90 days that wasn’t caught by tests?”
Questions for the CTO/EM:

“What feature has been blocked for over a year?”
“Do you have real-time error visibility right now?”
“What was the last feature that took significantly longer than estimated?”
Questions for business stakeholders:

“Are there features that got quietly turned off and never came back?”
“Are there things you’ve stopped promising customers?”
