---
link: http://nodejstutorials.blogspot.com/2011/06/i-have-been-playing-with-node.html
date: 2012-04-18 23:50 UTC
published: true
title: 'All about node.js: Using node.js and jquery to scrape websites'
tags:
- nodejs
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2338adcc08e0f5a5"
  vector: "9f78Bgb69gb99v8GBfsEAQMKCvn9/wD8+wQB/wP+BfUBA/QH/Pj/+Pb/+/4J+fYGAQL7+v749gYA8gP///8GAwYD9QYB/fkB+wf48/b99QX6+/wQ9woCBv8CBfwIA/8GCP4D+wIE//L5Bv4HAQT9CPj1BfcI9QsLBxX+AREBAwAKAAQEAAQGAPUEAggA/gMGBf4PAAP+DBIEBfcPBP4F9PkB/gME+P//9P8H/PYB+fwGAv7/BwP8CP/4/AUK/wP8+wL9A/z/BQUJ+QYC/PcE/wX6Cv8FA//4AQgJBO/5+wD4/P8KAgD1/wL9+Pz6/vwMAfYAAPwA+vn9//r++gAEAQoAAgH5Cwr5BQEA9//78BQG+Pz/+/j8AQABAAf4AvcM/vcA//T4AgIJ+vkDAQEBAwYKDQADAPr9BPP9BP4FAAD3/PUG+gYPBf0IA/z4CgMIC/4DAgT/AgQMAv0DAv3yAP8GDv/2+/UDBQr6//4A+vsL///6AvwBAv3/AAUD/AIB"
---

I will write a simple application to capture details from various websites. The beautiful thing is Javascript has been handling DOM objects for years. In fact Javascript was created to handle DOM objects. No wonder that it’s more mature than any other html parsing library. Also, given that there are many elegant frameworks like Prototype, Mootools, JQuery etc. available to use, scraping websites with Node.js should be easy and fun. Let’s do it. Let’s write an application to collect data from various book selling websites.
Create a basic searcher.js module. It would provide the fundamental skeleton for writing website specific tool.
