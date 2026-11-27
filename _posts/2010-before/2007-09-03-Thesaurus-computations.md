---
title: Thesaurus computations
date: '2007-09-03'
tags:
- thesaurus
wp:post_type: post
redirect_from:
- node/147
- thesaurus-computations
- 2007/09/thesaurus-computations/
- "?p=147"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "a085ba4b75cef475"
  vector: "/Pn7/v36APn+AwYEBAD8Cfv78fL/Agf9CQf4/QYBAgcEAPkE/gIJA/YC/wMJEfkP+wP8BQUJAAX+/fT///n7APwDCwf6CQgP/gX8BwD8/vf/AgQBCPwH+/oD/vkG8QUEBQMABf4E/Pn6BvgGBfUEBfoL/PwJ/xgI/gIGBfwE+wD8APr8/fvwBvEE8QYFAAD+AwL09gMFAQH2//n0DQEACP8GAQUH9gn8+AgJ9wAE+v7+CQL7Ag37+gX+CBAGAQUBBQr+Cg7+A//9/wP+Bfn8APz5Bu/2+/z4/gf8BgYAAAD8+wwDAvYC/vz8+wMD/wUADAcHDgD9AAoEAv7xBgH8+vn0AQH3//35BQfyAgYA8AP4BwQJAvsG+P718QD+BP4FBfv6A/0K/AP79gAJA/b7//sDBf7zAAcE/gP/+vsA/QAD/fv/APj/Bfj6Cf35AfsD/vz9//4AAAEAAvb/BPP++/MJDAf0BQEAAvsHCRACAAH//gME+vr9/v4KBPf+9vUI"
---

Today I just started computing the relations between groups. It's been chugging along on my local machine for about 8 hours now, I'm 1% complete and have a table with 5 million entries (at 210mb).

If a word is shared between two groups, it forms an edge between those two groups. I'm storing that edge as the two group ids and the "overlap" value (the number of words shared between those two groups).

My algorithm is iterating through every word, finding the groups that the word is a part of, and creating an edge between them---computing overlap as it goes. I expect the rate to fall off as duplicate edges are thrown out.... but we'll see.
