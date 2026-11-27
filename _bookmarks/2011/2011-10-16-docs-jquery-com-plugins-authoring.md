---
link: http://docs.jquery.com/Plugins/Authoring
date: 2011-10-16 14:21 UTC
published: true
title: Plugins/Authoring - jQuery JavaScript Library
tags:
- javascript
- webdevelopment
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "8830fccce86bf2eb"
  vector: "/f8FC/7+AP8A+/0O9gAMBf7/+P0C+Pr6+/oEAvsABAP39fkF+gb/AwIIBPz8A/j2/gUOAf36CPTzAgQH9gUACfkH/gLyDvwE//8F/O39AfwI9wAEBwb//woE/fgF//IH/PP2AfwBBvwG+/T+BgcFBwX1BQsJAQoDBgsB/wUH/AAB+wQK//wBBuwABQv6BgEEAwkH+vgIAQf9+wYD9PwD//sN/QD5/wEDBPn4AgMEBv0E//gJAAMHAPoBA/wG+/oJAf/6BP/9AAH8+/z9/AcFBP4E/AQM+/0BAAP9Avf8/AD/9gMSBAD3Agj9/wEL9QIC6voG9/38Cv4E//UCCQHwBfsABQj/CQME+gD5AwT6+/gG+PP1BgkD+QX9CgME/AD59ggE+//9APIF9vz9CPj+AQH3Av7//v0JBAT/D/z+8AD5/v3zAPcGDPz7EAYQBfkB/AkADf8A/vkEAPsD/gL6BP8E+AH8+PkAAvLzAv7/CAH6A/sJBwQFBQMC/QL4AQMG"
---

For more complex and customizable plugins that provide many options, it's a best practice to have default settings that can get extended (using $.extend) when the plugin is invoked. So instead of calling a plugin with a large number of arguments, you can call it with one argument which is an object literal of the settings you would like to override. Here's how you do it.
