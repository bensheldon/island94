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
wp:post_id: '136'
link: http://island94.dev/2007/08/geekout-video-on-maps-for-cable-access-tv/
wp:post_type: post
files:
- http://www.island94.org/wp-content/uploads/2007/08/mediamap-600x448.jpg
---

<img class="aligncenter size-medium wp-image-2572" title="mediamap" src="http://www.island94.org/wp-content/uploads/2007/08/mediamap-600x448.jpg" alt="" width="600" height="448" />

I recently did some <a href="http://drupal.org">Drupal</a> development work for <a href="http://cctvcambridge.org">Cambridge Community Television</a>.  As part of the really amazing work they are doing combining new media with traditional <a href="http://alliancecm.org">Cable Access Television</a>, CCTV has been mapping videos their members produce.  They call this project the <a href="http://cctvcambridge.org/mediamap">Mediamap</a>.

I was really excited to work on the Mediamap with CCTV because of my long <a href="http://island94.org/articles/future-cable-access">involvement</a> with Cable Access Television, most notably the now-defunct <a href="http://digitalbicycle.org">DigitalBicycle Project</a> and the community maintained directory of Cable Access Stations I built and administer: <a href="http://mappingaccess.com">MappingAccess.com</a>.

Despite CCTV running their website on Drupal, their first proof-of-concept version of the Mediamap was created manually, using the very capable <a href="http://mapbuilder.net">Mapbuilder.net</a> service and copy-and-pasted embedded flash video.  While simple from a technological standpoint, they were running to problems optimizing the workflow of updating the map; changes had to be made via the Mapbuilder.net interface, with a single username and password, then manually parsed to remove some coding irregularities, and finally copy and pasted whole into a page on their website.

I was asked to improve the workflow and ultimately take fuller advantage of Drupal's built-in user management and content management features.  For instance, taking advantage of CCTV's current member submitted video capabilities and flowing them into the map as an integrated report, not a separate and parallel system.

In my discussions with them, a couple of issues came up.  Foremost was that CCTV was running an older version of Drupal: 4.7.  While still quite powerful, many newer features and contributed modules were not available for this earlier release.  The current version of Drupal, 5.1, has many rich, well-developed utilities for creating reports and mapping them: <a href="http://drupal.org/project/cck">Content Construction Kit (CCK)</a> + <a href="http://drupal.org/project/views">Views</a> + <a href="http://drupal.org/project/gmap">Gmap</a> + <a href="http://drupal.org/project/location">Location</a>.  As it was though, with the older version, I would have to develop the additional functionality manually.

The following is a description, with code examples, of the functionality I created for the Mediamap.  Additionally, following this initial development, CCTV upgraded their Drupal installation to 5.1, giving me the opportunity to demonstrate the ease and power of Drupal's most recent release---rendering blissfully obsolete most of the custom coding I had done.

Location and Gmap was used in both versions for storing geographic data and hooking into the Google Map API.  One of Drupal's great strengths is the both the diversity of contributed modules, and the flexibility with which a developer can use them.
<h3>Adding additional content fields</h3>
CCTV already has a process in which member's can submit content nodes.  In 4.7, the easiest way to add additional data fields to these was with a custom <a href="http://api.drupal.org/api/file/nodeapi_example.module/4.7">NodeAPI module</a>.  CCTV was interested in using embedded flash video, primarily from <a href="http://blip.tv">Blip.tv</a>, but also Google Video or YouTube if the flexibility was needed.  To simplify the process, we decided on just adding the cut-and-paste embed code to a custom content field in existing nodes.

To do this, I created a new module that invoked hook_nodeapi:

