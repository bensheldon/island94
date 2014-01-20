---
title: More thoughts on an interesting thesaurus
date: '2007-08-22'
tags:
- analysis
- language
- mathematics
- panlexicon
- thesaurus
wp:post_id: '139'
link: http://island94.dev/2007/08/more-thoughts-on-an-interesting-thesaurus/
wp:post_type: post
---

My associate, <a href="http://circuitous.org">Rebecca</a>, and I have been starting to think critically about <a href="http://panlexicon.com">Panlexicon.com</a>, the unique, tag-cloud based thesaurus I've written about <a href=http://island94.org/node/128">previously</a>.  We're hoping to put some more time and effort into the project and in the process, learn some more about what's happening with the language and the underlying structure of the thesaurus taxonomy.

<a href="http://www.flickr.com/photos/bensheldon/1178070872/" title="Photo Sharing"><img src="http://farm2.static.flickr.com/1214/1178070872_b43fabb5f9_b.jpg" width="500" alt="Panlexicon.com - Thesaurus Visualization" /></a>

The thesaurus data we're working with is the <a href="http://www.gutenberg.org/etext/3202">Moby Thesaurus</a> from the <a href="http://www.gutenberg.org/">Project Gutenburg</a> library of free electronic texts.  Like many thesauruses, it's structure in an interesting way.  Every word is assigned to one or more groups based on it's general meaning or idea.  Each group has a keyword, also known as a headword, that is a general encapsulation that idea---this is why, for example in Roget's, you must first look up a word in the index to acquire its keywords.  Each group has only one keyword, but a keyword can exist in other groups (but as an ordinary word).<!--break-->

This thesaurus structure allows us to do some easy simplifications and analysis on the data.  For many functions, we can treat the groups as supernodes, performing operations and storing connections upon them in place of the words themselves.  For example, when determining relatedness between words, we only have compare the groups they are a part of; while there are approximately 100,000 words in our database, there are only 30,000 groups, which greatly diminishes the size and complexity of the data set we're working on.

<a href="http://www.flickr.com/photos/bensheldon/1178070558/" title="Photo Sharing"><img src="http://farm2.static.flickr.com/1297/1178070558_757312a092.jpg" width="500" height="495" alt="Panlexicon.com - Correspondence Weighting" /></a>

Currently Panlexicon works by comparing the overlap between groups of words.  When typing in a search term, Panlexicon looks up all of the groups that word is a member of.  It then returns a list of words that are also in those groups.  The weight of each word (or size in our word cloud model) is calculated according to how many groups----of those groups that include the search term---that word is a member of.  A property of this is that no other returned word will have a heavier weight than the search term.  When searching multiple terms, Panlexicon creates a set of groups such that all search terms are a member.  In the case when there exists no groups that contain all the search terms, Panlexicon returns nothing.

Already we're digging into some interesting relations that turn up in the thesaurus data.  For example, one of my favorite linguistic <a href="http://en.wikipedia.org/wiki/Eskimo_words_for_snow">myths</a> is that Eskimos have 50 different words for snow.  The supposed lesson was that eskimos had a different conception of snow than us (the non-Eskimos). I always wondered, "Well, is 50 a lot?"  The largest group in our thesaurus has the keyword <em>cut</em> with 1448 related words or synonyms. This is followed by <em>set</em> (1152), <em>turn</em> (1108), <em>run</em> (1025), and <em>color</em> (1007).  That's quite a bit.

Also, interestingly in our dataset, are the most versatile words.  These words are members of the most groups.  The list shares four out five of the same words as those of the most synonyms, beginning with <em>cut</em>, being a member of 1120 distinct groups.  This is followed by <em>set</em> (928), <em>run</em> (750), <em>turn</em> (715), and <em>check</em> (699).

Right now, we're investigating paths between words. This will allow us to play the Kevin Bacon game, making connections between words that may not share the same group.  It will be interesting to determine what words are connected (even through a medium) and which ones are disconnected.  Lastly on our list of things to do is determine the eigenvectors of our groups in relation to how their connected to other groups.  This will allow us to determine---without using fancy words like Markov chains---which words are probably <em>used</em> the most.  I say probably because we're analyzing a taxonomic work, rather than actual speech.  Who knows if they match up; we'll find out.
