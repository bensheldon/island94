---
title: More thoughts on an interesting thesaurus
date: '2007-08-22'
tags:
- analysis
- language
- mathematics
- panlexicon
- thesaurus
wp:post_type: post
redirect_from:
- node/139
- articles/more-thoughts-interesting-thesaurus
- articles/some-more-thoughts-interesting-thesaurus
- 2007/08/more-thoughts-on-an-interesting-thesaurus/
- "?p=139"
---

My associate, [Rebecca](http://circuitous.org), and I have been starting to think critically about [Panlexicon.com](http://panlexicon.com), the unique, tag-cloud based thesaurus I've written about [previously](http://island94.org/node/128). We're hoping to put some more time and effort into the project and in the process, learn some more about what's happening with the language and the underlying structure of the thesaurus taxonomy.

![Panlexicon.com - Thesaurus Visualization](/uploads/2007/more-thoughts-on-an-interesting-thesaurus-1.jpg)

The thesaurus data we're working with is the [Moby Thesaurus](http://www.gutenberg.org/etext/3202) from the [Project Gutenburg](http://www.gutenberg.org/) library of free electronic texts. Like many thesauruses, it's structure in an interesting way. Every word is assigned to one or more groups based on it's general meaning or idea. Each group has a keyword, also known as a headword, that is a general encapsulation that idea---this is why, for example in Roget's, you must first look up a word in the index to acquire its keywords. Each group has only one keyword, but a keyword can exist in other groups (but as an ordinary word).

This thesaurus structure allows us to do some easy simplifications and analysis on the data. For many functions, we can treat the groups as supernodes, performing operations and storing connections upon them in place of the words themselves. For example, when determining relatedness between words, we only have compare the groups they are a part of; while there are approximately 100,000 words in our database, there are only 30,000 groups, which greatly diminishes the size and complexity of the data set we're working on.

![Panlexicon.com - Correspondence Weighting](/uploads/2007/more-thoughts-on-an-interesting-thesaurus-2.jpg)

Currently Panlexicon works by comparing the overlap between groups of words. When typing in a search term, Panlexicon looks up all of the groups that word is a member of. It then returns a list of words that are also in those groups. The weight of each word (or size in our word cloud model) is calculated according to how many groups----of those groups that include the search term---that word is a member of. A property of this is that no other returned word will have a heavier weight than the search term. When searching multiple terms, Panlexicon creates a set of groups such that all search terms are a member. In the case when there exists no groups that contain all the search terms, Panlexicon returns nothing.

Already we're digging into some interesting relations that turn up in the thesaurus data. For example, one of my favorite linguistic [myths](http://en.wikipedia.org/wiki/Eskimo_words_for_snow) is that Eskimos have 50 different words for snow. The supposed lesson was that eskimos had a different conception of snow than us (the non-Eskimos). I always wondered, "Well, is 50 a lot?" The largest group in our thesaurus has the keyword _cut_ with 1448 related words or synonyms. This is followed by _set_ (1152), _turn_ (1108), _run_ (1025), and _color_ (1007). That's quite a bit.

Also, interestingly in our dataset, are the most versatile words. These words are members of the most groups. The list shares four out five of the same words as those of the most synonyms, beginning with _cut_, being a member of 1120 distinct groups. This is followed by _set_ (928), _run_ (750), _turn_ (715), and _check_ (699).

Right now, we're investigating paths between words. This will allow us to play the Kevin Bacon game, making connections between words that may not share the same group. It will be interesting to determine what words are connected (even through a medium) and which ones are disconnected. Lastly on our list of things to do is determine the eigenvectors of our groups in relation to how their connected to other groups. This will allow us to determine---without using fancy words like Markov chains---which words are probably _used_ the most. I say probably because we're analyzing a taxonomic work, rather than actual speech. Who knows if they match up; we'll find out.
