---
title: 'The 48 hour mobile web app: Drunken Stumble'
date: '2011-03-02'
tags:
- Drupal
- intoxication
- navigation
- portfolio
- project-management
- webdesign
wp:post_type: post
redirect_from:
- 2011/03/the-48-hour-mobile-web-app-drunken-stumble/
- "?p=2501"
---

[ ![](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/drunkenlogo-500x190.png "drunkenlogo") ](http://drunkenstumble.com)



Last weekend I participated in the [Boston Hack Day Challenge](http://beta.boston.com/hackday), a 48 hour (so I'm not sure why they called it a hack _day_) competition sponsored by the Boston Globe and held in the MassChallenge workspace. The goal of the event was to develop tools that would improve the lives of Bostonians. My team won "Best Mobile App" as well as the "Crowd Favorite" award for the pub crawl app we built: [Drunken Stumble](http://drunkenstumble.com).

_**Update:** You can also read about the process from some of my teammates: [@nikibrown on the design](http://www.nikibrown.com/designoblog/2011/02/28/designing-and-building-a-web-app-in-a-weekend-drunken-stumble/), [@unruthless on frontend and whip-cracking](http://www.unruthless.com/blog/post/drunken-stumble), and [@mikemiles86 on the backend](http://miles-per-hour.com/2011/03/01/drunken-stumble-a-drupal-7-web-app-built-in-a-weekend/) and [interface](http://miles-per-hour.com/2011/03/02/drunken-stumble-a-breakdown/)._

(And if you're wondering how a pub crawl app would improve the lives of Bostonians, you must not be from Boston.)

## About the Project

Our team formed Friday night. On the frontend we had [@nikibrown](http://twitter.com/nikibrown) (designer) and [@unruthless](http://twitter.com/unruthless) (frontend developer)---who knew each other prior to the event. On the backend we had [@mikemiles86](http://twitter.com/mikemiles86) (application developer) and [myself](http://twitter.com/bensheldon) (API and interface developer)---who happened to be standing near the cheese table.

Together---and with the muse of the open bar---we came up with the idea of creating an application that would help people perform a pub crawl. While other teams proposed concept demos and APIs, we set our goal to be the delivery of a complete product by the end of the weekend. Defining a minimum viable product meant keeping a lot of great ideas in the parking lot (like drink lists and multi-user crawls) but helped us focus on delivering a tight, attractive and functional pub-crawl application that lets you:

- use your smartphone to find nearby pubs

- get walking directions to that pub

- invite your friends to the pub via social media (Twitter and Facebook)

- find the next pub for your crawl and get directions to there from your current pub

- track your nightly progress (or revisit it the next morning)

- call a cab home at the end of the night

## About the App

We built Drunken Stumble as an HTML5 mobile web application---testing it on both iPhone and Android. As an HTML5 mobile web app, we can access smartphone features (like GPS and Portrait/Landscape modes) as well as quickly write, test and deploy. Both @mikemiles86 and myself are Drupal/PHP developers so (with some reservations) we decided to use Drupal as a framework---using its paths, forms, database and template systems and nothing else.

![Planning documents](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/drunken-planning.jpeg "drunken planning")

I focused most of my development on interfacing with external APIs. Originally we planned on using Yelp to provide business data for locating pubs, but their API is extremely limited with only 100 lookups per day. Fortunately, we found an awesome service called [SimpleGeo](http://simplegeo.com) that currently offers unlimited lookups for businesses based upon location. Using SimpleGeo we were able to quickly write a rich, location-aware application that works anywhere in the United States, not just in Boston.

Once we knew we had a source for business data, the next step was telling the application where you are. HTML5 offers [native geolocation](http://dev.w3.org/geo/api/spec-source.html) which means we can (politely) request exact location data based on your smartphone's GPS. If your smartphone doesn't have GPS (or it's turned off) you can type in an address and we use [Google Maps to geocode](http://code.google.com/apis/maps/documentation/geocoding/) it into a latitude/longitude. If you do use your GPS, we also do a reverse geocode (again using Google Maps) to show you your street-level address to confirm that's actually where you are (" [42.331528,-70.94425](http://maps.google.com/maps?ll=42.331528,-70.94425)" could be in the middle of Boston Harbor for all I know).

[Google Directions](http://code.google.com/apis/maps/documentation/directions/) is the special sauce that ties it all together. We provide your starting location and the location of your next pub and Google Directions provides walking instructions and waypoints along the way. We display the walking directions and overlay the waypoints on top of a (static) Google Map. Unfortunately, Google Direction's API also has a rather low limit of lookups (2,500/day), so should we go over our limit (as we did about 2am Sunday morning), we alternatively display a link that will launch your smartphone's native maps app (or push you to Google Maps directly) to get directions there.

There was one last benefit of using SimpleGeo's well-populated business database: our app's design isn't limited to just pubs. For example, we decided rather late in the process to offer a list of local taxicab phone numbers at the end of the pub crawl. Because we had already tapped into the SimpleGeo API, we just needed to filter nearby businesses for "taxis", rather than "bars & pubs". Which is an important thing to keep in mind: with a few minor changes, our app can facilitate routing for any type of business or geographically based event---like a taco crawl or artists' open studios.

[ ![](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/Drunken-Stumble-Screens-500x315.png "Drunken Stumble Screens") ](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/Drunken-Stumble-Screens.png)

## About the process

The process was awesome. We got down to business about 8:00pm on Friday night and went live at 1:45pm on Sunday. Sure, we missed deadlines, our final feature list shrunk (and the parking lot grew), the architecture is far from "robust", and the final design didn't match our initial sketches (it was better!), but we met our goal of delivering a complete and functional product.

I think it was our focus on "completeness" that helped us win more awards than any other team (2 awards). Other than a few all-hands decisions, our small and diverse team focused separately on our individual areas and integrated as necessary---@mikemiles86 and I used Git to sync progress on the backend, while I think the frontend mostly looked over each other's shoulders. For me that meant moving from API wrangling at the start of the project to templating at the end. I also can't overstate the value of @mikemiles86 pulling an all nighter on Saturday (the rest of us ejected at 3am for about 4 hours of sleep)

The Crowd Favorite award was not only a function of our easy-to-understand concept, but also the stellar work of our frontend team. @nikibrown quickly produced strong branding and interface mockups that were key to creating early buzz: as other teams walked around and mingled, we could easily show off our idea. @unruthless became our de facto project manager and spokeswomen, explaining the app to visitors and pushing progress updates to Twitter and the #bostonhack hashtag for the event. We also lived our values, bringing in a wide selection of beer to carry us through Saturday and Sunday (and sharing it didn't hurt our chances of winning the Crowd-Favorite award either).

## About the future

It's only been a few days since the event but we've kept up a steady stream of chatter over Twitter and pushed a few minor updates to the server too. The intensive hack model worked really well for building a minimally viable product, but time will tell whether we can keep the momentum and updates coming---turning Drunken Stumble into a maximally functional application.

In the meantime though, [happy stumbling](http://drunkenstumble.com), sober or otherwise.

[ ![](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/team-stumble-500x331.png "team stumble") ](/uploads/2011-03-02-The-48-hour-mobile-web-app-Drunken-Stumble/team-stumble.png)
