---
title: "How to programmatically upload attachments to GitHub Issues, Pull Requests, and Comments, finally, for now"
date: 2026-08-03 17:00 UTC
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "4345ad6b96c63451"
  vector: "9/r8BQnz/gT+BgcGCwoDBwIA/gX7/Qb5CPT6/f/9Cfj4AgMPCf8A/QX/AfwB/wj7+v778gYH/ff6BP0IBP34AAUJAwL48AH67v8EAv8L//cI9wwLAg0BDAAAAAEE/g/6+wD4Bv0DAfYCBwAAA/36/Pn1/wv/AwLxEAb6AQX4/AAFAwkH+/j+9/j8/AoCDPcA9gQMC/f49wEF/wcBCP/5AwP++fP2/wABDAD1BwL8BvwGBgkDBvr+/wIBAP8FAAD/AP/8CQEH9gz4+P7xAQcKBQT2//77AwH69QALDfkEBQAD9/oNBAgLAAgBAQXz+f359/r++wYHEQH+BwD9BP0A/vj+BAICEQT+AAD4BgT++P78CPz+AAEFAAL/+gT++f77/P39/fQMBv4E9AoDAvj2APkLAQUEBPsHB/r4AQsIAQAAAfb89gH9AgX6Av79Bv/9Bv4A9fv8BPj5/vwI9vgF/Pz6+P74+wH3BgP+/gEDCvz8AQP9+BEG/QYADwYA+gcD"
---

It’s possible to programmatically upload images to GitHub Issues, Pull Requests and Comments via automation. Finally, though maybe mistakenly, I dunno.

It’s fairly well known that for the longest time, [GitHub has not had a programmatic interface for uploading images and attachments](https://github.com/cli/cli/issues/1895). It’s possible in the browser, by dragging-and-dropping your image, but not via something you can script or curl. That’s been a bummer for lots of GitHub Action-powered systems you might imagine, like: automatically attaching demo screenshots or videos on PRs for new features, or attaching failure screenshots or visual diffs from browser tests.

Until now, I guess. Here’s the unofficial, undocumented endpoint:

```shell
FILE=cat.jpg
MIME=image/jpeg
REPOSITORY=bensheldon/good_job
TOKEN=$(gh auth token)

curl -s "https://uploads.github.com/user-attachments/assets?name=$FILE&content_type=$MIME&repository_id=$(gh api "repos/$REPOSITORY" --jq .id)" \
  -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json" --data-binary "@$FILE"

# that outputs a JSON response containing the attachment URL, which you can then embed in an image tag into the GitHub content.
```

That’s it! I mean, you can be more clever than curl or whatever, but that's the idea. It's equivalent to dragging-and-dropping an image into an Issue, PR, or Comment.

I don’t know if this endpoint always accepted an Auth Token and no one tried or noticed or talked about it, or if that’s new. My memory was that this endpoint _only_ previously accepted Cookie Auth: circa 2018 I explored different Visual Diff services and the lack of a programmatic API for GitHub attachments meant that to DIY you’d have to use a service like S3, and then a service to authorize S3, and that's annoying to set up when GitHub Actions could do everything else. I’m pretty sure I tried to fuzz the attachment interface at the time and it didn’t work.

I recently learned all of this was possible because [Justin Gordon of Shakacode](https://shakacode.com/) shared a link to [Intercom’s 2x-skills `attach-github-assets`](https://github.com/intercom/2x-skills/blob/59213af0a2db9321ef10355ff24e9bd619151b6b/plugins/pr-tools/skills/attach-github-assets/SKILL.md) and I was... skeptical... and then I tried it and it worked!

![Ben Sheldon asking Claude to use the attach-github-assets skill to upload a placekitten image as a comment to a GitHub issue, and Claude successfully doing so](/uploads/2026/github-attachment-upload-demo.png)

It's very useful, I hope it doesn't go away.
