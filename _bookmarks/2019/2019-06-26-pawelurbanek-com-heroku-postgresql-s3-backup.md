---
link: https://pawelurbanek.com/heroku-postgresql-s3-backup
date: 2019-06-26 13:59 UTC
published: true
title: Backup Heroku PostgreSQL to AWS S3 Bucket [Step by Step Tutorial]
tags:
- heroku
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "75eced210db2b4ea"
  vector: "+f75/gUD+wX/CvYDCfEE+wAG/v7uAQAGAQEABPn8APUF/wULBPz0AQwE8/cA/PX8CfgB+wUB9gYEAAf+BAUDAAQF/wIGCf7/9QP1BQv5+wvz/vUE8QL5+/8A/fAOAvwCA/sD/wIBCvkICf/++gUG/wAHCAb0/wIDEQUL9f4AAAAEAQ8EAAX9AgEH/QP//PgA/gIMAAn8/PkI+Qn3DAT4Bv4BAgL0AfYKDfz3/wcDB/j9B/f8AgD99QjxCPr9Av0CAP73D/oC/wf/AgT4/AEFAPv58wT9AQUC+fwA/wv5+AD5/AANC/kBC/7/9fsA9AYB+/X2AP78AwwDAP0A/goBBf0H9Pr9CwH1Bv0A/gQN/wcBBvv5+QcG+gUH9wMA/w4D/PwFBAH+BAYJAwoA9vsD/AgAAgQH/fsB/gr0/fkCAgAFA/4L/AAAAAn8Avn+BvUBDQEB/fMABfoICfQGBfgB+PUBBfz8+wH7AAYB+/r7Awr2Af33AA8NAPz+/wcG/P4E"
---

<blockquote>Heroku offers a robust backups system for it's PostgreSQL database plugin. Unfortunately, you can irreversibly lose all your data and backups just by typing a single command. It might seem improbable, but still, I would rather not bet my startup's existence on a single faulty bash line. In this tutorial, I will describe how to set up a proprietary Heroku Postgres backups system to a secure AWS S3 bucket.</blockquote>
