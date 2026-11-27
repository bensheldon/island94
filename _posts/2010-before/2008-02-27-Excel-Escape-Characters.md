---
title: Excel Escape Characters
date: '2008-02-27'
tags:
- spreadsheets
wp:post_type: post
redirect_from:
- node/203
- excel-escape-characters
- 2008/02/excel-escape-characters/
- "?p=203"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "44fbcb7308a04f41"
  vector: "/gEEBfv8/w0OAQH0APsPDwf8+P0IA/oEE/39CwIR/f0F/wAM/P4OAQX6BgEF/wEGAwf7BP0AA/z4/gj/BwH8Bfz49gf3BPgA8wABCff3BQ4C/AIEBfsJAAEN+/sNAPEA/P/6+wIEAPv0/gT5BP37/wH3//77+QoBAwT6BwD3AAD1AQQHAP36+/AH/gAIA/gQBf0JB/z/BAgABA/+AwH89gT0AgYCAgAG+QQKCQECAAIH//f7CAT5BwAG+frqBf4F/P8HAwH+Bfv8//z9Avz79vwC+QL89fsBAQf/8fQH+QAIAwL5/QEJ/QL5+QP/+f/9/Qn69vb//AQLA/z7+wf1BwMJ+gcF+gf7BQYGCQIA8v4ABfcA8gL+/ff6AvX5+Av4+/n4BAD5BQD5/fv7+gT4CwIGBAIB9QEG+PwDBf0H+QABCAcA9/73+v4FAfr++wIFAv4BAf0H+QAG//T8AAgAAgP69vwM+woEBvzuAv8DBgUCAQz0+/z//gEHAwEJCQXz"
---

If you want to insert a parenthesis into an excel formula (for example, concatenating strings into something to export), you want do use double-double-quotes:

```
"I am ""cool"""
```

Produces the text string _I am "cool"_

A useful example is producing email addresses:

```
=CONCATENATE("""",A2, """ ")
```