<code>
/**
* Implementation of hook_nodeapi
*/
function cambridge_mediamap_nodeapi(&amp;$node, $op, $teaser, $page) {
switch ($op) {</code>

<code>case 'validate':
if (variable_get('cambridge_mediamap_'. $node-&gt;type, TRUE)) {
if (user_access('modify node data')) {
if ($node-&gt;cambridge_mediamap['display'] &amp;&amp; $node-&gt;cambridge_mediamap['embed'] == '') {
form_set_error('cambridge_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));
}
}
}
break;</code>

<code> </code>

<code>case 'load':
$object = db_fetch_object(db_query('SELECT display, embed FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid));</code>

<code>$embed = $object-&gt;embed;
$embed_resize = cambridge_mediamap_resize($embed);

return array(
'cambridge_mediamap' =&gt; array(
'display' =&gt; $object-&gt;display,
'embed' =&gt; $embed,
'embed_resize' =&gt; $embed_resize,
)
);
break;

case 'insert':
db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node-&gt;nid, $node-&gt;cambridge_mediamap['display'], $node-&gt;cambridge_mediamap['embed']);
break;

case 'update':
db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid);
db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node-&gt;nid, $node-&gt;cambridge_mediamap['display'], $node-&gt;cambridge_mediamap['embed']);
break;

case 'delete':
db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid);
break;

</code>

&nbsp;

&nbsp;

<code> case 'view':
break;
}
}
</code>

As you can see, there is a considerable amount of coding required, from defining the form, validating input and configuring database storage and retrieval calls.

Now that we have the glue for the custom field, we have to configure what node types that custom field appears on.  Additionally, we need to set up administrative settings to configure where that custom field will appear, and lastly insert that field into the node edit screen:

<code>
/**
* Implementation of hook_form_alter
*/
function cambridge_mediamap_form_alter($form_id, &amp;$form) {
// We're only modifying node forms, if the type field isn't set we don't need
// to bother.
if (!isset($form['type'])) {
return;
}</code>

<code>//disable the Gmap module's location map for unauthorized users
//unfortunately Gmap.module doesn't have this setting
if (isset($form['coordinates'])) {
if (!user_access('modify node data')) {
unset($form['coordinates']);
}
}</code>

<code> </code>

<code>// Make a copy of the type to shorten up the code
$type =  $form['type']['#value'];</code>

<code>// Is the map enabled for this content type?
$enabled = variable_get('cambridge_mediamap_'. $type, 0);

switch ($form_id) {
// We need to have a way for administrators to indicate which content
// types should have the additional media map information added.
case $type .'_node_settings':
$form['workflow']['cambridge_mediamap_'. $type] = array(
'#type' =&gt; 'radios',
'#title' =&gt; t('Cambridge Mediamap setting'),
'#default_value' =&gt; $enabled,
'#options' =&gt; array(0 =&gt; t('Disabled'), 1 =&gt; t('Enabled')),
'#description' =&gt; t('Allow the attaching of externally hosted imbedded video to be displayed in a map?'),
);
break;

case $type .'_node_form':

if ($enabled &amp;&amp; user_access('modify node data')) {
//create the fieldset
$form['cambridge_mediamap'] = array(
'#type' =&gt; 'fieldset',
'#title' =&gt; t('Media Map'),
'#collapsible' =&gt; TRUE,
'#collapsed' =&gt; FALSE,
'#tree' =&gt; TRUE,
);
//insert the embed code
$form['cambridge_mediamap']['embed'] = array(
'#type' =&gt; 'textarea',
'#title' =&gt; t('Video Embed Code'),
'#default_value' =&gt;  $form['#node']-&gt;cambridge_mediamap['embed'],
'#cols' =&gt; 60,
'#rows' =&gt; 5,
'#description' =&gt; t('Copy and paste the embed code from an external video or media hosting service'),
);
//enable or disable on map
$form['cambridge_mediamap']['display'] = array(
'#type' =&gt; 'select',
'#title' =&gt; t('Display this node'),
'#default_value' =&gt; $form['#node']-&gt;cambridge_mediamap['display'],
'#options' =&gt; array(
'0' =&gt; t('Disable display'),
'1' =&gt; t('Enable display'),
),
);

</code>

&nbsp;

&nbsp;

<code> }
break;
}
}
</code>

