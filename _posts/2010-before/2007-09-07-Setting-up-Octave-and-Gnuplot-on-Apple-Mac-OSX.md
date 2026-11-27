---
title: Setting up Octave and Gnuplot on Apple Mac OSX
date: '2007-09-07'
tags:
- computations
- geeking
- osx
wp:post_type: post
redirect_from:
- node/151
- setting-octave-and-gnuplot-osx
- 2007/09/setting-up-octave-and-gnuplot-on-osx/
- "?p=151"
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "9793864c8e1d1157"
  vector: "+/v/8vQA9gH9/QT1AwIFAfv6Av4F+f4ACQUDBgQGAwT//fn5Av/yAwAHAQMD8gL6AwEA/gECAAD89gr49g4BBvv8/wL/Bv35Bfr4AgD59v3/BfUM+gEECP4CBQbzBP8DCAMA/P/1CwYAAgcIAQD+/fwJDQ38+Pz+AQX+CwcA+AAEAf74AP30Av0L/w78CPv6Df/z+wD//vv3FQkCCQQBAQL5AP3/BQcF+gALBgsD/gQHCvz//Ar9BwH88QT8BwD49wH6+PsS8gcIAgX9Bgf3A/n/A/YC/goM/Pr8AAX8+AD8AwQG/ggIAQP9+gMF/wv9/gP19fcEBf0G+wv7//74BvjyAgkD//H4APj9+f4OAwgABQT+Cf8H9v4C+vv1/ATx+/b/8wYEAQT7/QID8Pj8AxQQCAUB//kIA/4BAPMB/gAECwIFAAUG/gEDAwL9/vUFAvwE/vsE9QL5/AEE+QQD9/cFCPr2DAX9/AcD+vsFAv8ACQL/9/j8//z0+AD5/AH9"
---

I just started auditing a Mathematical Models in Biology class and Matlab is one of the requirements. I had relatively good experience with the free, open source alternative, [Octave](http://www.gnu.org/software/octave/) back in college, but then I was running Linux, not OSX. It took me about an hour to figure out how to set it up (I was a little worried for a bit).

1. Download the Octave binary for OSX from [Octaveforge](http://sourceforge.net/projects/octave/files/Octave%20MacOSX%20Binary/2009-10-03%20binary%20of%20Octave%203.2.3/).

2. Install Octave and Gnuplot (in the extras folder). I just dragged them to /Applications (X11 is required for Gnuplot---should be found on OSX install disk)

3. If you are using OSX 10.6 (Snow Leopard) or 10.5.8+ you may need to perform some additional steps [outlined here](http://sourceforge.net/projects/octave/files//Octave%20MacOSX%20Binary/2009-10-03%20binary%20of%20Octave%203.2.3/README_OSX1065.txt/view)

4. Set the environment variable for gnuplot (Octave is supposed to do this automatically, but it didn't for me): `

sudo ln -s /Applications/GnuPlot.app/Contents/Resources/bin/gnuplot /usr/bin/gnuplot

`

(thanks for the help, [Toby](http://island94.org/setting-octave-and-gnuplot-osx#comment-3654))

5. Download and install (again in /Applications) [Aquaterm](http://sourceforge.net/projects/aquaterm/) which will actually render the gnuplot graphs.

6. Within Gnuplot, set the renderer: "terminal aqua"

7. Try it out in Octave (I had to restart Octave and Gnuplot to get it all to work): `

x = linspace(-pi, pi, 100);

y = sin(x);

plot(x, y);

`

Thank you: [High Performance Computing for Mac OS X](http://hpc.sourceforge.net/), [the Octave Wiki](http://wiki.octave.org/wiki.pl?MacOSXIntegration) and Google for helping me find what I needed.

_**Update (January 24, 2010):** updated the link in step #1 to the latest version of Octave. Added an additional step described by [Zack in the comment](http://www.island94.org/2007/09/setting-up-octave-and-gnuplot-on-osx/#comment-80303)s (thanks!)_
