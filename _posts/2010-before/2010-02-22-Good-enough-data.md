---
title: Good enough data
date: '2010-02-22'
tags:
- ability
- data
- navigation
- parsing
- portfolio
- yawn
wp:post_type: post
redirect_from:
- 2010/02/good-enough-data/
- "?p=1776"
---

![](/uploads/2010-02-22-Good-enough-data/btop-map-combined-500x462.png "btop-map-combined")

I've been spending some time at work scraping data. Long story short: government transparency is not transparent when the only access they give you is a pile of poorly structured html. That's better than government opacity but not past the level of frosted glass: titillating but unsatisfying. If your expected audience is pencil pushers, please release your data in a spreadsheet. [That's what I did](http://transmissionproject.org/current/2009/11/ntia-broadband-access-data).

Notes for nerds:

**Regular Expressions vs. Parsing Engines: **I wrote a the first parser in Python with Regular Expressions, then rewrote it in BeautifulSoup (a Python parser). It took me about 2 hours to write it the first time with RegExp. It took me about 2 days to do it with BeautifulSoup. It's slightly easier to maintain now, but you tell me which one is more semantically correct:

`project_title = re.search('<tr><td><b>Project&nbsp;title</b></td><td>(.+)</td></tr>', line)`

versus

`project_title = app.find(text="Project&nbsp;title").parent.parent.nextSibling.string`

Yep, it's written in 2-column tables with each row being a different data-set: the first column holds a key (if there is a key; sometimes there isn't) and the second column being the data . With RegExp, I know exactly what I'm looking for. With the parser, I have to find the element in the tree, then traverse up, over and down (if there isn't a key, I have to go up, up, over, over, over, down, over, down). The data itself is a big set of applications (about 2000+ total) and each application has about 15 different data-sets (some with keys, some just follow a consistent-ish pattern).

Fortunately, I have an [appreciative audience](http://www.media-democracy.net/) for my troubles and it lets me [draw pretty maps](http://transmissionproject.org/current/2010/2/btop-applications-and-awards-by-state) like the ones above. Also  [done with Python](http://flowingdata.com/2009/11/12/how-to-make-a-us-county-thematic-map-using-free-tools/) by parsing an SVG vector image.

**Michigan boaters beware**: there is now an isthmus between Mackinaw City and St. Ignace. Rather than rewrite the process for grouped-shapes---Michigan being in 2 parts---it was good enough to make Michigan 1. Hawaii somehow endured.
