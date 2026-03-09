---
link: https://pganalyze.com/docs/query-advisor/insights/wrong-index-order-by
date: 2026-03-09 16:57 UTC
published: true
title: Wrong Index Due To ORDER BY · pganalyze
tags: []
---

When queries combine WHERE conditions with ORDER BY and LIMIT, Postgres sometimes optimizes for quick sorting instead of efficient filtering. This can result in scanning massive amounts of data when only a few rows are needed.
