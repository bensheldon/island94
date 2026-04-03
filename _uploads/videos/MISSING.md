# Missing blip.tv videos

These videos could not be recovered and their posts still contain broken blip.tv links.
The Archive Team WARC archives for blip.tv are restricted on archive.org.

| Post | File needed | Original blip.tv URL |
|------|-------------|----------------------|
| [2007-02-26 The Future of Cable Access](/_posts/2010-before/2007-02-26-The-Future-of-Cable-Access.md) | `bensheldon-whatisthefutureofcableaccesstv720.mp4` | `http://blip.tv/file/get/Bensheldon-WhatIsTheFutureOfCableAccessTV720.flv` |
| [2007-02-28 Self-photography](/_posts/2010-before/2007-02-28-Self-photography.md) | `bensheldon-selfphotography203.mp4` | `http://blip.tv/file/get/Bensheldon-Selfphotography203.flv` |
| [2006-07-13 Two two two yolks in one](/_posts/2010-before/2006-07-13-Two-two-two-yolks-in-one.md) | `deaner-2xyolk193.mp4` | `http://blip.tv/file/get/Deaner-2xYolk193.mp4` |
| [2008-08-29 Radio Ga Ga 2](/_posts/2010-before/2008-08-29-Radio-Ga-Ga-2-The-role-of-nonprofits-in-constructing-a-better-world.md) | `bensheldon-thinkingoutloud152.mp3` | `http://blip.tv/file/get/Bensheldon-ThinkingOutLoud152.mp3` |

Once you have a file, drop it in `uploads/videos/` and replace the broken blip.tv markup with:

```html
<video src="/uploads/videos/FILENAME" controls></video>
```

(or `<audio>` for the mp3)
