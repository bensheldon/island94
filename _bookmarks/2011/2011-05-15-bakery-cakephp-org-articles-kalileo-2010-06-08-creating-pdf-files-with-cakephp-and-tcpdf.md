---
link: http://bakery.cakephp.org/articles/kalileo/2010/06/08/creating-pdf-files-with-cakephp-and-tcpdf#
date: 2011-05-15 19:05 UTC
published: true
title: Creating PDF files with CakePHP and TCPDF | The Bakery, Everything CakePHP
tags:
- cakephp
- webdevelopment
- pdf
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "6c307216b8638308"
  vector: "AwP0+QAH/fr//Ab5+wb8+AL1AQP7+Qj5/v73//r6Bgv7/QEBBwQF//33+gD8AwMEAv76DAQCCPT+CvQA8gYABQT//AcBAu8D+wQEBwUD9/kECwkDA/8EAv38CQkCC/f4CP3+BPn9Bvb2/gMCBfsC9Pnv9//t9vn++Pj0DPj6/wACBgECDPkGAPn+Af71BPwB8AMHBP0GAQH+DwL9AQANAAP4/Pj8+PcHAwEDCAH3/PwC+PwGCQcF/vn1Av7//vX09/j9Aw7/AQUOAwUIBgMP/gEBA/kBAf0D/gEAAgz/BAD+APEIBgEFAgT89/v/9/7wAv4CBPgFAgYJBAIC+wL+AgAM+v7+Df0LAAH++AQG/AMCAAMC+vEDB/78/wUBAg8E/wT/BQYB/vsDBgYBBwkHBvwDAf0IAv3vAP4CFQgDCgAK9vj9Bf4EAPn9BPn/+AH7DAf2+v4IAAD7AgD8+/z4+/oBBAfyAPP6Ef/++Av8Bv79AwsFBP7/AwIFDP7/AgwH"
---

With CakePHP 1.2 creating PDFs with CakePHP has just gotten a lot easier. This tutorial shows how to combine CakePHP and the powerful TCPDF for easy PDF file creation.
TCPDF is an Open Source PHP class for generating PDF documents. It continues where FPDF stopped, and contains all its goodies plus support of UTF-8 Unicode and Right-To-Left languages! Especially the missing UTF-8 Unicode support in FPDF is a problem for everyone living outside the English language only countries.