As you can see, that's a lot of lines of code for what we essentially can do, in Drupal 5.1 with CCK.  CCK allows you, graphically through the Drupal web-interface, to create a new content field and add it to a node type; it takes about a minute.
<h3>Building the Map</h3>
The primary goal of rebuilding the Mediamap using native Drupal was workflow optimization: it was frustrating to submit information both within Drupal and then recreate it within Mapbuilder.  In essence, the map should be just another report of Drupal content: you may have a short bulleted list of the top five articles, a paginated history with teasers and author information, or a full-blown map, but most importantly, all of it is flowing dynamically out of the Drupal database.

The Gmap module provides many powerful ways to integrate the Google Map API with Drupal.  While Gmap for 4.7 provides a default map of content it would not provide the features or customizability we desired with the Mediamap.  Instead, one of the most powerful ways to use Gmap is to hook directly into the module's own API-like functions:

<code>
/**
* A page callback to draw the map
*/
function cambridge_mediamap_map() {
$output = '';</code>

<code>//Collect the nodes to be displayed
$results = db_query('SELECT embed, nid FROM {cambridge_mediamap} WHERE display = 1');</code>

<code> </code>

<code>//Initialize our marker array
$markers = array();</code>

<code>//check to see what modules are enabled
$location_enabled = module_exist('location');
$gmap_location_enabled = module_exist('gmap_location');

//load each node and set it's attributes in the marker array
while($item = db_fetch_object($results)) {
$latitude = 0;
$longitude = 0;
//load the node
$node = node_load(array('nid' =&gt; $item-&gt;nid));

//set the latitude and longitude
//give location module data preference over gmap module data
if ($location_enabled) {
$latitude = $node-&gt;location['latitude'];
$longitude = $node-&gt;location['longitude'];
}
elseif ($gmap_location_enabled) {
$latitude = $node-&gt;gmap_location_latitude;
$longitude = $node-&gt;gmap_location_longitude;
}

if ($latitude &amp;&amp; $longitude) {
$markers[] = array(
'label' =&gt; theme('cambridge_mediamap_marker', $node),
'latitude' =&gt; $latitude,
'longitude' =&gt; $longitude,
'markername' =&gt; variable_get('cambridge_mediamap_default_marker', 'marker'),
);
}
}

$latlon = explode(',', variable_get('cambridge_mediamap_default_latlong','42.369452,-71.100426'));

$map=array(
'id' =&gt; 'cambridge_mediamap',
'latitude' =&gt; trim($latlon[0]),
'longitude'=&gt; trim($latlon[1]),
'width' =&gt; variable_get('cambridge_mediamap_default_width','100%'),
'height' =&gt; variable_get('cambridge_mediamap_default_height','500px'),
'zoom' =&gt; variable_get('cambridge_mediamap_default_zoom', 13),
'control' =&gt; variable_get('cambridge_mediamap_default_control','Large'),
'type' =&gt; variable_get('cambridge_mediamap_default_type','Satellite'),
'markers' =&gt; $markers,
);

</code>

&nbsp;

&nbsp;

<code> return gmap_draw_map($map);
}</code>

As you can see, this is quite complicated.  Drupal 5.1 offers the powerful Views module, which allows one to define custom reports, once again graphically from the Drupal web-interface, in just a couple minutes of configuration.  The gmap_views module, which ships with Gmap, allows one to add those custom reports to a Google Map, which is incredibly useful and renders obsolete much of the development work I did.
<h3>On displaying video in maps</h3>
In my discussions with CCTV, we felt it most pragmatic to use the embedded video code provided by video hosting services such as Blip.tv.  While we could have used one of the Drupal video modules, we wanted the ability to host video offsite due to storage constraints.  While I was concerned about the danger of code injection via minimally validated inputs, we felt that this would be of small danger because the content would be maintained by CCTV staff and select members.

The markers were themed using the embedded video field pulled from the Drupal database, along with the title and a snippet of the description, all linking back to the full content node.
<pre><code>/**
 * A theme function for our markers
 */

