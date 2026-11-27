---
link: https://arstechnica.com/information-technology/2026/01/10-things-i-learned-from-burning-myself-out-with-ai-coding-agents/
date: 2026-01-19 17:58 UTC
published: true
title: 10 things I learned from burning myself out with AI coding agents
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "457eee3d02a717ad"
  vector: "AgX+//gE/QkB/QD+BwYDAwb//voA/gX4/wYA/gj+Cgr/BAYC8wgI+/34CAgHAPwDCfXt9/z8/wH8AP/3A/7+BAIH/f4CAgoI/wUA+/34CP72+v8MAwYEAgP++/z/AwgN/fUKDAD6APcDAAkFAfb2AQMJBPoECQkADQf8CfwB/QD/DBAMBfT8AgoI/AP/BwP+/wb0Af76CPv/BP33BQIACvX8/P4D+wMF+gMG/goABAH7AP8GB/v/+fz6AwkH/gEH+QH8AAUB/AIAAf768/P99AcD9vsG/wT8/wDqAQMA+AD4AvX7BPz/9w8M/gMA+AH7AvcCBfwQ9AAJBwcBAAYB8vn5+AcF+vsBAfnzAvr9Agn9CAAB9fb4+QQCBAr1/P4CAfj2Df0AAwX7CwX++AAABPb7BwMBCf32BQH9AwgG/gD8+w8M/gL2BPXxBf38CwoEAQL0AQQK/ff+/vL89wYDBP4EAQL//QL9AAMAAAwCBPIJ/P/5/wcT9QEB/QkFB/j9"
---

Due to what might poetically be called “preconceived notions” baked into a coding model’s neural network (more technically, statistical semantic associations), it can be difficult to get AI agents to create truly novel things, even if you carefully spell out what you want.

For example, I spent four days trying to get Claude Code to create an Atari 800 version of my HTML game Violent Checkers, but it had trouble because in the game’s design, the squares on the checkerboard don’t matter beyond their starting positions. No matter how many times I told the agent (and made notes in my Claude project files), it would come back to trying to center the pieces to the squares, snap them within squares, or use the squares as a logical basis of the game’s calculations when they should really just form a background image.

To get around this in the Atari 800 version, I started over and told Claude that I was creating a game with a UFO (instead of a circular checker piece) flying over a field of adjacent squares—never once mentioning the words “checker,” “checkerboard,” or “checkers.” With that approach, I got the results I wanted.
