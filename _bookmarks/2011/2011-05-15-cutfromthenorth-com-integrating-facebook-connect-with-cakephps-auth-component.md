---
link: http://cutfromthenorth.com/integrating-facebook-connect-with-cakephps-auth-component/
date: 2011-05-15 19:03 UTC
published: true
title: 'Integrating Facebook Connect with CakePHP’s Auth Component :: Cut from the
  North'
tags:
- cakephp
- facebook
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "d76aa5f173d2aa1f"
  vector: "/Qv2AP8H+vv7//76+AQGDAH3/wL19/4FA/QB+gQFBwP7APL6BAf++vz5+wcBBP8A+wIAAQgF+AcABP8EAPkFAgED8/z7A/8D+PIEB/EAAPkEDgYEBAX3+Pb9AwADBQH//P/6/vgJBf4KBAAECAsG/gL7BP74+ggDAgD/Af/7+QADDgcCAP77+v8A/wMDBwP/+fsFBwD8/wMJBgEN/f0DCgH+Af4G+/b+CP4B/P4C/RAKAPYC/QEL9fP/+vcE+vz77v/8Bf/8AAn0/PL9AwAICQb++Af8AAr89/cKAxML+AAF+gUCEv8KAAL9+wEB/AgE/f4IAv8I/vYHAwIBAPr6BPv69gn7EQP6A/7xAgUJ+f3zBgP/CP32/goC//j6AwsR/AD/Bf0M//8ECgf6BP8ABfcBCf398/T9BBD6B/j5AQAC+fr9/gEB//8K9woC/fr7CPz++/oH/gIC+/L8+Af3Aw/3AAnx+vj2BwQE9f34BQQLAAEF/vwEAv0IDPj8/wL7"
---

NOTE: This post is out of date; working on an updated post to leverage the new Graph API

I wanted to be able to leverage all of the advantages of using Cake’s built in Auth component in my latest application; problem was that the application needed to allow for both normal user accounts and Facebook Connect generated user accounts. I struggled for a while to find the most seamless approach, and then it clicked — dynamically set Auth->fields.