function theme_cambridge_mediamap_marker($node) {

  $output = '
<div class="mediamap-marker">';
  $output .= '
<div class="title">' . l($node-&gt;title, 'node/' . $node-&gt;nid) . '</div>
';
  $output .= '
<div class="embed">' . $node-&gt;cambridge_mediamap['embed_resize'] . '</div>
';
  $output .= '</div>
';

  return $output;
}</code></pre>
With Drupal 5.1 and Views, we still had to override the standard marker themes, but this was simple and done through the standard methods.

One of the most helpful pieces was some code developed by <a href="http://circuitous.org">Rebecca White</a>, who I previously worked with on <a href="http://panlexicon.com">Panlexicon</a>.  She provided the critical pieces of code that parsed the embedded video code and resized it for display on small marker windows.
<pre><code>/**
 * Returns a resized embed code
 */
function cambridge_mediamap_resize($embed = '') {
  if (!$embed) {
    return '';
  }

  list($width, $height) = cambridge_mediamap_get_embed_size($embed);

  //width/height ratio
  $width_to_height = $width / $height;

  $max_width = variable_get('cambridge_mediamap_embed_width','320');
  $max_height = variable_get('cambridge_mediamap_embed_height','240');

  //shrink down widths while maintaining proportion
  if ($width &gt;= $height) {
    if ($width &gt; $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height) * $width;
    }
    if ($height &gt; $max_height) {
      $height = $max_height;
      $width = ($width_to_height) * $height;
    }
  }
  else {
    if ($height &gt; $max_height) {
      $height = $max_height;
      $width = ($width_to_height) * $height;
    }
    if ($width &gt; $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height) * $width;
    }
  }

  return cambridge_mediamap_set_embed_size($embed, intval($width), intval($height));
}

/**
 * find out what size the embedded thing is
 */
function cambridge_mediamap_get_embed_size($html) {
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*width(\s*=\s*"|:\s*)(\d+)/i', $html, $match_width);
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*height(\s*=\s*"|:\s*)(\d+)/i', $html, $match_height);

	return array($match_width[2], $match_height[2]);
}

/**
 * set the size of the embeded thing
 */
function cambridge_mediamap_set_embed_size($html, $width, $height) {
	$html = preg_replace('/(&lt;(embed|object)\s[^&gt;]*width(\s*=\s*"|:\s*))(\d+)/i', '${1}' . $width, $html);
	$html = preg_replace('/(&lt;(embed|object)\s[^&gt;]*height(\s*=\s*"|:\s*))(\d+)/i', '${1}' . $height, $html);

	return $html;
}

/**
 * returns the base url of the src attribute.
 * youtube = www.youtube.com
 * blip = blip.tv
 * google video = video.google.com
 */
function cambridge_mediamap_get_embed_source($html) {
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*src="http:\/\/([^\/"]+)/i', $html, $match_src);
	return $match_src[1];
}</code></pre>
<h3>The Wrap-Up</h3>
While it may not seem so from the lines of code above, developing for Drupal is still relatively easy.  Drupal provides a rich set of features for developers, <a href="http://api.drupal.org">well documented features</a>, and strong <a href="http://drupal.org/coding-standards">coding standards</a>---making reading other people's code and learning from it incredibly productive.

Below is the entirety of the custom module I developed for the 4.7 version of the CCTV Media Map.  Because it was custom and intended to be used in-house, many important, release worthy functions were omitted, such as richer administrative options and module/function verifications.
<pre><code> 'cambridge_mediamap',
      'title' =&gt; t('Mediamap'),
      'callback' =&gt; 'cambridge_mediamap_map',
      'access' =&gt; user_access('access mediamap'),
    );
  }
  return $items;
}

/**
 * Implementation of hook_nodeapi
 */
