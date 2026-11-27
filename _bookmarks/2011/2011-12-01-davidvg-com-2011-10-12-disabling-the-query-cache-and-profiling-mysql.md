---
link: http://davidvg.com/2011/10/12/disabling-the-query-cache-and-profiling-mysql
date: 2011-12-01 21:23 UTC
published: true
title: 'Disabling the query cache and profiling MySQL : davidvg.com'
tags:
- webdevelopment
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "b73fb4a0089513ca"
  vector: "DgMACPr6Av4BBfn+BAL2BP32/v/7BQUDBPz2//77/Qn5/gv//AMHA/0CAQcDBvoAAfv6CwL6+wH/DPkF+gMCBPgEAfkFBAcF8AMIAf30///7+QL1Bf4I9P76APz3A/z7CwcHBAr8/hf/AAwD/P/9BQEB/QoBAvkKDgT4+PkIAgD7+P37+Af7BwL+A/j+BfYHAv0HAgT6AAT+EwIF+gEE/fr4AAEFA//7+gP/+vgC9gP4+/j//wr7+gf+9Qn9+/r6A/4BEAIHAQQQ/ATx/AT7BwcA/fb6+gID9wkGCAMC+QD3/QIBBQAFB/j3Bfn/BPoG/AEGCvcK9v37/fYBB/8DB/HyAQD2+/0GCAb+/QgB8fT8B/sBBvgD9/r/BgIBBvkEDgAFDwYH9wIEBQX+9gMBAAcF+fwABPYN9wgK+PQF9QAG9gIKCf38Ef79Bv0G/wj39wD/9ff9+v0G+wEFBvr6AgP7BAj49vkAAQMEAQEDAwsM+P37B/0EAwkICv8F+Pf/"
---

SET SESSION query_cache_type = OFF;
SET profiling=1;
