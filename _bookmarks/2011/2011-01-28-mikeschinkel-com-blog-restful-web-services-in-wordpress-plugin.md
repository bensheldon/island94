---
link: http://mikeschinkel.com/blog/restful-web-services-in-wordpress-plugin/
date: 2011-01-28 22:26 UTC
published: true
title: RESTful Web Services in a WordPress Plugin? | MikeSchinkel.com
tags:
- wordpress
- plugin
- php
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "c68ea38c0c00ebe7"
  vector: "9wMC/PcC+AEC/wAIAw4NBAsD/wIPCv3++wMA/v/7Cfn6+gcECvX+CwH9+wD8+QP28vwA+vYDAvfwAPz8AfYI/fgD+AX++vb6/QT9/gv5+PQN/wMOAgb7+AQA//kD8gUJ/PH8/wX/B/gE+v4Z/AgBAPn99/sE/fwKAgb/CQQCCwAFAwYF/ff+/wUH+wEBAPoB/wYF/P0NBfsB/AT8/fkG/AcGBQgG/fQD/wf9BQL++vkB9/wECgIDAPoB+QD/9f/zAfv+Bf37BgMABAICBP4O/Q74AwQEAf/1B/0BBvz+AgAE/foOAgcCBwkLBwH9+PsB8PoFBvgFBfcCCvoD+AQI/Qb2/gMAFQf8APf/B//y//0E/PkD9wP8+fL/9QAD/v0HBPEA8PX5//oF+w71BfkFAv7+/gIG+QQG/gAAAf8H/wD9/fUK9QMIAAICBAT5/vwDBQL/BPoE/vkOC/cGAAEB+/0B9Ab6/vv+Bgf6Ag0CCwEAA//5CvcEAwIDBQ0AAAb6"
---

Here’s the details.  I started writing a plug-in called “RESTful Services” with a goal of implementing URLs that behave in the following fashion; {format} could potentially be html, xhtml, json, xml, rss, atom, etc.:

http://example.com/services.{format}
Provide a list of RESTful services in specified {format}, defaults to html
http://example.com/services/{service}.{format}/{data}?{params} 
Provide a RESTful service in specified {format}, defaults to html, with optional provided data and parameters.
But before I got all those options working I just wanted to service a page from my RESTful Services plugin where Content-Type: text/plain. I found this page that professes to explain how to hook into the URL routing and after a few fits and starts I can came up with the following code for my plugin that would indeed response to my http://example.com/services URL:
