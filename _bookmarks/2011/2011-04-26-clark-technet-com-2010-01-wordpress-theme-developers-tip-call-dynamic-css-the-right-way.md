---
link: http://clark-technet.com/2010/01/wordpress-theme-developers-tip-call-dynamic-css-the-right-way
date: 2011-04-26 19:44 UTC
published: true
title: WordPress Theme Developers Tip – Call Dynamic CSS the Right Way | Jeremy Clark
  - TechNet.com
tags:
- wordpress
- development
- webdesign
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "d44f22aac6332e39"
  vector: "/g/6BwYDCgQD/vwLA+4CAP4A+goCBv4G+P//BQT8A//9/foCA/n9//kF/AYB/gAA9P7+/ff+BAP//gEG+/4FBwgB9QoA/Pn++wQJAv/99/QE/gcCEA/7+Qv++Pj3/QQF/vQPBPn9BAQBAAcOAPUD/fzzBvoM9gT/Ef/9+//7BwAD9vz+BQAHAvsNAv0DCP4LAfwF+QEDBAX+CQQI+fsK+P8CBQD5/wUGBQECDAL99gP4+/wOBgX//vT7+gAD9/74APcJBADyBQIB/Qb9+/4K/P8DAgcE/wL3BgL/BQD5/wADA/kH+Ab9/wf+Awj/AQIH8f38AfUCBv37/vkA+Az9APUDCfny/f0FBf0G/voE+wD++gb7/gIEAPkF9Q4OAADx+f/8/Ar++f8A//kJC/sCCwIB+fcA+fMG+fX8BAQF+AD7AgYA9gwK/vf9CPgSCO/2BQH19/YN/gEEB/4C/AQFAPoI/Qr9AgT+Af4EBvzyB/0ABAD0AwUG+QcNAAbxAAID"
---

While developing my Techozoic theme, I’ve progressed from adding custom CSS into the head section, to having an external file and using $_GET variables to pull options from the database, to now I believe is the right way to do it, using add_filter and a custom query in WordPress. By using this new method I’ve done away with unsafe $_GET variables and can now use any builtin WP functions in the external file.
First you’ll need to edit your functions.php file and add this block of code.

add_filter('query_vars', 'add_new_var_to_wp');
function add_new_var_to_wp($public_query_vars) {
    $public_query_vars[] = 'my_theme_custom_var';
    //my_theme_custom_var is the name of the custom query variable that is created and how you reference it in the call to the file
    return $public_query_vars;
}
This sets up WP to now accept a new variable in a query called my_theme_custom_var the format of the query would be http://www.yourblog.com/index.php?my_theme_custom_var=css . The ? mark tells WP that this is a query and the = sign tells what the query variable should be set to.

Now to actually setup the function that will call the external file. I found this gem when looking at how popular WP theme called Atahualpa handled it’s external CSS.

add_action('template_redirect', 'my_theme_css_display');
function my_theme_css_display(){
    $css = get_query_var('my_theme_custom_var');
    if ($css == 'css'){
        include_once (TEMPLATEPATH . '/style.php');
        exit;  //This stops WP from loading any further
    }
}
This code now will check if a query is passed to WP with the value my_theme_custom_var and if it is and has the value of css then it includes the style.php file which is our dynamic CSS file. Then the code exits which stops any other functions from happening other wise the whole home page is outputted along with the style.php file, which isn’t what is needed only the file.
Now you can use any WP functions on the style.php file as it is included from the functions.php file which is a standard WP file.
Source : Will Norris
