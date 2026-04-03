---
title: 'Drupal: theme override for Upload.module''s attachments list'
date: '2008-08-10'
tags:
- art
- design
- Drupal
- intuitive
- navigation
- portfolio
- snippet
- webdesign
wp:post_type: post
redirect_from:
- node/238
- articles/overriding
- articles/override-upload-modules-attachments-list
- articles/drupal-override-upload-modules-attachments-list
- articles/drupal-theme-override-upload-modules-attachments-list
- 2008/08/drupal-theme-override-for-upload-modules-attachments-list/
- "?p=238"
---

**Update:** this functionality can now be achieved with the [iTweak\_upload module ](http://drupal.org/project/itweak_upload). _Thanks to [Damon](http://damoncook.net/) for the tip!_

I made a custom override for Drupal 6.x's Upload.module's attachments table that is displayed at the bottom of a node when you create file attachments. That table is, in my opinion, one of the ugliest common and default presentations in Drupal core. Below is an example of the before and after:

![Example of override](/uploads/2008-08-10-Drupal-theme-override-for-Uploadmodules-attachments-list/shiny_upload-example.png)

To use it, unzip and drop the included folder into your active theme's directory (e.g. /sites/default/all/garland), it should take effect without any other modifications---though you may have to reset the theme cache (goto admin/build/themes and click save without making any other changes).

[Click Here to Download (shiny\_upload.zip)](/uploads/2008-08-10-Drupal-theme-override-for-Uploadmodules-attachments-list/shiny_upload.zip)

Also, I don't know what the name is for these types of theme overrides: it's not a module, and it's not a whole theme. I [posted this](http://groups.drupal.org/node/13873) to a Drupal Group that, I think, calls them " [Themer Packs](http://groups.drupal.org/themer-pack-working-group)".

The icon code is based on the CCK [filefield module](http://drupal.org/project/filefield)---but the current 6.0 version is kind've clunky and I wanted to port it to the core Upload module. The namespace is "shiny\_upload".

Also, as an aside, the reason island94.org doesn't currently have this enabled is because it's still running on Drupal 5.x branch
