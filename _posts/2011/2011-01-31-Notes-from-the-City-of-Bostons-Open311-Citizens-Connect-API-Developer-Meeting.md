---
title: Notes from the City of Boston's Open311 / Citizens Connect API Developer Meeting
date: '2011-01-31'
tags:
- Boston
- data
- govdata
- government
- meeting
wp:post_type: post
redirect_from:
- 2011/01/notes-from-the-city-of-bostons-open311-developer-meeting/
- "?p=2463"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "48cd41fa461816cd"
  vector: "AvMB+wj7+AD7Bv8D+/YABA7yAgf9AvwFBwX/AgACBgUHDAb7Bv38/QL3AAf8/AMA/f8D+QEC/AX7CgEK//r4BQEC9f4J6wgDBf0IBPYLCPQL+/kNAgIBDgYDBQkC/fn+/AX+CfcL/gH/+wb+BgsK+AL6AAD5BwUA/QH+7f8G+wADBvgDAvz7BAT8AQoD/gsC+P78A/7x/v8DAAAEEgL7C/8HCQf79QD+7gL5AP/+/f4JAAoC9f78+//4BAH/BAUH/AEAAAn/AwMC/vsBAgP9/Qr4BQgHAf/+/Ar5+/kH+wD5+vv89/v/+g0G9f8KAwT2Af75/gQG7/4AAvwBAvn//fUD+w0KAwD+BPj3+P0D9Qnz9wML9gX+Bgv4AP4IAfsFAfwM/voMAvb6AAMK+QLxAgP+BAIRAgv7/Q30AvQH+QD+AfsDA/z8CgQGAvzuCAIJAPj0BgAA+/4F+fsU/QH+AwX7//8FAQcAAvz3Awb99/gG/vz8+wYH+gD9AgD+AvsG"
---

Today I attended a developer meeting at Boston City Hall for their [Citizen Connect API](http://www.cityofboston.gov/doit/apps/citizensconnect.asp), a to-be-launched [Open311](http://open311.org/) implementation. The city currently has official [iPhone](http://itunes.apple.com/us/app/boston-citizens-connect/id330894558) and [Android](http://www.androidzoom.com/android_applications/tools/boston-citizens-connect_najk.html) apps that allow community members to submit broken streetlights, potholes, graffiti and snow removal, but the intent of the "open" part is to allow unaffiliated developers to integrate the system into their own applications. The other developers attending were the 7-person Boston [Code for America](http://codeforamerica.org/boston/) crew (who just arrived a few days before), [SeeClickFix](http://www.seeclickfix.com/) and a university researcher (the latter 2 via teleconference).

The City of Boston uses a [Lagan CRM](http://www.lagan.com/) system to create and track tickets and cases. To feed that ticketing system the city offers [constituent services](http://www.cityofboston.gov/mayor/24/) in person, via telephone (the meeting was held next to the call center which had ~10 agents active at the time), via the web, and through the smartphone apps. The Lagan system tracks 150-170 types of tickets, but Boston currently exposes only 6 of them through Open311 API (streetlights, potholes, graffiti, 2 types of snow removal, and other); this decision was explained as being driven by the UI needs of the official smartphone apps. The Open311 system is only a data bridge into the Lagan CRM and thus won't support any additional metadata or external decisioning (this dismissed a Code for America fellow's suggestion of voting on tickets).

The API is not currently available. The city estimates 2 - 3 weeks until they have a test server up, and from there they will evaluate whether to give applications access to the live system. The test server will be a sandbox that is either refreshed every 24 hours, has new data streamed to it, or may simulate workflows (e.g. submit, review, comment, close)---it was still in discussion.

In addition to the Open311 API, the city also offers data dumps of its entire ticketing system, offset by 24 hours. Unfortunately, those data dumps don't include the channel through which they were inputted, e.g. it's not recorded whether the ticket came thru Open311, telephone, web or in person. This is allegedly through the city's [Data Hub](http://hubmaps1.cityofboston.gov/datahub/) / [Data Dashboard](http://www.cityofboston.gov/doit/databoston/app/data.aspx), but I can't find it.

The City of Boston is taking a more deliberate and restrictive approach than [MassDOT/MBTA](http://www.eot.state.ma.us/developers/) in opening up their data, though CRM tickets are clearly different than bus/train route and dispatch data. The university researcher's (Ben Clark) use case for the data was spot-on: determining who is utilizing these smartphone tools, and importantly who isn't. Time will tell how the influence of outside software developers will push the city's implementation---and how will it effect less-technology focused solutions.

I was really excited to meet the Code for America crew as they are bringing a lot of excitement and energy to the gov data scene. I did get the impression that they were unprepared for managing institutional forces: there was a question about why the city couldn't devote more IT resources to the project that were answered with some allusions to Dilbert (without acknowledging that the current capital budget was probably set 14 months ago). Open311 doesn't seem like CfA's [primary focus](http://codeforamerica.org/boston/) in Boston, but if this was their first City of Boston meeting, I think they learned a lot.
