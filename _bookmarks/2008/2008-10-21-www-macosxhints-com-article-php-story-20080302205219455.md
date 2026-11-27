---
link: http://www.macosxhints.com/article.php?story=20080302205219455
date: 2008-10-21 15:22 UTC
published: true
title: macosxhints.com - Fix an issue with the Firefox download folder location
tags:
- web
- osx
- howto
- firefox
- mac
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2ae1bdf84f0429d4"
  vector: "Bfj++ggABf78+Qf/AQgGBPv9/gj/9wkDAvv6CP0GAv/39wkFAwUDAQMGAwb5BA39AAcCBfr+BQ8LAf4EAvv9BvoF/vr2/QEK7gkA+QQK9wEF/gMC/Qb8+f8FBAQOAAX3Bw0C/AD9BAMD/wgA+/4F/Pz/APzuAPcBAgAKAgkF+QD2Bv4CA/gEAfz+Af75+Qn/A/4HBwcFB/34A/kI///09wkB/wIM/Pz/+Pn+AwP5//wIDfT5Bfz5APz6/PwPCAT2C/4C+gIE9wQBAQrz+AYC/gn5/P76BAMG+wkJAAAE/gAB8wUE+AgGAf78/AcF8/gA+fgA9AcF9wL7/QAAA/sC+/z5AgT5C/4G+/YM9gkJ+P0EBQ8HBAMFBAH2B/f8+P0G/v38CgIK//4C9P/0AAT/BgYQ/gH69wn+/vYEBP3y+QD1A/UHDP//+QsE+w79BfH2/QMJ/fv4BQAB/v8ADATp/PQB/vz2C/r9BPwG//YBAQgL/wb+AAf9+fz6AQEJDAEA"
---

Fix an issue with the Firefox download folder location
Mon, Mar 10 2008 at 7:30AM PDT • Submitted by fyngyrz Web Browsers
If you migrate from a previous machine to a new machine using Apple's Migration Assistant, and in the process you create a new user -- this can happen if you create your old user account on the new machine prior to migrating -- you may have issues with Firefox and the Downloads folder. Because of a shortcoming in the migration tool, the OS X Downloads folder for the new account will have the path for the old account, and Firefox will then be unable to save because it does not have the correct permissions. I encountered this issue with 10.5 Leopard (both machines), migrating from an old Mac mini to new Mac pro.

The solution is to open ~/Library » Preferences » com.apple.internetconfig.plist with the Property List Editor (Xcode required), navigate to the Download Folder item, and delete the value (not the key; just the value under it), then save the property list fi