function cambridge_mediamap_nodeapi(&amp;$node, $op, $teaser, $page) {
  switch ($op) {

    case 'validate':
      if (variable_get('cambridge_mediamap_'. $node-&gt;type, TRUE)) {
if (user_access('modify node data')) {
  if ($node-&gt;cambridge_mediamap['display'] &amp;&amp; $node-&gt;cambridge_mediamap['embed'] == '') {
    form_set_error('cambridge_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));
  }
}
      }
      break;

    case 'load':
      $object = db_fetch_object(db_query('SELECT display, embed FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid));

      $embed = $object-&gt;embed;
      $embed_resize = cambridge_mediamap_resize($embed);

      return array(
'cambridge_mediamap' =&gt; array(
  'display' =&gt; $object-&gt;display,
  'embed' =&gt; $embed,
  'embed_resize' =&gt; $embed_resize,
 )
      );
      break;

    case 'insert':
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node-&gt;nid, $node-&gt;cambridge_mediamap['display'], $node-&gt;cambridge_mediamap['embed']);
      break;

    case 'update':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid);
      db_query("INSERT INTO {cambridge_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node-&gt;nid, $node-&gt;cambridge_mediamap['display'], $node-&gt;cambridge_mediamap['embed']);
      break;

    case 'delete':
      db_query('DELETE FROM {cambridge_mediamap} WHERE nid = %d', $node-&gt;nid);
      break;

    case 'view':
      break;
  }
} 

/**
 * Returns a resized embed code
 */
function cambridge_mediamap_resize($embed = '') {
  if (!$embed) {
    return '';
  }

  list($width, $height) = cambridge_mediamap_get_embed_size($embed);

  //width/height ratio
  $width_to_height = $width / $height;

  $max_width = variable_get('cambridge_mediamap_embed_width','320');
  $max_height = variable_get('cambridge_mediamap_embed_height','240');

  //shrink down widths while maintaining proportion
  if ($width &gt;= $height) {
    if ($width &gt; $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height) * $width;
    }
    if ($height &gt; $max_height) {
      $height = $max_height;
      $width = ($width_to_height) * $height;
    }
  }
  else {
    if ($height &gt; $max_height) {
      $height = $max_height;
      $width = ($width_to_height) * $height;
    }
    if ($width &gt; $max_width) {
      $width = $max_width;
      $height = (1 / $width_to_height) * $width;
    }
  }

  return cambridge_mediamap_set_embed_size($embed, intval($width), intval($height));
}

/**
 * find out what size the embedded thing is
 */
function cambridge_mediamap_get_embed_size($html) {
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*width(\s*=\s*"|:\s*)(\d+)/i', $html, $match_width);
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*height(\s*=\s*"|:\s*)(\d+)/i', $html, $match_height);

	return array($match_width[2], $match_height[2]);
}

/**
 * set the size of the embeded thing
 */
function cambridge_mediamap_set_embed_size($html, $width, $height) {
	$html = preg_replace('/(&lt;(embed|object)\s[^&gt;]*width(\s*=\s*"|:\s*))(\d+)/i', '${1}' . $width, $html);
	$html = preg_replace('/(&lt;(embed|object)\s[^&gt;]*height(\s*=\s*"|:\s*))(\d+)/i', '${1}' . $height, $html);

	return $html;
}

/**
 * returns the base url of the src attribute.
 * youtube = www.youtube.com
 * blip = blip.tv
 * google video = video.google.com
 */
function cambridge_mediamap_get_embed_source($html) {
	preg_match('/<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="100" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><embed type="application/x-shockwave-flash" width="100" height="100"></embed></object>]*src="http:\/\/([^\/"]+)/i', $html, $match_src);
	return $match_src[1];
}

/**
 * Implementation of hook_form_alter
 */
function cambridge_mediamap_form_alter($form_id, &amp;$form) {
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
  $type =  $form['type']['#value'];

  // Is the map enabled for this content type?
  $enabled = variable_get('cambridge_mediamap_'. $type, 0);

  switch ($form_id) {
    // We need to have a way for administrators to indicate which content
    // types should have the additional media map information added.
    case $type .'_node_settings':
      $form['workflow']['cambridge_mediamap_'. $type] = array(
'#type' =&gt; 'radios',
'#title' =&gt; t('Cambridge Mediamap setting'),
'#default_value' =&gt; $enabled,
'#options' =&gt; array(0 =&gt; t('Disabled'), 1 =&gt; t('Enabled')),
'#description' =&gt; t('Allow the attaching of externally hosted imbedded video to be displayed in a map?'),
      );
      break;

    case $type .'_node_form':

      if ($enabled &amp;&amp; user_access('modify node data')) {
//create the fieldset
$form['cambridge_mediamap'] = array(
  '#type' =&gt; 'fieldset',
  '#title' =&gt; t('Media Map'),
  '#collapsible' =&gt; TRUE,
  '#collapsed' =&gt; FALSE,
  '#tree' =&gt; TRUE,
);
//insert the embed code
$form['cambridge_mediamap']['embed'] = array(
  '#type' =&gt; 'textarea',
  '#title' =&gt; t('Video Embed Code'),
  '#default_value' =&gt;  $form['#node']-&gt;cambridge_mediamap['embed'],
  '#cols' =&gt; 60,
  '#rows' =&gt; 5,
  '#description' =&gt; t('Copy and paste the embed code from an external video or media hosting service'),
);
//enable or disable on map
$form['cambridge_mediamap']['display'] = array(
  '#type' =&gt; 'select',
  '#title' =&gt; t('Display this node'),
  '#default_value' =&gt; $form['#node']-&gt;cambridge_mediamap['display'],
  '#options' =&gt; array(
    '0' =&gt; t('Disable display'),
    '1' =&gt; t('Enable display'),
  ),
);

      }
      break;
  }
}

/**
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
  while($item = db_fetch_object($results)) {
    $latitude = 0;
    $longitude = 0;
    //load the node
    $node = node_load(array('nid' =&gt; $item-&gt;nid));

    //set the latitude and longitude
    //give location module data preference over gmap module data
    if ($location_enabled) {
      $latitude = $node-&gt;location['latitude'];
      $longitude = $node-&gt;location['longitude'];
    }
    elseif ($gmap_location_enabled) {
      $latitude = $node-&gt;gmap_location_latitude;
      $longitude = $node-&gt;gmap_location_longitude;
    }

    if ($latitude &amp;&amp; $longitude) {
      $markers[] = array(
'label' =&gt; theme('cambridge_mediamap_marker', $node),
'latitude' =&gt; $latitude,
'longitude' =&gt; $longitude,
'markername' =&gt; variable_get('cambridge_mediamap_default_marker', 'marker'),
      );
    }
  }

  $latlon = explode(',', variable_get('cambridge_mediamap_default_latlong','42.369452,-71.100426'));

  $map=array(
    'id' =&gt; 'cambridge_mediamap',
    'latitude' =&gt; trim($latlon[0]),
    'longitude'=&gt; trim($latlon[1]),
    'width' =&gt; variable_get('cambridge_mediamap_default_width','100%'),
    'height' =&gt; variable_get('cambridge_mediamap_default_height','500px'),
    'zoom' =&gt; variable_get('cambridge_mediamap_default_zoom', 13),
    'control' =&gt; variable_get('cambridge_mediamap_default_control','Large'),
    'type' =&gt; variable_get('cambridge_mediamap_default_type','Satellite'),
    'markers' =&gt; $markers,
    );

  return gmap_draw_map($map);
}

/**
 * A theme function for our markers
 */

function theme_cambridge_mediamap_marker($node) {

  $output = '
<div class="mediamap-marker">';
  $output .= '
<div class="title">' . l($node-&gt;title, 'node/' . $node-&gt;nid) . '</div>
';
  $output .= '
<div class="embed">' . $node-&gt;cambridge_mediamap['embed_resize'] . '</div>
';
  $output .= '</div>
';

  return $output;
}

/**
 * Settings page
 */
function cambridge_mediamap_settings() {
   // Cambridge data
   //  latitude = 42.369452
   //  longitude = -71.100426

  $form['defaults']=array(
    '#type' =&gt; 'fieldset',
    '#title' =&gt; t('Default map settings'),
  );

  $form['defaults']['cambridge_mediamap_default_width'] = array(
    '#type' =&gt; 'textfield',
    '#title' =&gt; t('Default width'),
    '#default_value' =&gt; variable_get('cambridge_mediamap_default_width','100%'),
    '#size' =&gt; 25,
    '#maxlength' =&gt; 6,
    '#description' =&gt; t('The default width of a Google map. Either px or %'),
  );
  $form['defaults']['cambridge_mediamap_default_height'] = array(
    '#type' =&gt; 'textfield',
    '#title' =&gt; t('Default height'),
    '#default_value' =&gt; variable_get('cambridge_mediamap_default_height','500px'),
    '#size' =&gt; 25,
    '#maxlength' =&gt; 6,
    '#description' =&gt; t('The default height of Mediamap. In px.'),
  );
  $form['defaults']['cambridge_mediamap_default_latlong'] = array(
    '#type' =&gt; 'textfield',
    '#title' =&gt; t('Default center'),
    '#default_value' =&gt; variable_get('cambridge_mediamap_default_latlong','42.369452,-71.100426'),
    '#description' =&gt; 'The decimal latitude,longitude of the centre of the map.  The "." is used for decimal, and "," is used to separate latitude and longitude.',
    '#size' =&gt; 50,
    '#maxlength' =&gt; 255,
    '#description' =&gt; t('The default longitude, latitude of Mediamap.'),
  );
  $form['defaults']['cambridge_mediamap_default_zoom']=array(
    '#type'=&gt;'select',
    '#title'=&gt;t('Default zoom'),
    '#default_value'=&gt;variable_get('cambridge_mediamap_default_zoom', 13),
    '#options' =&gt; drupal_map_assoc(range(0, 17)),
    '#description'=&gt;t('The default zoom level of Mediamap.'),
  );
  $form['defaults']['cambridge_mediamap_default_control']=array(
    '#type'=&gt;'select',
    '#title'=&gt;t('Default control type'),
    '#default_value'=&gt;variable_get('cambridge_mediamap_default_control','Large'),
    '#options'=&gt;array('None'=&gt;t('None'),'Small'=&gt;t('Small'),'Large'=&gt;t('Large')),
  );
  $form['defaults']['cambridge_mediamap_default_type']=array(
    '#type'=&gt;'select',
    '#title'=&gt;t('Default map type'),
    '#default_value'=&gt;variable_get('cambridge_mediamap_default_type','Satellite'),
    '#options'=&gt;array('Map'=&gt;t('Map'),'Satellite'=&gt;t('Satellite'),'Hybrid'=&gt;t('Hybrid')),
  );

  $markers = gmap_get_markers();

  $form['defaults']['cambridge_mediamap_default_marker'] = array(
    '#type'=&gt;'select',
    '#title'=&gt;t('Marker'),
    '#default_value'=&gt;variable_get('cambridge_mediamap_default_marker', 'marker'),
    '#options'=&gt;$markers,
  );

  $form['embed']=array(
    '#type' =&gt; 'fieldset',
    '#title' =&gt; t('Default embedded video settings'),
  );

  $form['embed']['cambridge_mediamap_embed_width'] = array(
    '#type' =&gt; 'textfield',
    '#title' =&gt; t('Default width'),
    '#default_value' =&gt; variable_get('cambridge_mediamap_embed_width','320'),
    '#size' =&gt; 25,
    '#maxlength' =&gt; 6,
    '#description' =&gt; t('The maximum width of embedded video'),
  );
  $form['embed']['cambridge_mediamap_embed_height'] = array(
    '#type' =&gt; 'textfield',
    '#title' =&gt; t('Default height'),
    '#default_value' =&gt; variable_get('cambridge_mediamap_embed_height','240'),
    '#size' =&gt; 25,
    '#maxlength' =&gt; 6,
    '#description' =&gt; t('The maximum height of embedded video.'),
  );

  return $form;
}

/**
 * Prints human-readable (html) information about a variable.
 * Use: print debug($variable_name);
 * Or assign output to a variable.
 */
function debug($value) {
 return preg_replace("/\s/", " ", preg_replace("/\n/", "",
print_r($value, true)));
}</code></pre>
