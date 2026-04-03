---
title: Boston Bike Crash Map
date: '2010-11-23'
tags:
- bicycles
- Boston
- mapping
- maps
- navigation
- portfolio
- project
wp:post_type: post
redirect_from:
- 2010/11/boston-bike-crash-map/
- "?p=2305"
---

[ ![](/uploads/2010-11-23-Boston-Bike-Crash-Map/bcu-crashmap.png "bcu-crashmap") ](/uploads/2010-11-23-Boston-Bike-Crash-Map/bcu-crashmap.png)

Today the Boston Cyclist's Union (BCU) launched their [interactive Boston bike Crash Map](http://bostoncyclistsunion.org/resources/crash-map/), a mapping tool that I've been working on with them to help share and analyze bicycle crash data. They did all the hard work of getting the Boston Emergency Medical Services and Police Department to properly code and release the data---I just helped them clean it, geocode it and put it on a map.

It is an exciting project both because the data is compelling for bike safety and livable streets advocacy, and it required some novel/cludgy engineering. We wanted to create a system that would allow the BCU to access and update the data behind the map, but because of their technical capacity, I couldn't overly format the data or create a CMS database. The solution: Google Spreadsheets. All of the data is stored in a shared Google Spreadsheet that is [automatically fed to the map ](http://gmaps-samples.googlecode.com/svn/trunk/spreadsheetsmapwizard/makecustommap.htm)on BCU's website. Google Spreadsheets can even [geocode the addresses](http://apitricks.blogspot.com/2008/10/geocoding-by-google-spreadsheets.html). I had to mess about with the javascript code a bit---aggregating multiple overlapping incidents at the same location into a single marker was all me---but overall it was a fun project.

> Back in March and April of this year we asked Boston Emergency Medical Services (EMS) and the Boston Police Department (BPD) to separate bike and pedestrian crash data to allow us to see where bike crashes are happening. And to theircredit, each department quickly recognized the need and worked with us to meet it, partly by adding bicycle checkboxes to their incident report forms.
>
> Now, not only do we have over six months of data to look at (May thru October 2010), but  it's all plugged into an  [interactive Google map](http://r20.rs6.net/tn.jsp?llr=wpangcdab&et=1103945671173&s=339&e=001wIWbcramWbVCUaA2ne6YH-bCGRpo6WHNa5-ujQcQjMJ7tyjo8dy_VmeXKB8mzWxuGypUF3glNTGPnb_M5N4xUAC7NV2tGaMRYMXifmMlpFxQhX-7doYuKX2VFTcai94WuRhF8Yb7w0MwHz08kAhhONNLvoPuosDn)created by Union member and volunteer Ben Sheldon. Thanks Ben! It will still be a year or two before we can have a large enough sample size to discern reoccurring patterns at particular intersections, but this first six-month glimpse of the data does give a sense of where crashes are happening in the city and a few other interesting things.

**Update: **The map has been mentioned on [WBUR](http://www.wbur.org/2010/11/29/bike-crash-map) and [UniversalHub](http://www.universalhub.com/2010/thats-lot-crashes). I've been told that after releasing the map, there has been a big uptick in BCU memberships and request for info too.
