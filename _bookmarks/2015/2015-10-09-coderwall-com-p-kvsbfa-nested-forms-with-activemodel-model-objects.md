---
link: https://coderwall.com/p/kvsbfa/nested-forms-with-activemodel-model-objects
date: 2015-10-09 15:39 UTC
published: true
title: Nested forms and validations with ActiveModel::Model objects
tags:
- rails
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "14c7acba4215a6cb"
  vector: "/P78Cf8D+AH5AwT3DAYDC/j+AQAC/gQF8v8AAAP8BP4BBxD4Agb9+AMBBwH9+gT6Bv/+AAgF//n18/H//gL2+vIO9gUACgsB9QMD/AT7/fz4Cvr1BAL//v39+wILDQD8DfsCAfkCAQIH/QP9AAP//QMGAwT5+/0DAP4IBALu8AAOC/sPAA75CAEA+QH6BA4C+wb/A/z++QH9Bv4M+QH7+wH+Agv+/AX+CAECBPsA/wT/BAYB+gD6/vkHBvwH+Pb+/P38+Qb9/ATp+QP1CPv/Bv8B8gr//AYA9vv9/QH3AgAF+wH8B/oOB/f5/voN/AH69PgNAP0HAAT7A/ECAwUDBwMI+QUA/gb8/wL8/wEFBPj1/AD4+QIE///9BQP/D/wIAfwF+AL8AwD7BgD6/AIB/fb6DAz6AA0G+gsDBA4C/AD1Awb8+vMHAAX+AQP3/AUBAAr5EgUEAAIJ/PgFAgQIAAgJ+gH9/gH+BgL1/AUG9fgAA/kG/ATw/gAFDvIL/wQJ"
---

<blockquote>One thing that I think many have found lacking, however, is has_many and accepts_nested_attributes_for functionality. I found myself in this boat recently when I wanted to use these form objects to create multiple records. How can I have a form that can create arbitrarily many records and have validation errors appear for each record I'm trying to create, without associations?</blockquote>
