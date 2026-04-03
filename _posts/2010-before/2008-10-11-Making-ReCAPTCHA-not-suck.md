---
title: Making ReCAPTCHA not suck
date: '2008-10-11'
tags:
- code
- Drupal
- webdesign
wp:post_type: post
redirect_from:
- node/260
- observation/making-recaptcha-not-suck
- 2008/10/making-recaptcha-not-suck/
- "?p=260"
---

I really like using the Drupal [CAPTCHA](http://drupal.org/project/captcha) system with [ReCAPTCHA](http://drupal.org/project/recaptcha) (the one that helps [scan in books](http://recaptcha.net/)). Both of them suck in the standard "Drupal makes everything ugly and hard to use by default, but it's still easier than building something from scratch".

One of ReCaptcha's problems is that the words are sometimes hard to read. To deal with that, I used this tip from a Stumbleupon developer in the comments of this post entitled [ReCAPTCHA’s quality is going down?](http://a.wholelottanothing.org/2008/03/27/recaptchas-quality-is-going-down/): putting a link to reload---Recaptcha.reload()---the CAPTCHA in the explanation. To do that, I pasted this into the Challenge Description setting on the CAPTCHA admin page:

`
To prevent spam, please type the two words you see below separated by a space. <a href="javascript:Recaptcha.reload();" title="Get a new set of words">Can't read the words?</a>
`

I also used CSS to hide the fieldset border box and title from the comments to cut down on the cruft too.
