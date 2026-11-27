---
title: "Frontier novelty"
date: 2026-01-25 20:08 UTC
published: true
tags: [quotes]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "b0e44feab572c50e"
  vector: "B/j6+P7+Af0EBQADBQX9AgoB//3+9wT5/AT/Bgb7DBEFBQcG8wcC9f34AwYFBv/9Bfz99QH5/QYHBP/9BAQG/QIH9Ar9/gsCBggEAP/6B/f1APwI/AP9AQz7AfcM/gn+/fj8Af3/BP4H/Qj/BPn3AAgC+PsBAwn+Bv75BQMA/QACDAEKDvEGBQYK+P77DAz7/P/9/P35A/P7Bf39CQH4Bv4E/gT9/PoF/v4CAwQCA//++QMI/foE8wH4BAUAA/8LAAYABg4C+wMAAAL++Pn+8wT+8gP/+wf6/QDy+QEH9gDw9vQE+vgA9wQC8v8G+wP//v8BBwkA8v0HC/r/Aw35/gMC/AQCAP37//v6Dfn9+gb0AvsE9Pf7Cv8AAQf99AD9BP7+CP79BQD3A/4DAwD6A/f6BwoECfoDAQEFBQME+ADyAQMB/+/+/fj5A/z0BA4EBQf3BQUH+vz4/O39AggMCQgJBQcF+/76A/f2AQ8DAvME9gD/AAcT+fv8CgUDD/n6"
---

From Benji Edward’s [“10 things I learned from burning myself out with AI coding agents”](https://arstechnica.com/information-technology/2026/01/10-things-i-learned-from-burning-myself-out-with-ai-coding-agents/) describing the challenge of maintaining novelty during AI coding:

> Due to what might poetically be called “preconceived notions” baked into a coding model’s neural network (more technically, statistical semantic associations), it can be difficult to get AI agents to create truly novel things, even if you carefully spell out what you want.
> For example, I spent four days trying to get Claude Code to create an Atari 800 version of my HTML game *Violent Checkers*, but it had trouble because in the game’s design, the squares on the checkerboard don’t matter beyond their starting positions. No matter how many times I told the agent (and made notes in my Claude project files), it would come back to trying to center the pieces to the squares, snap them within squares, or use the squares as a logical basis of the game’s calculations when they should really just form a background image.
>
> To get around this in the Atari 800 version, I started over and told Claude that I was creating a game with a UFO (instead of a circular checker piece) flying over a field of adjacent squares—never once mentioning the words “checker,” “checkerboard,” or “checkers.” With that approach, I got the results I wanted.

I’ve experienced something similar in my own AI-assisted game design. In my case, it’s my perennial desire to have a Simcity-like city builder that operates on “parcels” rather than tiles or zones and, oh boy, the LLM really chafes at it. Is it weird _enough_ to work?
