---
link: https://simonwillison.net/2025/Aug/9/when-a-jira-ticket-can-steal-your-secrets/#atom-everything
date: 2025-08-09 15:59 UTC
published: true
title: When a Jira Ticket Can Steal Your Secrets
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e023351a362f7106"
  vector: "7gD57/oCA///CgX/BgEC+wb9/AP8+vv88/4J/f/0/wX0A//59/sC/wUE+AEP9QL+CQD7BAoD/v4QAfkJAAAD//b+AgYOCwr+8/74A/j8Bv389wgDCgr7+w3/CP4R/v0DAvb0/AD/AgQHCAr0AAUBDAcE+Qn9Bwr6CP/9AP39+AACAfr3AQD+/wED/vMB/wUK+wQA/gr4+/f/C/cD/gX5/ggCBQL9/v8DAPkB/wL9+wL8+vwB///5AgX4BwL8APsC+fv98QYC/gf69AD2AQUI+Qn/BAj8/QP+9wYPBf76+AD5B/4G+fv/AAb59wIB+A0EAwn1+wX2/AcE+f/8+wQD/fX+/PkGBf/7CwP9Dvv4+wkBCf/8CQQA+Aj2Bv8C//QMDP8BD/r6AgYB/wD38/sFAwb5AvYGBPz9Af/4+PoD/wAEAP72Av3xCAQCDAb+BgYRAwH8+f4J+v0CCfoHCQX69wkM+gQKAwYD9wP8Afr5B/cGAfr5CQj+9wAAAwgGAgEI"
---

The only way I know of to avoid lethal trifecta attacks is to cut off one of the three legs of the trifecta - that's access to private data, exposure to untrusted content or the ability to exfiltrate stolen data.

In this case Cursor seem to be recommending cutting off the "exposure to untrusted content" leg. That's pretty difficult - there are so many ways an attacker might manage to sneak their malicious instructions into a place where they get exposed to the model.
