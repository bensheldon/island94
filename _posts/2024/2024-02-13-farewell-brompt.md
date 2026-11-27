---
title: "Farewell Brompt"
date: 2024-02-13 17:49 PST
published: true
tags: [Brompt]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "ab499f2bb476e5af"
  vector: "+vsEAwEFBAIG8/0F+/7+Bvf/9/kB7wEFAgAC/gL5CPr++/z/9QEF/voG+v0MCPwHAwz69fwAAQUE/Az8/wIAAwT6/AD+CAcHCQz/+/sFAAUA+goMAgwB/wIA+gz2B//8A/T3CQH3BQP8+/8B/wT8AgAC+gUB+wz6FAj2+P39CgAE/P0KBwP5APD8Av/5+wTvEAX9Avz79Qf5DPoL8QEHCvUI+fj4/P8AAP/9AAD8BQICCv4LA/kIAQT99/oEBAL6/v71//8D/f4H/PsB+/3/9wb7AfQG+gUA+gf1/AwD+gD5CfgJ9gv+BAQF/gf8BvsQAv/4+/4G+f39CwgBAv71+AIIA/MI+wT4B/0D+/0LBAP8Avb4AgD9AP36AwP8+wP+BwX3BAUAAA4I9QD7Dfz8+gIEAfsA/fUFBAL9Chb6BwD4+/v7BQEE/v7xCAoK+wP99P8BAQD9BwL4+PsDAAPvBAf++vr5AAQCCgX9BAT+AvcCCfMEBwAE/f4E9wf4Cvz7"
---

I'm planning to shut down Brompt, which I previously wrote about in [2008](https://island94.org/2008/04/Brompt-is-a-blog-reminder.html), [2011](https://island94.org/2011/03/A-form-from-my-favorites.html), and [2022](https://island94.org/2022/09/reflections-on-brompt-2022). I [archived the code](https://github.com/bensheldon/brompt-archive) on GitHub.

Let's do a final <a href="#" onclick="event.preventDefault(); c = Confetti(); c.initialize(); c.drop();">confetti drop 🎉</a> together.

<blockquote markdown="1">

Farewell 👋 Brompt is shutting down

I have some sad news to share: I’m planning to shut down this service, Brompt, at the end of the month (February, 2024).

Shutting down Brompt means that you’ll no longer receive these automated reminders for your blog or writing. I’ve been running Brompt since 2008 and unfortunately, I haven’t been able to make it sustainable. You’re one of about 80 people who are still using the service, though I’m never sure if you or anyone ever opens the emails regularly.

Regardless of Brompt shutting down, I hope you’re doing well and I’d love to stay in touch. Send me an email at bensheldon@gmail.com or read my own blog at https://island94.org

All the best,

Ben (the person who made Brompt)

</blockquote>

[![Screenshots from Brompt](/uploads/2024-02/brompt.jpg)](/uploads/2024-02/brompt.jpg)

<canvas id="canvas" style="
    display: block;
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1;
    pointer-events: none;
"></canvas>

