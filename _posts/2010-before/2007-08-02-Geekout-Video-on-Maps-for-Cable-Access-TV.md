---
title: 'Geekout: Video on Maps for Cable Access TV'
date: '2007-08-02'
tags:
- Cable Access
- coding
- development
- Drupal
- geekout
- navigation
- portfolio
- video
wp:post_type: post
redirect_from:
- node/136
- articles/geekout-video-maps-cable-access-tv
- 2007/08/geekout-video-on-maps-for-cable-access-tv/
- "?p=136"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2ec915c16cfdadd5"
  vector: "DwEH+Q0M/Qb4Agb9BP7/CP3++vr5+P3+/wYBCwH5CPkGAQUF/fT5/f/1/wL9Afv/+/75+fcA+wD2AgYB+foL/QsE9PgFBfwBAPz4+vj+/voMBvoAA/z8///+9QL0DAf7+fMDBggJ/vX78PgI+f7/CPb9+QQIAAAFCwH3/fv2AwAF+AEIBwf7CfP6BAH6C/oGAAL6/P8EAAQGCPgH+/oE+gH+CgD0/vkFAv7//P38/gH89AgI+fIG+PX+/PoFAAkBAfwKAAX7/wgJAvX5+fkEDPj5CPsC9//6/vr8CPv4AwAH/f0B/gAPCAMF9/b9+wIA9wH+BfsQBgkD/QT99wL///wGDPwLC/cL/wT5+AEABQMEAAH4/f4P/fX/BAAC8gD8BQT9BPcHAgELAwQKBw4F+/7/AgUBDQUE+f7+Dv4IAAD5+/YD+PwTBwb8Bf4J+//3+gIBB/oIBP0C//4E//0HAAEC9/kB+/oICAIC+QkBDwgCB/gA/gEM+ggN+gX4A//8"
---

![](/uploads/2007-08/mediamap-600x448.jpg "mediamap")

