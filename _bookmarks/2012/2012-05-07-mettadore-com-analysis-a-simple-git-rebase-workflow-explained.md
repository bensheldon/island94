---
link: http://mettadore.com/analysis/a-simple-git-rebase-workflow-explained/
date: 2012-05-07 15:00 UTC
published: true
title: A Simple Git Rebase Workflow, Explained - MettaProgramming | MettaProgramming
tags:
- development
- git
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "ffa273ff824ef242"
  vector: "CPcE/v//+wX/A/8AA/v2AfoLAfn8/QAIAgIFAff7AQcABvcMAQH//v8GBPwHAfz/+f4F9f0HBAgF/gr+BAf6+AL5CxAL+QEE8vn4/f8H/AD5APz7Af8MDA0E+v8K8QX7Av8NBAYBBfUBCv8HAAAB/fwBAA8H/fUDAAIA//oE+wAMBPkNBgL7//v/Cwv///vz+QEFDPEC/QAJ9gIF/voE//wGAf79+QL+B/j09hMAAv0S/QwEAfrtBP38AQoD+fsGAAH/Cw/7+AUDAPsBAQkD//sD9AENBQED9wgCAwP/CgD8+gEF+fz2/P/y+PoE/vr8A/37BAYEAQT5B/cBC/0H9/7+/v7+BgQC/wH89/4F9wX1+f37+Pr7AAYB/gD99wMH7/j++vQI+wX9/gn8/vX/+fsA/vkEAfwDDvz1/QH7AQAECAIJA/4BAgH69gD6/ggHA/3//fb6Bwz2/wwT+f0RA/cA/foHAQgG//r9Bvb4/vr+AAsE/AQICQYFCAEC//35"
---

There’s a lot more that rebase can do, a look at the man page or The Git Book can tell you a lot more.

As a summary:

checkout a local private branch and work in it.
Use ‘git rebase’ frequently to keep up to date with the master repo
Merge changes into master from your rebased local repo
Furthermore, when you merge your changes, you have three choices:

git merge {branch}: brings in all commits/history from branch
git rebase {branch}: same as above, basically
git merge –squash {branch}: brings in changes as one commit, throws away history
git rebase -i {branch}: brings in changes as one commit, condenses all history into a single log entry
Git rebase takes some getting used to, but the results are worth it. I highly recommend giving it a try.
