---
title: Hard data on the status of Open311
date: '2012-07-27'
tags:
- analytics
- data
- navigation
- portfolio
wp:post_type: post
redirect_from:
- 2012/07/hard-data-on-the-status-of-open311/
- "?p=3012"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "54d83b72403f2d41"
  vector: "Afn/AwL19P/8BvME//oHARP3BQD4+gEAA//7AP/5Bfj/BgP5A/v1/gn7/gX5+wH+/gEG9PoFCAPzAv8NBfv8BAj7AQAF8QIFBfj+/vQCB/cEAPUHAAQDBgX8Bwn9/v/9AwT/B/wDBwMA+AMD+xEA+Qf5+/7/+gUCAPwC8wYLAQAB/voIAgIEAv/6AwsI/gsGBQYF/wHw/gMH/f0JBwIGBPcIBwEC+fv57Ab1Af/8//8F/QcD+QgDAwf1/gv7+f74BP8ADQUFBP77/f8E//v/+An7AAsC/wD6+Aj7AP8F/AD4/voF+f38/wgB+f0LAvv1+//9Bf0F7vf9CvP7APv9//v//wwJAgQDBvr2+f0H9gjz+v8E+gsD/wb9/QcOBf4LA/cK//oF+fv1/AACAwL5Cv0IAAIPAQ/9Aw32CusP/QD7/foF/wL7CgMLBwD5AgQKBPbzA/8HBvoF9P8O+gD8Agf8Awn8CQIECQH2AAb89vr//fUA/gIGAPj9BQ8E/foD"
---

![](/uploads/2012-07/open311status.herokuapp-2-600x369.png "open311status.herokuapp-2")

With the recent announcement of [311 Labs](http://codeforamerica.org/2012/07/12/hello-311-labs/) and Code for America's recent [podcast featuring me](http://codeforamerica.org/2012/07/23/open311-reality-check-how-usable-is-the-api-for-developers/) talking about my perspective on Open311, this write-up about [Open311Status](http://open311status.herokuapp.com) is probably long overdue.

[Open311Status](http://open311status.herokuapp.com)---still a work in progress--polls Open311 servers in 30 cities and aggregates configuration, performance and utilization statistics about those Open311 endpoints. I built Open311Status for two reasons: first, to provide a high-level view of how different endpoints are performing as a developer sanity check ("is my app broken or the server?"); and second, to provide some hard data to the anecdotes and experiences I've used in [advising the City of Chicago](http://codeforamerica.org/2012-partners/chicago/) and others in how to improve Open311's potential for positive impact in their cities and beyond.

In designing Open311Status I took advantage of the huge benefit of the Open311: interoperability. By adopting the Open311 API for exposing civic data, cities are enabling civic developers like myself to build reusable tools and apps. To access data from 30 cities, Open311Status doesn't need an adapter for each individual city, [only a server URL](https://github.com/codeforamerica/open311status/blob/master/lib/endpoints.json) that it can expect to interact and deliver data in the same way as described by the [Open311 API documentation](http://wiki.open311.org/GeoReport_v2). Sure, there are some minor interoperability issues (for example, [Toronto doesn't like datetimes submitted with milliseconds](http://tracker.open311.org/ticket/95)), but these have been minor speed bumps for development, not major deal breakers.

A major limiting factor in the utility of Open311 isn't these minor technical issues, but in how the Open311 servers are configured. If Open311 is supposed to provide a rich API for developers to interact with there should be a broad number of categories ("types") of requests that can be submitted, as well as a comprehensive listing of previously submitted requests that can be analyzed or dashboarded. Compare the Boston and Washington, D.C. Open311 implementations: Washington, D.C. currently provides 83 categories of service requests (from "Tree Inspection" to "Roadway Marking Maintenance") while Boston only provides six. Washington, D.C. provides access to all requests regardless of whether they were entered via Open311, the 311 call center, or city work crews or departments; Boston only displays service requests made via the Open311 API. These configuration decisions have a huge impact on the comprehensiveness of the data and thus the potential applications third party developers can build on top of the Open311.

If server configuration determines the potential for an innovative application, server performance determines whether such an app will be useable. Because a potential Open311 application will be heavily reliant upon a city's Open311 server, the speed and robustness of that server will determine the responsiveness of the application. At the obvious extreme, if the server goes down, that app will probably be useless. If the server is functioning yet takes several seconds to respond to every request, the application and its users will experience significant slow-downs and frustration. As I've witnessed through Open311Status, usually about 10 percent of the servers take longer than one second to respond at any given time. That's not a stable infrastructure for third party developers to build upon.

Open311Status helps measure the distance between the potential of Open311 and the current reality. It's cause to celebrate that here are 30 cities (and more to add to Open311Status) who have adopted both open data and open standards; this is hugely important progress! But there is still a lot of work to be done beyond the specification for Open311 to enable a rich and robust third party application developer ecosystem.

Some technical details: [Open311Status](http://open311status.herokuapp.com) is built on [Node.js](http://nodejs.org/) with the [Express](http://expressjs.com/) web framework and aggregates data in [MongoDB](http://www.mongodb.org/) through the [Mongoose](http://mongoosejs.com/) ORM. The application is single process and uses cron and async modules to poll the cities' Open311 servers every five minutes. A fun/dumb feature is that individual service requests are streamed to the browser using [Socket.io](http://socket.io/), but because many servers publish service requests an hour (or more!) after they've been submitted, Open311Status streams the previous day's service requests in "real time" as if they were today's (or rather, "real time minus one day"). Tests are done with [Mocha](http://visionmedia.github.com/mocha/) in BDD style with [Should](https://github.com/visionmedia/should.js) using [Sinon](http://sinonjs.org/) for mocks and stubs (though coverage could--always--be better). Open311Status is hosted on [Heroku](http://www.heroku.com/).

_This post is cross-posted from the [Code for America blog](http://codeforamerica.org/2012/07/27/hard-data-on-the-status-of-open311/)._
