---
link: https://groups.google.com/forum/#!topic/cloud9-ide/uaKRtlIxi4U
date: 2012-02-10 06:49 UTC
published: true
title: 'Cloud9: Node.js Environment Variables - Google Groups'
tags:
- nodejs
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "02a736e1193a0a54"
  vector: "AP0AAgX4AAL5Av3+BfkGAAD5AgEBBAcC/vj+BgMC/wfyDgARAPL4AAsE/fwJBvwC+f4I/PX6BAcCAAMFAvsG/P4I/wMF+wIH9fL0Afr9+gIB/gAK+PwI/AgA9vr7+wMKAAID/QUABwEC9f8AAP/9Cgj8/fwJ+gYMCQAJAAUHAAAB8AcJCAH8A/T99QP7/wAGAwcL/fn7+/0D+fsDAfgO/PkL/QL7BPQHBgb7/QP+AfAG+vj/CfoI+gT3+vn8/vQDA/79Agn+AfsA+wEE+An0+gkC8A//AAP7Af/8/wn3+QD+/f0GCf0I+QUCAP4IAPUD9vwCAvwGEAX+APf99P31Cv0J9fH9FAoFCAP5/wIJC/v1Af38AP8GBQD8BAEJ9AH88AH3CAn77f0AAAMA+/cFDfwE9vsF9v0KBQf1Bfn+9QAABf0A/f4LAgwK/f79Bfz+BAH/Af0G/QoEAQP6/QT7AvwA9wD+BwwGAgcA/f33CwUFCwb8/QgK+vz//AX6BgT3"
---

Here's how I would do it... I'd have a config file that's always loaded in my app,

config = require('./config')(express)

Then I have my config file which has something like:

module.exports = function(express) {
    var host = 'yourhost.com'
    var port = '1234'
    if (process.env.C9_PORT) {
         this.db = createClient( host, port, '213j23jk4hhjlks99wi3');
    } else if (process.env.NODE_ENV == 'production') {
         this.db = createClient( host, port, process.env.DB_PASS);
    } else if (process.env.NODE_ENV == 'test') {
           // test db or mock db connection
    } else {
          // maybe local db settings?
    }
    
    return this;
};

oh and I just passed express because when I did something like this with a config file, I had some additional server configuration that needed it
