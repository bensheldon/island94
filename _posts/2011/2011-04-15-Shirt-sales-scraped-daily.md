---
title: Shirt sales, scraped daily
date: '2011-04-15'
tags:
- consumerism
- navigation
- portfolio
- scraping
- webdesign
wp:post_type: post
redirect_from:
- 2011/04/shirt-sales-scraped-daily/
- "?p=2629"
---

[![](/uploads/2011-04/daily-t-shirt-sales-600x397.png "daily t-shirt sales") ](http://dayoftheshirt.com)

I am remiss to finally get around to blogging [Day of the Shirt](http://dayoftheshirt.com), which I launched back in October, 2010. It's a straightforward and (hopefully) aesthetically-pleasing t-shirt aggregator.

What's nifty about Day of the Shirt is that it's built entirely with  [PHP Simple HTML DOM Parser](http://simplehtmldom.sourceforge.net/). And when I say entirely, I mean _entirely_: there is no database backend, everything is scraped, including itself. Day of the Shirt...

1. scrapes t-shirt vendors to get names, links and thumbnails (which are cropped and cached);

2. scrapes, parses and rewrites its own DOM when new shirts are added (we're serving completely static html);

3. and scrapes itself to compose its [daily tweets](http://twitter.com/dayoftheshirt).

That last step is a little extravagant, but I wanted to separate the early-morning website update from the mid-morning tweeting---otherwise only the early birds would ever see the tweet. Of course, I re-used the [tweet-composing algorithm](http://www.island94.org/2010/08/p-np-and-panlexicon/) from [Panlexicon](http://panlexicon.com).

Now the unfortunate part of this project was that I did a fair amount of competition research prior to building this website---but it wasn't until about a week after I launched that I discovered an equivalent service: [Tee Magnet](http://www.teemagnet.com/). _C'est la vie._
