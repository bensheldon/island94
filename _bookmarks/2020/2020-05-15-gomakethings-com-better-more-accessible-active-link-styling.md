---
link: https://gomakethings.com/better-more-accessible-active-link-styling/
date: 2020-05-15 15:53 UTC
published: true
title: Better (more accessible) active link styling | Go Make Things
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2a6f4ee3922bab9e"
  vector: "+v4CBw/6C/z9BvwO/AAGAf4BAwIBAAMC/vYK//v4/v399ff0AQP+/AT8BwEC//UDAQX89wL5Ag34/AAKCwQG/ggECvz5AgH3BgMD9QYD/wP3/vgCCQkA+P4CA/0B+v/9/AL2AwgEDAUAAgoM/AkB+f34+PoB/A8FBQIC/Qj7AgAEBvsBAQD5+/YIAg8AB/z7BPjxAPgBBAEBB/z/8AX///wB/AL2/gn3/P4GBvgKBvn8CgH6/wH4/PQLAv8G/Pz79Qj5AQT0BgkJCvoA+PUD/wL5/gsK+v4B/QD//wEA+gAKBvwE7v4HA/4CEA//AgEC/gMBBPv7/v4F/g0B9/YEBQH3AwgA/QL/BQAC/PwK//zyAQf6Dvf5BfEL/QkGCfj8+v7+BwL9BQD5/Pn1D/z9+gT8/vEACPn7/Pj7A/AA6QAECwf3BAv/BPsDA//+AAoM+gX4Av4H/Q37AfkDCf8BCQD1+gP6+wL6/fsBBfcEBfn6+wEBBgX8+gcF/AMLCPQF"
---

Until this morning, I always styled the current link in my navigation menu by doing this.
<ul class="nav"> <li><a href="https://example.com/about">About</a></li> <li class="active"><a href="https://example.com/articles">Daily Tips</a></li> <li><a href="https://example.com/resources">Learn JS</a></li> </ul>.nav .active a { border-bottom: 0.125em solid #fa7176; color: #272727; } It gives users a clear visual indication that “you are here.”
Well… sighted users, that is. If you’re visually impaired or use a screen reader to navigate the web, it tells you nothing.