<script>
// https://jsfiddle.net/hcxabsgh/
// Usage: window.confetti.drop();
window.Confetti = function () {
  // globals
  var canvas;
  var ctx;
  var W;
  var H;
  var mp = 150; //max particles
  var particles = [];
  var angle = 0;
  var tiltAngle = 0;
  var confettiActive = true;
  var animationComplete = true;
  var deactivationTimerHandler;
  var reactivationTimerHandler;
  var animationHandler;

  // objects

  var particleColors = {
    colorOptions: ["DodgerBlue", "OliveDrab", "Gold", "pink", "SlateBlue", "lightblue", "Violet", "PaleGreen", "SteelBlue", "SandyBrown", "Chocolate", "Crimson"],
    colorIndex: 0,
    colorIncrementer: 0,
    colorThreshold: 10,
    getColor: function () {
      if (this.colorIncrementer >= 10) {
        this.colorIncrementer = 0;
        this.colorIndex++;
        if (this.colorIndex >= this.colorOptions.length) {
          this.colorIndex = 0;
        }
      }
      this.colorIncrementer++;
      return this.colorOptions[this.colorIndex];
    }
  }

  function confettiParticle(color) {
    this.x = Math.random() * W; // x-coordinate
    this.y = (Math.random() * H) - H; //y-coordinate
    this.r = RandomFromTo(10, 30); //radius;
    this.d = (Math.random() * mp) + 10; //density;
    this.color = color;
    this.tilt = Math.floor(Math.random() * 10) - 10;
    this.tiltAngleIncremental = (Math.random() * 0.07) + .05;
    this.tiltAngle = 0;

    this.draw = function () {
      ctx.beginPath();
      ctx.lineWidth = this.r / 2;
      ctx.strokeStyle = this.color;
      ctx.moveTo(this.x + this.tilt + (this.r / 4), this.y);
      ctx.lineTo(this.x + this.tilt, this.y + this.tilt + (this.r / 4));
      return ctx.stroke();
    }
  }

  // $(document).ready(function () {
  // SetGlobals();
  // InitializeConfetti();
  //
  // $(window).resize(function () {
  // W = window.innerWidth;
  // H = window.innerHeight;
  // canvas.width = W;
  // canvas.height = H;
  // });
  // });

  function SetGlobals() {
    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");
    W = window.innerWidth;
    H = window.innerHeight;
    canvas.width = W;
    canvas.height = H;
  }

  function InitializeConfetti() {
    particles = [];
    animationComplete = false;
    for (var i = 0; i < mp; i++) {
      var particleColor = particleColors.getColor();
      particles.push(new confettiParticle(particleColor));
    }
    StartConfetti();
  }

  function Draw() {
    ctx.clearRect(0, 0, W, H);
    var results = [];
    for (var i = 0; i < mp; i++) {
      (function (j) {
        results.push(particles[j].draw());
      })(i);
    }
    Update();

    return results;
  }

  function RandomFromTo(from, to) {
    return Math.floor(Math.random() * (to - from + 1) + from);
  }

  function Update() {
    var remainingFlakes = 0;
    var particle;
    angle += 0.01;
    tiltAngle += 0.1;

    for (var i = 0; i < mp; i++) {
      particle = particles[i];
      if (animationComplete) return;

      if (!confettiActive && particle.y < -15) {
        particle.y = H + 100;
        continue;
      }

      stepParticle(particle, i);

      if (particle.y <= H) {
        remainingFlakes++;
      }
      CheckForReposition(particle, i);
    }

    if (remainingFlakes === 0) {
      StopConfetti();
    }
  }

  function CheckForReposition(particle, index) {
    if ((particle.x > W + 20 || particle.x < -20 || particle.y > H) && confettiActive) {
      if (index % 5 > 0 || index % 2 == 0) //66.67% of the flakes
      {
        repositionParticle(particle, Math.random() * W, -10, Math.floor(Math.random() * 10) - 20);
      } else {
        if (Math.sin(angle) > 0) {
          //Enter from the left
          repositionParticle(particle, -20, Math.random() * H, Math.floor(Math.random() * 10) - 20);
        } else {
          //Enter from the right
          repositionParticle(particle, W + 20, Math.random() * H, Math.floor(Math.random() * 10) - 20);
        }
      }
    }
  }
  function stepParticle(particle, particleIndex) {
    particle.tiltAngle += particle.tiltAngleIncremental;
    particle.y += (Math.cos(angle + particle.d) + 3 + particle.r / 2) / 2;
    particle.x += Math.sin(angle);
    particle.tilt = (Math.sin(particle.tiltAngle - (particleIndex / 3))) * 15;
  }

  function repositionParticle(particle, xCoordinate, yCoordinate, tilt) {
    particle.x = xCoordinate;
    particle.y = yCoordinate;
    particle.tilt = tilt;
  }

  function StartConfetti() {
    W = window.innerWidth;
    H = window.innerHeight;
    canvas.width = W;
    canvas.height = H;
    (function animloop() {
      if (animationComplete) return null;
      animationHandler = requestAnimFrame(animloop);
      return Draw();
    })();
  }

  function ClearTimers() {
    clearTimeout(reactivationTimerHandler);
    clearTimeout(animationHandler);
  }

  function DeactivateConfetti() {
    confettiActive = false;
    ClearTimers();
  }

  function StopConfetti() {
    animationComplete = true;
    if (ctx == undefined) return;
    ctx.clearRect(0, 0, W, H);
  }

  function RestartConfetti() {
    ClearTimers();
    StopConfetti();
    reactivationTimerHandler = setTimeout(function () {
      confettiActive = true;
      animationComplete = false;
      InitializeConfetti();
    }, 100);

  }

  window.requestAnimFrame = (function () {
    return window.requestAnimationFrame ||
      window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      function (callback) {
        return window.setTimeout(callback, 1000 / 60);
      };
  })();

  return {
    initialize: function() {
      SetGlobals();
      InitializeConfetti();

      // $(window).resize(function () {
      // W = window.innerWidth;
      // H = window.innerHeight;
      // canvas.width = W;
      // canvas.height = H;
      // });
    },
    start: function() {
      RestartConfetti();
    },
    stop: function() {
      DeactivateConfetti();
    },
    drop: function(duration) {
      RestartConfetti();
      window.setTimeout(function() {
        DeactivateConfetti();
      }, duration || 1500);
    },
  }
};
</script>
