---
title: Drupal WYSIWYG Editors
date: '2007-09-08'
tags:
- Drupal
- geeking
- modules
wp:post_type: post
redirect_from:
- drupal-wysiwyg-editors
- node/152
- 2007/09/drupal-wysiwyg-editors/
- "?p=152"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "f0a473c816b708dd"
  vector: "9AQKDgj88v8IBvsGAAYDCAQE+wH6BAED/gD+BP7++/QFAwAQBwf99/32AQUG9fv8/f/4+foIAv36+wX5+QwKAQkH/wcIAfj7+Az8+vUAAQQF/QIDAAQA9wgCB/8N+fz+A/b5AP/2AQED/gwA+PwB//X0AQIG/wwFAgD2/wAIBAAWBwAFCQD19vP6B/b7CBD1+gUGBPEFBQD9BQj/+v/39QT88Qfv9wv39/8A+gAL/gL/+AYCAAIB/wr7CAYFBf8DAQMBBv/9//wABwX+BvMG/Qb+Af0D9/z8AQD/Agb/+QABAP8H+wr3AxH9BwL+/PsHAvsF+gn1/wT9AfkF//n7/wX6BgH7Cgf9Cf4HAfj/9QH7BPgE9Pz3+foI+wTzAvsIA/4DAff9DvoF/AL6CQL//wgI//r9BP8FAAL6BwsG+wAB9fz++P7//v35DP7z+/cF8AkA/QML+AICCv79/fwGAwAL9gH1/vsD/QUA/wP/Avv++wMBCvYAAwwOBv0FBAkG"
---

I'm partial to the following WYSIWYG editors for Drupal:

- [WidgEditor](http://drupal.org/project/widgeditor) - stupid simple
- [TinyMCE](http://drupal.org/project/tinymce) - way complicated powerful

_But_ neither of them work well enough for me to want to use them. The trade-off for using these is that it's easy to make pretty text, but if you ever need to manually edit, it's incredibly painful. The biggest problem is that they don't make new lines for paragraph breaks, smashing everything together into one huge, ugly block. And since Drupal has a nice, built-in filter for creating paragraph elements, it's redundant (and infuriating).

The only markup you need is bold, emphasis, links, pictures and a way to turn it off. Wordpress seems to get it.
