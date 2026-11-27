---
link: http://www.rubytutorial.io/rails-rescue_from
date: 2013-10-02 20:33 UTC
published: true
title: Rails' rescue_from
tags:
- rails
- ruby
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "944a03909e8336fb"
  vector: "9wH8CAwDAQT7/wIFCPb4/wEN/gICD/0K9fn9+v0A/vT3AAoEBAT9/AAB+wP59vn/BfkDBQIEBPwB/fcEBAP7+foB8wQMAQD99gMDAQD49gj58/wGBgb9Awz99/sECf7/A/cCAQgDAfoG/AL8A/4ACgf/DPz7/QL6DAcPBQD8BQAIDfQD+Qf6/wkI/PsI9v8E+AACB/z7BQsH//sICQD+/wf0CAUB/vn/9QT7AQT+/gH++wgGCQb4+wMAB/wM7AEA/fsA/v8A+fr9Av/4/vsFBP/y8wP6CP79+f4BAPv6CQAJ9wL2AfcIBv/48vgHCQH59Pz4Cv39/QD2BfsD9fIKAwMI/Qr8APn8Bw39+QAIAQL5Cfn2AQAGAAD+/AP0Bf8A+gQI/wb+BREBBAUD8Pz6/wD1CAj6BAIC+fX3/wT++wD7BwH7/P4D+/v9/f79BwD4CwT9/AAGBwUF//kDBPYH/wwKARQBAQL5BgQK//T++PkH+/MB/BH7+wP5+/wF/PwK"
---

<blockquote>rescue_from is a very useful method in Rails. It lets us to catch exceptions and pass them to a callback or a block. A typical usecase is to handle ActiveRecord::RecordNotFound errors like in this example:</blockquote>
