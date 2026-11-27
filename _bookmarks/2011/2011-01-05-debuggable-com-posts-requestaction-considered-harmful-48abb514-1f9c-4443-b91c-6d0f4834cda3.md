---
link: http://debuggable.com/posts/requestaction-considered-harmful:48abb514-1f9c-4443-b91c-6d0f4834cda3
date: 2011-01-05 13:41 UTC
published: true
title: requestAction considered harmful » Debuggable Ltd
tags:
- cakephp
- php
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "25b5357632924a5e"
  vector: "+fz/AQH9AgIDBAEA9gL9AQ/7+AQD+PcFAvP+9QECBQAA/fUIBgD+9P0K+wD6/wT+AfwGCgj7+/f5AgQI+vb//AYICfgHAv0G9wEBAvL3+fILAwEDCAL8+QX+BQUAAgEF/f34BQIK9wQJ+wsGAAj///wFAQEN+/r7CAUH+gj++gAFDf4E+v4MBBD/AQAF+wf9+/8CCQL3//wF+f4D/QIC/fcKCv8B+wD19AD0APj29AUGAwEMA/v9+gD5BQ8C8/kC/Pz7BALw/foG+Qb/AQIH/gYB+wYLAf/3/gUBBgEGAgAG8AMKBwD9CQT+AwH8BQMCAfsL+f4MAf/zBv37CAD9DwD9Awf7EP36CPwF/wf4/fsCDgT/CAIG/QT3BQL9CAQCBQQIAREAAe/4/gr0BPf+Bvz+/v76+fcEAgcCAgL8/wAFBQf8/wf4CPr7CAUC8/f6/vz3+PsD/Pf3/g0J/vj2Df0G9AH2+gL8/gUEAf0G+wAL/fsF+Q/6BP3zDgUG9voG"
---

For one, the speed penalty of using requestAction is quite prohibitive. The main slowdown is that every time you call requestAction, a full dispatch cycle takes place. This is pretty inefficient given that you probably already know what exact Controller/action you want to call up. A much bigger reason is that you will create a debugging nightmare for yourself. As soon has you have requestAction calls that invoke requestAction calls that invoke requestAction calls - you're screwed. If somewhere along the chain odd things happen (like a bug in your Auth system, some controller's / component's beforeFilter) debugging is going to become a major pain.
