---
title: Boston's Best Tacos
date: '2007-01-05'
tags:
- community mapping
- food
- map
- tacos
wp:post_type: post
redirect_from:
- 2007/01/bostons-best-tacos/
- node/115
- articles/bostons-best-tacos
- 2007/01/bostons-best-tacos/
- "?p=115"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2e34de7c166d447b"
  vector: "EfwHAPX+AvUA9A34Afv//Q37CPoB+AAI+wQHCPT59gL5/wABBP8SBfn2CAL++/4GAQL3AP/5/wH1+wUDAP/5Af739Aj+/gT9CgcAA/r49gH8Bv8G//wCAQn+Cwj3/Af+/gP9AgEFBPwDA/r+Bvr8Bfv/9QAH/Qr9/wb6/fsGBQAAAwIDEfj0+fgFAPn3CgMLBvv19/oBBvz4D/z9/wMAB//7AAMC+fkG/wMDC///AwMDBvz7+wH1+f4CBv//Awf+Bv0A+w0CBAERBgMC+P8H/gD++wQAAwfzBAbvDfvz9gAI9gQE+PUCBgb+9PoMAAcKCwf49/oL/QwBAAP59/n9AAgC+A0BB/4RAfj5///+/f/5AQkA9AALAPz3/Pj3B/4DFAH59wQDAgT6+QEA/wb5AAT3BAoDDf4D/ggECvYD/wAF/vYK/v4DCf4M/wH9APv+AwX5BvkO//gC+/wI//0DAP7+/vj4/AH+//fz/wP9AQUBBPEAB/8E9wIDCQIGA/j2"
---

$mymarkers=array(

array('markername'=>'number01',

'label' => '**Tacos El Charro**

349 Centre St

Jamaica Plain, MA 02130',

'latitude' =>'42.32269914619183',

'longitude'=>'-71.10684156417847'), array('markername'=>'number02',

'label' => '**Tacos Lupita**

13 Elm St

Somerville, MA 02143',

'latitude' =>'42.38600050368276',

'longitude'=>'-71.11351490020752'),

array('markername'=>'number03',

'label' => '**Takueria Tapatillo**

82 Broadway

Somerville, MA 02145',

'latitude' =>'42.387038609014645',

'longitude'=>'-71.08207941055298'));

$mymap=array('id' => 'tacomap',

'latitude' => '42.36031976410849',

'longitude'=>' -71.0757064819336',

'zoom' => 12,

'width' => '100%',

'height' => '400px',

'type' => 'Hybrid',

'markers' => $mymarkers);

print gmap\_draw\_map($mymap);

?>

I miss eating good taqueria food and Boston's inhibited palette is definitely to blame. I like places that call the tacos by name, Carne Asada, Al Pastor, Lengua--not Beef, Pork , Chicken (Lengua isn't chicken, but your anglo-taqueria isn't going to have it, or call it what it is: _beef tongue_); where the salsa is more than pico de gallo and you get a slice of radish. The map above has the few places I've found in Boston that I like.

They are:

**#1) Tacos El Charro**

349 Centre St

Jamaica Plain, MA 02130

_Super friendly sit-down restaurant. Also the enchiladas are great. Go downstairs, it's "authentic"!_

**#2) Tacos Lupita**

13 Elm St

Somerville, MA 02143

_Close to Porter Square. The food is delicious and they have imported Coca-Cola made with real sugar, not corn syrup._

**#3) Takueria Tapatillo**

82 Broadway

Somerville, MA 02145

_Actually Chilean but excellent taqueria. They have a good vegetarian taco too. Was taking an unrelated cab and mentioned the place to my friend. The cabdriver overheard and said that he went there all the time. The cabby looks European but is really Brazilian and fluent in Spanish. He said that when he goes into the taqueria, the staff speak to him in English until he starts belting out Spanish. They are so impressd his lunch is free._
