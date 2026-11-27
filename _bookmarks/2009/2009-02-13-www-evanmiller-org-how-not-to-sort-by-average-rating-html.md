---
link: http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
date: 2009-02-13 12:35 UTC
published: true
title: How Not To Sort By Average Rating
tags:
- programming
- development
- web
- mathematics
- math
- usability
- statistics
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e593e8206cf8a55c"
  vector: "/gH+C//6AA8AAvwADf/6Agj/+wcFBQj7BvP7BgX8+wcJ//v3APkDAAcKAQPxBf7/+wT0DwD3+f778Pz/BPn++wP+BPv+AvoC9wL/Afz19gUB/P0ACfcGAwYIAQL6Bv4D/vr7C/0BA/AC/P//Af/7Av4ABwkCEwP8CA0DAwAL/wAC/QcA/RL79/38CwMG9QX6//39/AT+AgAA+/r9BP39AQX0BPsCBwL9AQL6Bf/2AAr6A/f6Cw36+/8G/vAGAQT0CQn/APwHAQj7/voCAwgB+wACB/z+/Q4J+/L+9AL++wD3/wYIA/T/9Pz5+PoC+hP/+wwB/QcDAQoAAAX++Pf8/gL9+fX9/v4JAfz4+QEGAPn7AAEN+BABAvUIBQT/Bvr8/QAEAv0C/AsR/PwIAAwCAvgDAPsC+RT9/QMC/g/4AwAL+/cMBxT2+PsECv7/+wAC/gT///z/A/z9Cf72/PwE+wX8Awr6/gID/fv/AAf//wII/wIG/v/8CvwC6fkE+/kD"
---

CORRECT SOLUTION: Score = Lower bound of Wilson score confidence interval for a Bernoulli parameter

Say what: We need to balance the proportion of positive ratings with the uncertainty of a small number of observations. Fortunately, the math for this was worked out in 1927 by Edwin B. Wilson. What we want to ask is: Given the ratings I have, there is a 95% chance that the "real" fraction of positive ratings is at least what? Wilson gives the answer. Considering only positive and negative ratings (i.e. not a 5-star scale), the lower bound on the proportion of positive ratings is given by:

(For a lower bound use minus where it says plus/minus.) Here p is the observed fraction of positive ratings, zα/2 is the (1-α/2) quantile of the standard normal distribution, and n is the total number of ratings. The same formula implemented in Ruby:


require 'statistics2'

def ci_lower_bound(pos, n, power)
    if n == 0
        return 0
    end
    z = Statistics2.pnormaldist(1-power/2)
    phat =
