---
link: http://benwoodall.com/blog/2013/10/20/validating-rest-queries-with-rails/
date: 2014-01-30 23:55 UTC
published: true
title: Validating REST queries with Rails - Ben Woodall
tags:
- rails
- ruby
- validations
- api
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "5e75da095220c50f"
  vector: "+Qj/BP39/QD6APUFCgP8BAsJA/0DBf8G+vf7/v35BPv1BwX5CvIAAf799wH++P78AQD++f36Avr6//f6CvwC//4H8/4HAf797gD8Av72+AP0/voJBQICBAv3BfsHBwUE//T7BwH7AfoIBAIG+v4BCQIGBAQJBP/8CA0OAgv4BQAGDP8D8gkA/wT9AwYD+AcD+QYHCQH0/gj/Af8GAv7++gn+Cwf/Cfv7+wD3BPwD+wME+voFBwr39QAFAfcS8vn8/v37CQQA/AH/Af3sAwwFAwv38gj7/gIG/QX/Agb6CAAD8AcHAfcGBgH8/PkB9/v28vsFDfoJ9f0BCvf69foI/wX79wD/DAABCAH7+wIA/wL2BP/5/fwI/QACAAXzCAMD//QC9wr+BP8JAxL++QD9//P5DRIAA/0E9gT/+QAB9gD5Av8E+wMI/f3/BAD6+gL8/wr3Af0FCgELBPcLBPYJ+woBAwb8Bv8AAwT7AQT9Afr7/Pr3/gb5BQX6A/gKAAQH"
---

I’ve recently been working on a few RESTful API’s using Rails. One of the problems that I keep seeing with end users is that they usually don’t read the documentation very well and make simple mistakes when making specific requests and queries. This is easily solved with error handling and validation of the API. There are a few gems out there that will handle this sort of situation for you, but there’s already so much in Rails to help you get this done out of the box.
