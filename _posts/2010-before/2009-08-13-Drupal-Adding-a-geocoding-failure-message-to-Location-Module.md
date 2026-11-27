---
title: 'Drupal: Adding a geocoding failure message to Location Module'
date: '2009-08-13'
tags:
- Drupal
- location
- mapping
- maps
- navigation
- portfolio
- stupid
- warning
wp:post_type: post
redirect_from:
- 2009/08/drupal-adding-a-geocoding-failure-message/
- "?p=676"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "26b2fe4ad5f36d1a"
  vector: "A/sEAgP9/vL99/4ABf78AAQDBf//AgUKAvv/CgABAQD/BgwJ/gQDAQL2BQIC+wUDAfgE+AD5/gP2B/0AAQAG/wEH+Pz/AwQF8Ar+BO75/wgF/gIE//wCBQT6Bv0ACgD9+AABAwb99fkP9gAH/Ar+Bf798AoGCPsC+/T8+gH4EAABBwMI/AL2/v3/CAAJ//8ECAMEAQP5//wDEfUI/wD9/QQFCf/6+ff8AwHuBQgA/QIHAwAK8gD+Av/6CgUCAf7/CfL8/vn7Bv0DDvP4+QP9/Qn1/wgG/QAC9g8D//f9AAD/+Pb69fcKBgUB8vkGC/ID+QT7DAIC9gL8BAUD+gD9CP8BBQAFCwgRAQr1+AH9AQb6BP//AQcJBfv7CgD69AIGBv8D/A8BCv739wYGBA37+v8D+QQFCQQF+QX9DfEA8QD2//cFBQIN9gD7Avv89wL7/P34CQIKBQAD+AgHAPsC+/sB9AYF9/0E//v4/AIFBvsC/vP/9QYGAP74Agb1Bf79"
---

One of the coolest pieces of Drupal is how simple it is to quickly enter a street address and have it show up on a dynamic map on your website using [Location](http://drupal.org/project/location) and [GMap](http://drupal.org/project/gmap) modules. To make it happen, a lot of stuff goes on behind the scenes. Unfortunately, in typical Drupal fashion, when something goes wrong, you aren't provided much information to fix it.

A big issue if you're having regular users enter information into your website is _malformed_ addresses that can't be automatically converted into latitude/longitude coordinates (geocoding) for display on a map. Out of the box, the Location module doesn't give you a warning if it's unable to geocode an address. On my website [MappingAccess.org](http://mappingaccess.org)--a community maintained directory of Cable Access Television stations---I average about an email a week from a visitor saying "I added my station but it's not showing up on the map". Usually it's a simple matter of using a PO Box or wacky abbreviation, but the website itself should be telling them there is a problem, not me.

So I whipped up a simple module that checks everytime a new station is submitted to see if the address was properly geocoded. If not, it displays a message with some tips on how to correct the issue.

![Geocode Warning Message](/uploads/2009-08-13-Drupal-Adding-a-geocoding-failure-message-to-Location-Module/Picture-3-500x136.png "Geocode Warning Message")

You can download the module for Drupal 6.x by [**clicking here**](/uploads/2009-08-13-Drupal-Adding-a-geocoding-failure-message-to-Location-Module/geocode_warn.zip)**.**

To be nitpicky, I'd rather the message show up during the validation stage---before the node is submitted---with the option to say "Please edit the address or press submit again to publish with the understanding that it will not show up on the map." Unfortunately, in Drupal 6 you [can't make changes to node form during the validation stage](http://drupal.org/node/241364)---which I would use to set a flag in a hidden form element so that the validation message only gets triggered once. The current implementation calls a drupal\_set\_message in hook\_nodeapi's insert/update operations. It can be enabled on a per-content-type basis (on the Content Type Configuration screen).
