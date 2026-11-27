---
link: http://wordpress.org/support/topic/assistance-changing-author-permalink-url
date: 2011-05-03 13:14 UTC
published: true
title: WordPress » Assistance Changing Author Permalink / URL
tags:
- wordpress
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "6622f1f5cc6b5897"
  vector: "BAkL//r+9/34BPoB/P/1E/MTAw0B/f78B/UDBv73Av///wID/QUAAgID9wT7AgH/+wX4+ff3AP//CwMAC/kD+wEC+/33AAgD/f8E+foGAPoSAQX4DwMD/P8AAQIO+f/3/f4AA/wC+vkMBgkP9f4G//cA/vr4BgH8+v/9Bvb+BAACDvr6AP8A//34CPUCA/L7BfsE/gAM+wX7AwH5BAD+BgP9/wIK//kC///5+/kJAwULAfj9BAn+//D++AECAgEE+v79/wYC8AIAAeT/9v8EBPkCB/4A+/4BAQoMBf0I/gAC+QINAgAK/wj+//sF/gH4/AT0AvX/A/X+CwoCA/8BBwH1Cwnx/gcFCAgFAAYI/u/9/wb/B/YB/gf7+g35/wUJ+wH+Avv7//0BBAb3AwEF9/oB//38Af4BAAgGAgL3/AD79wYLBQYH/wwF/AAJ+//xBAUA/vIAA/gB/vr49Qb8C/sFAQj9BfkK/wUB/vXxCAQABQQFAPIJA/wG9/4B+P/6"
---

function change_author_permalinks() {

    global $wp_rewrite;

    // Change the value of the author permalink base to whatever you want here
    $wp_rewrite->author_base = 'artist';

    $wp_rewrite->flush_rules();
}

add_action('init','change_author_permalinks');