I recently did some [Drupal](http://drupal.org) development work for [Cambridge Community Television](http://cctvcambridge.org). As part of the really amazing work they are doing combining new media with traditional [Cable Access Television](http://alliancecm.org), CCTV has been mapping videos their members produce. They call this project the [Mediamap](http://cctvcambridge.org/mediamap).

I was really excited to work on the Mediamap with CCTV because of my long [involvement](http://island94.org/articles/future-cable-access) with Cable Access Television, most notably the now-defunct [DigitalBicycle Project](https://web.archive.org/web/20070712053537/http://digitalbicycle.org/) and the community maintained directory of Cable Access Stations I built and administer: [MappingAccess.com](https://web.archive.org/web/20070819093518/http://www.mappingaccess.com/).

Despite CCTV running their website on Drupal, their first proof-of-concept version of the Mediamap was created manually, using the very capable [Mapbuilder.net](http://mapbuilder.net) service and copy-and-pasted embedded flash video. While simple from a technological standpoint, they were running to problems optimizing the workflow of updating the map; changes had to be made via the Mapbuilder.net interface, with a single username and password, then manually parsed to remove some coding irregularities, and finally copy and pasted whole into a page on their website.

I was asked to improve the workflow and ultimately take fuller advantage of Drupal's built-in user management and content management features. For instance, taking advantage of CCTV's current member submitted video capabilities and flowing them into the map as an integrated report, not a separate and parallel system.

In my discussions with them, a couple of issues came up. Foremost was that CCTV was running an older version of Drupal: 4.7. While still quite powerful, many newer features and contributed modules were not available for this earlier release. The current version of Drupal, 5.1, has many rich, well-developed utilities for creating reports and mapping them: [Content Construction Kit (CCK)](http://drupal.org/project/cck) + [Views](http://drupal.org/project/views) + [Gmap](http://drupal.org/project/gmap) + [Location](http://drupal.org/project/location). As it was though, with the older version, I would have to develop the additional functionality manually.

The following is a description, with code examples, of the functionality I created for the Mediamap. Additionally, following this initial development, CCTV upgraded their Drupal installation to 5.1, giving me the opportunity to demonstrate the ease and power of Drupal's most recent release---rendering blissfully obsolete most of the custom coding I had done.

Location and Gmap was used in both versions for storing geographic data and hooking into the Google Map API. One of Drupal's great strengths is the both the diversity of contributed modules, and the flexibility with which a developer can use them.

### Adding additional content fields

CCTV already has a process in which member's can submit content nodes. In 4.7, the easiest way to add additional data fields to these was with a custom [NodeAPI module](http://api.drupal.org/api/file/nodeapi_example.module/4.7). CCTV was interested in using embedded flash video, primarily from [Blip.tv](http://blip.tv), but also Google Video or YouTube if the flexibility was needed. To simplify the process, we decided on just adding the cut-and-paste embed code to a custom content field in existing nodes.

To do this, I created a new module that invoked hook_nodeapi:

```php
/\*\*\ * Implementation of hook_nodeapi\ * /

function cambridge_mediamap_nodeapi(&$node, $op, $teaser, $page) {
  switch ($op) {
    case 'validate':
      if (variable_get('cambridge_mediamap_'.$node - > type, TRUE)) {
        if (user_access('modify node data')) {
          if ($node - > cambridge_mediamap['display'] && $node - > cambridge_mediamap['embed'] == '') {
            form_set_error('cambridge_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));
          }
        }
      }
      break;
    case 'load':
      $object = db_fetch_object(db_query('SELECT display, embed FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid));
      $embed = $object - > embed;
      $embed_resize = cambridge_mediamap_resize($embed);
      return array('cambridge_mediamap' => array('display' => $object - > display, 'embed' => $embed, 'embed_resize' => $embed_resize, ));
      break;
    case 'insert':
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'update':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'delete':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      break;  
    case 'view':
      break;
  }
}
```

As you can see, there is a considerable amount of coding required, from defining the form, validating input and configuring database storage and retrieval calls.

Now that we have the glue for the custom field, we have to configure what node types that custom field appears on. Additionally, we need to set up administrative settings to configure where that custom field will appear, and lastly insert that field into the node edit screen:

```php

\**
 * Implementation of hook_form_alter
 */
function cambridge_mediamap_nodeapi( & $node, $op, $teaser, $page) {
  switch ($op) {
    case 'validate':
      if (variable_get('cambridge_mediamap_'.$node - > type, TRUE)) {
        if (user_access('modify node data')) {
          if ($node - > cambridge_mediamap['display'] && $node - > cambridge_mediamap['embed'] == '') {
            form_set_error('cambridge_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));
          }
        }
      }
      break;
    case 'load':
      $object = db_fetch_object(db_query('SELECT display, embed FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid));
      $embed = $object - > embed;
      $embed_resize = cambridge_mediamap_resize($embed);
      return array(
        'cambridge_mediamap' => array(
          'display' => $object - > display,
          'embed' => $embed,
          'embed_resize' => $embed_resize,
        )
      );
      break;
    case 'insert':
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'update':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'delete':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      break;
    case 'view':
      break;
  }
}
```

As you can see, that's a lot of lines of code for what we essentially can do, in Drupal 5.1 with CCK. CCK allows you, graphically through the Drupal web-interface, to create a new content field and add it to a node type; it takes about a minute.

### Building the Map

The primary goal of rebuilding the Mediamap using native Drupal was workflow optimization: it was frustrating to submit information both within Drupal and then recreate it within Mapbuilder. In essence, the map should be just another report of Drupal content: you may have a short bulleted list of the top five articles, a paginated history with teasers and author information, or a full-blown map, but most importantly, all of it is flowing dynamically out of the Drupal database.

The Gmap module provides many powerful ways to integrate the Google Map API with Drupal. While Gmap for 4.7 provides a default map of content it would not provide the features or customizability we desired with the Mediamap. Instead, one of the most powerful ways to use Gmap is to hook directly into the module's own API-like functions:

```
\**
 * A page callback to draw the map
 */

function cambridge_mediamap_map() {
  $output = '';
  //Collect the nodes to be displayed
  $results = db_query('SELECT embed, nid FROM {cambridge_mediamap} WHERE display = 1');
  //Initialize our marker array
  $markers = array();
  //check to see what modules are enabled
  $location_enabled = module_exist('location');
  $gmap_location_enabled = module_exist('gmap_location');
  //load each node and set it's attributes in the marker array
  while ($item = db_fetch_object($results)) {
    $latitude = 0;
    $longitude = 0;
    //load the node
    $node = node_load(array('nid' => $item - > nid));
    //set the latitude and longitude
    //give location module data preference over gmap module data
    if ($location_enabled) {
      $latitude = $node - > location['latitude'];
      $longitude = $node - > location['longitude'];
    }
    elseif($gmap_location_enabled) {
      $latitude = $node - > gmap_location_latitude;
      $longitude = $node - > gmap_location_longitude;
    }
    if ($latitude && $longitude) {
      $markers[] = array(
        'label' => theme('cambridge_mediamap_marker', $node),
        'latitude' => $latitude,
        'longitude' => $longitude,
        'markername' => variable_get('cambridge_mediamap_default_marker', 'marker'),
      );
    }
  }
  $latlon = explode(',', variable_get('cambridge_mediamap_default_latlong', '42.369452,-71.100426'));
  $map = array(
    'id' => 'cambridge_mediamap',
    'latitude' => trim($latlon[0]),
    'longitude' => trim($latlon[1]),
    'width' => variable_get('cambridge_mediamap_default_width', '100%'),
    'height' => variable_get('cambridge_mediamap_default_height', '500px'),
    'zoom' => variable_get('cambridge_mediamap_default_zoom', 13),
    'control' => variable_get('cambridge_mediamap_default_control', 'Large'),
    'type' => variable_get('cambridge_mediamap_default_type', 'Satellite'),
    'markers' => $markers,
  );

  return gmap_draw_map($map);
}
```

As you can see, this is quite complicated. Drupal 5.1 offers the powerful Views module, which allows one to define custom reports, once again graphically from the Drupal web-interface, in just a couple minutes of configuration. The gmap_views module, which ships with Gmap, allows one to add those custom reports to a Google Map, which is incredibly useful and renders obsolete much of the development work I did.

### On displaying video in maps

In my discussions with CCTV, we felt it most pragmatic to use the embedded video code provided by video hosting services such as Blip.tv. While we could have used one of the Drupal video modules, we wanted the ability to host video offsite due to storage constraints. While I was concerned about the danger of code injection via minimally validated inputs, we felt that this would be of small danger because the content would be maintained by CCTV staff and select members.

The markers were themed using the embedded video field pulled from the Drupal database, along with the title and a snippet of the description, all linking back to the full content node.

```php
/**
 * A theme function for our markers
 */
function theme_cambridge_mediamap_marker($node) {
  $output = '';
  $output. = '' . l($node->title, 'node / ' . $node->nid) . '';
  $output. = '' . $node->cambridge_mediamap[' . embed_resize '] . '';
  $output. = '';
  return $output;
}
```

With Drupal 5.1 and Views, we still had to override the standard marker themes, but this was simple and done through the standard methods.

One of the most helpful pieces was some code developed by [Rebecca White](http://circuitous.org), who I previously worked with on [Panlexicon](http://panlexicon.com). She provided the critical pieces of code that parsed the embedded video code and resized it for display on small marker windows.

```php
/**

\* Returns a resized embed code

\*/
function cambridge_mediamap_resize($embed = '') {
  if (!$embed) {
    return '';
  }
  list($width, $height) = cambridge_mediamap_get_embed_size($embed);
  //width/height ratio
  $width_to_height = $width / $height;
  $max_width = variable_get('cambridge_mediamap_embed_width', '320');
  $max_height = variable_get('cambridge_mediamap_embed_height', '240');
  //shrink down widths while maintaining proportion
  if ($width >= $height) {
    if ($width > $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height)\ * $width;
    }
    if ($height > $max_height) {
      $height = $max_height;
      $width = ($width_to_height)\ * $height;
    }
  } else {
    if ($height > $max_height) {
      $height = $max_height;
      $width = ($width_to_height)\ * $height;
    }
    if ($width > $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height)\ * $width;
    }
  }
  return cambridge_mediamap_set_embed_size($embed, intval($width), intval($height));
}
/\*\*\ * find out what size the embedded thing is\ * /

function cambridge_mediamap_get_embed_size($html) {
  preg_match('/]\*width(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match_width);
  preg_match('/]\*height(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match_height);
  return array($match_width[2], $match_height[2]);
}
/\*\*\ * set the size of the embeded thing\ * /

function cambridge_mediamap_set_embed_size($html, $width, $height) {
  $html = preg_replace('/(<(embed|object)\s[^>]\*width(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}'.$width, $html);
  $html = preg_replace('/(<(embed|object)\s[^>]\*height(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}'.$height, $html);
  return $html;
}
/\*\*\ * returns the base url of the src attribute.\*youtube = www.youtube.com\ * blip = blip.tv\ * google video = video.google.com\ * /

function cambridge_mediamap_get_embed_source($html) {
  preg_match('/]\*src="http:\/\/([^\/"]+)/i', $html, $match_src);
  return $match_src[1];
}
```

### The Wrap-Up

While it may not seem so from the lines of code above, developing for Drupal is still relatively easy. Drupal provides a rich set of features for developers, [well documented features](http://api.drupal.org), and strong [coding standards](http://drupal.org/coding-standards)---making reading other people's code and learning from it incredibly productive.

Below is the entirety of the custom module I developed for the 4.7 version of the CCTV Media Map. Because it was custom and intended to be used in-house, many important, release worthy functions were omitted, such as richer administrative options and module/function verifications.

```php
'cambridge_mediamap', 'title' => t('Mediamap'), 'callback' => 'cambridge_mediamap_map', 'access' => user_access('access mediamap'), );
}
return $items;
}
/\*\*\ * Implementation of hook_nodeapi\ * /

function cambridge_mediamap_nodeapi( & $node, $op, $teaser, $page) {
  switch ($op) {
    case 'validate':
      if (variable_get('cambridge_mediamap_'.$node - > type, TRUE)) {
        if (user_access('modify node data')) {
          if ($node - > cambridge_mediamap['display'] && $node - > cambridge_mediamap['embed'] == '') {
            form_set_error('cambridge_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));
          }
        }
      }
      break;
    case 'load':
      $object = db_fetch_object(db_query('SELECT display, embed FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid));
      $embed = $object - > embed;
      $embed_resize = cambridge_mediamap_resize($embed);
      return array('cambridge_mediamap' => array('display' => $object - > display, 'embed' => $embed, 'embed_resize' => $embed_resize, ));
      break;
    case 'insert':
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'update':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node - > nid, $node - > cambridge_mediamap['display'], $node - > cambridge_mediamap['embed']);
      break;
    case 'delete':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node - > nid);
      break;
    case 'view':
      break;
  }
}
/\*\*\ * Returns a resized embed code\ * /

function cambridge_mediamap_resize($embed = '') {
  if (!$embed) {
    return '';
  }
  list($width, $height) = cambridge_mediamap_get_embed_size($embed);
  //width/height ratio
  $width_to_height = $width / $height;
  $max_width = variable_get('cambridge_mediamap_embed_width', '320');
  $max_height = variable_get('cambridge_mediamap_embed_height', '240');
  //shrink down widths while maintaining proportion
  if ($width >= $height) {
    if ($width > $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height)\ * $width;
    }
    if ($height > $max_height) {
      $height = $max_height;
      $width = ($width_to_height)\ * $height;
    }
  } else {
    if ($height > $max_height) {
      $height = $max_height;
      $width = ($width_to_height)\ * $height;
    }
    if ($width > $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height)\ * $width;
    }
  }
  return cambridge_mediamap_set_embed_size($embed, intval($width), intval($height));
}
/\*\*\ * find out what size the embedded thing is\ * /

function cambridge_mediamap_get_embed_size($html) {
  preg_match('/]\*width(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match_width);
  preg_match('/]\*height(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match_height);
  return array($match_width[2], $match_height[2]);
}
/\*\*\ * set the size of the embeded thing\ * /

function cambridge_mediamap_set_embed_size($html, $width, $height) {
  $html = preg_replace('/(<(embed|object)\s[^>]\*width(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}'.$width, $html);
  $html = preg_replace('/(<(embed|object)\s[^>]\*height(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}'.$height, $html);
  return $html;
}
/\*\*\ * returns the base url of the src attribute.\*youtube = www.youtube.com\ * blip = blip.tv\ * google video = video.google.com\ * /

function cambridge_mediamap_get_embed_source($html) {
  preg_match('/]\*src="http:\/\/([^\/"]+)/i', $html, $match_src);
  return $match_src[1];
}
/\*\*\ * Implementation of hook_form_alter\ * /

function cambridge_mediamap_form_alter($form_id, & $form) {
  // We're only modifying node forms, if the type field isn't set we don't need
  // to bother.
  if (!isset($form['type'])) {
    return;
  }
  //disable the Gmap module's location map for unauthorized users
  //unfortunately Gmap.module doesn't have this setting
  if (isset($form['coordinates'])) {
    if (!user_access('modify node data')) {
      unset($form['coordinates']);
    }
  }
  // Make a copy of the type to shorten up the code
  $type = $form['type']['#value'];
  // Is the map enabled for this content type?
  $enabled = variable_get('cambridge_mediamap_'.$type, 0);
  switch ($form_id) {
    // We need to have a way for administrators to indicate which content
    // types should have the additional media map information added.
    case $type.
    '_node_settings':
      $form['workflow']['cambridge_mediamap_'.$type] = array('#type' => 'radios', '#title' => t('Cambridge Mediamap setting'), '#default_value' => $enabled, '#options' => array(0 => t('Disabled'), 1 => t('Enabled')), '#description' => t('Allow the attaching of externally hosted imbedded video to be displayed in a map?'), );
      break;
    case $type.
    '_node_form':
      if ($enabled && user_access('modify node data')) {
        //create the fieldset
        $form['cambridge_mediamap'] = array('#type' => 'fieldset', '#title' => t('Media Map'), '#collapsible' => TRUE, '#collapsed' => FALSE, '#tree' => TRUE, );
        //insert the embed code
        $form['cambridge_mediamap']['embed'] = array('#type' => 'textarea', '#title' => t('Video Embed Code'), '#default_value' => $form['#node'] - > cambridge_mediamap['embed'], '#cols' => 60, '#rows' => 5, '#description' => t('Copy and paste the embed code from an external video or media hosting service'), );
        //enable or disable on map
        $form['cambridge_mediamap']['display'] = array('#type' => 'select', '#title' => t('Display this node'), '#default_value' => $form['#node'] - > cambridge_mediamap['display'], '#options' => array('0' => t('Disable display'), '1' => t('Enable display'), ), );
      }
      break;
  }
}
/\*\*\ * A page callback to draw the map\ * /

function cambridge_mediamap_map() {
  $output = '';
  //Collect the nodes to be displayed
  $results = db_query('SELECT embed, nid FROM {cambridge_mediamap} WHERE display = 1');
  //Initialize our marker array
  $markers = array();
  //check to see what modules are enabled
  $location_enabled = module_exist('location');
  $gmap_location_enabled = module_exist('gmap_location');
  //load each node and set it's attributes in the marker array
  while ($item = db_fetch_object($results)) {
    $latitude = 0;
    $longitude = 0;
    //load the node
    $node = node_load(array('nid' => $item - > nid));
    //set the latitude and longitude
    //give location module data preference over gmap module data
    if ($location_enabled) {
      $latitude = $node - > location['latitude'];
      $longitude = $node - > location['longitude'];
    }
    elseif($gmap_location_enabled) {
      $latitude = $node - > gmap_location_latitude;
      $longitude = $node - > gmap_location_longitude;
    }
    if ($latitude && $longitude) {
      $markers[] = array('label' => theme('cambridge_mediamap_marker', $node), 'latitude' => $latitude, 'longitude' => $longitude, 'markername' => variable_get('cambridge_mediamap_default_marker', 'marker'), );
    }
  }
  $latlon = explode(',', variable_get('cambridge_mediamap_default_latlong', '42.369452,-71.100426'));
  $map = array('id' => 'cambridge_mediamap', 'latitude' => trim($latlon[0]), 'longitude' => trim($latlon[1]), 'width' => variable_get('cambridge_mediamap_default_width', '100%'), 'height' => variable_get('cambridge_mediamap_default_height', '500px'), 'zoom' => variable_get('cambridge_mediamap_default_zoom', 13), 'control' => variable_get('cambridge_mediamap_default_control', 'Large'), 'type' => variable_get('cambridge_mediamap_default_type', 'Satellite'), 'markers' => $markers, );
  return gmap_draw_map($map);
}
/\*\*\ * A theme
function
for our markers\ * /

function theme_cambridge_mediamap_marker($node) {
  $output = '
  ';
  $output. = '
  ' . l($node->title, '
  node / ' . $node->nid) . '
  ';
  $output. = '
  ' . $node->cambridge_mediamap['
  embed_resize '] . '
  ';
  $output. = '
  ';
  return $output;
}
/\*\*\ * Settings page\ * /

function cambridge_mediamap_settings() {
  // Cambridge data
  // latitude = 42.369452
  // longitude = -71.100426
  $form['defaults'] = array('#type' => 'fieldset', '#title' => t('Default map settings'), );
  $form['defaults']['cambridge_mediamap_default_width'] = array('#type' => 'textfield', '#title' => t('Default width'), '#default_value' => variable_get('cambridge_mediamap_default_width', '100%'), '#size' => 25, '#maxlength' => 6, '#description' => t('The default width of a Google map. Either px or %'), );
  $form['defaults']['cambridge_mediamap_default_height'] = array('#type' => 'textfield', '#title' => t('Default height'), '#default_value' => variable_get('cambridge_mediamap_default_height', '500px'), '#size' => 25, '#maxlength' => 6, '#description' => t('The default height of Mediamap. In px.'), );
  $form['defaults']['cambridge_mediamap_default_latlong'] = array('#type' => 'textfield', '#title' => t('Default center'), '#default_value' => variable_get('cambridge_mediamap_default_latlong', '42.369452,-71.100426'), '#description' => 'The decimal latitude,longitude of the centre of the map. The "." is used for decimal, and "," is used to separate latitude and longitude.', '#size' => 50, '#maxlength' => 255, '#description' => t('The default longitude, latitude of Mediamap.'), );
  $form['defaults']['cambridge_mediamap_default_zoom'] = array('#type' => 'select', '#title' => t('Default zoom'), '#default_value' => variable_get('cambridge_mediamap_default_zoom', 13), '#options' => drupal_map_assoc(range(0, 17)), '#description' => t('The default zoom level of Mediamap.'), );
  $form['defaults']['cambridge_mediamap_default_control'] = array('#type' => 'select', '#title' => t('Default control type'), '#default_value' => variable_get('cambridge_mediamap_default_control', 'Large'), '#options' => array('None' => t('None'), 'Small' => t('Small'), 'Large' => t('Large')), );
  $form['defaults']['cambridge_mediamap_default_type'] = array('#type' => 'select', '#title' => t('Default map type'), '#default_value' => variable_get('cambridge_mediamap_default_type', 'Satellite'), '#options' => array('Map' => t('Map'), 'Satellite' => t('Satellite'), 'Hybrid' => t('Hybrid')), );
  $markers = gmap_get_markers();
  $form['defaults']['cambridge_mediamap_default_marker'] = array('#type' => 'select', '#title' => t('Marker'), '#default_value' => variable_get('cambridge_mediamap_default_marker', 'marker'), '#options' => $markers, );
  $form['embed'] = array('#type' => 'fieldset', '#title' => t('Default embedded video settings'), );
  $form['embed']['cambridge_mediamap_embed_width'] = array('#type' => 'textfield', '#title' => t('Default width'), '#default_value' => variable_get('cambridge_mediamap_embed_width', '320'), '#size' => 25, '#maxlength' => 6, '#description' => t('The maximum width of embedded video'), );
  $form['embed']['cambridge_mediamap_embed_height'] = array('#type' => 'textfield', '#title' => t('Default height'), '#default_value' => variable_get('cambridge_mediamap_embed_height', '240'), '#size' => 25, '#maxlength' => 6, '#description' => t('The maximum height of embedded video.'), );
  return $form;
}
/\*\*\ * Prints human - readable(html) information about a variable.\*Use: print debug($variable_name);\ * Or assign output to a variable.\*/

function debug($value) {
  return preg_replace("/\s/", " ", preg_replace("/\n/", "", print_r($value, true)));
}
```
