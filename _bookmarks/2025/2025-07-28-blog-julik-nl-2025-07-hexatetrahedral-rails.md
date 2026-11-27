---
link: https://blog.julik.nl/2025/07/hexatetrahedral-rails
date: 2025-07-28 15:16 UTC
published: true
title: Hexatetrahedral Rails
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "35ef2747fe5fd8c0"
  vector: "9/zvCAQF+gb+BP4K/gIIBAMDBvwAAQIE/vv+AQD8CAIBAAD/BP3++wIN/AL2/PkABf8F/AYA+f//9PkBAwoA+QEB/QMI+gn/+/8E/gD4B/v6A/v//v/7/QADAP4NAPoBBgH6BAH/AAX7/wUIA/kFC/z6/wf+/wb++gMKDA769wAHC/cF9gb9/Pr7/QoFAQT1+QIG/vwF/QsC/v8DAgUDBPoECAb6//7//wv19QgIAQT/9wwDCQoB9Qf/F/wD9/gL/wYF/Qr+/Aj6Avr0/QX6BQEF8QYDAAL77w0BBv0EDAAB+Qf3//cI/P8ABvYC+wP5/vgHDfQH+AQKAOj9BvT/AALy7wrzBwL4BP/z/QII+ATzB/7++fMJ+QYDAAAPCv8B/vkFBQEDAwUCAwQD+wT//u73CAYBAQAB+AT8+An//AACDP4A+PcEBQYIC/v4CwEB+Pz5Bf3/+AT++gD8B/UDA/oHBQf9BAb/AQD9AgL7APj9+PP/+gYACQMB/fYF9/YF"
---

My humble suggestion is: don’t do it. As I have outlined above, I believe there to be one - and only one - reason to use that architecture, and that is reducing the API surface of ActiveRecord. Such reduction can be useful if you have a large and growing number of teams which are going to collaborate on the codebase, and you know that those teams will prefer to work in separate, completely isolated modules.
