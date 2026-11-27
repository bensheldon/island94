---
link: https://appcasts.io/blog/a-look-at-enumerators-and-laziness
date: 2014-02-19 22:47 UTC
published: true
title: A look at Enumerators and Laziness | AppCasts
tags:
- ruby
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "7bec99845852fd0c"
  vector: "+Ar8BP39BP75AgsDBPn+A/4AAvgJFf4E+vz39gn4AQf4Bg75+fwDAwb99P/6/vn8BAD/C/75B/T4+PgFAvz5/PoDAggNAwED+foF+f3x8/7x9P8HBPT/AxEA+QH/Av4OA/MBAv76Af3+9AL8+AD9Cgb++fgCAQX/CQ8DAwH/+AAG9/4D9wwGAwQH+wX8BwoHAAgABAn7+/8IBvAC8P/8BAQABwAFAfz8+QX9BvYA9AYAB/8EAQf88/4KBAP++/n49QL/BQgB+gP+9gT8AvoEBBD79fsGAQEAAfn3AAX4/wAH9gkDCP8H/gT6+wIOAQUI9PgMBe4B/fv///gF//0E+AEN9gsCAQESBv8EBfv/AAD49wcF9QQA9///+v76BAEEAv3++PwCA/4F+wUJ8voGA+7/BQb7AP4HBAEE+QMR/wD5+f4GCf8KCwP+DAAAAwj+BgT++vwDBPgCAv0G/gIG+v4MCAD8AP0F/P70BgH//PoG/f/3AgH8/wP8AgD++f8H"
---

<blockquote>def data_entries(query_options={})
  query_options[:page] = 1
  results = {}

  Enumerator.new do |yielder|
    loop do
      raise StopIteration if results[:last_page] == true
      results = call_api(query_options)
      results[:data_entries].each { |entry| yielder.yield entry }
      query_options[:page] += 1
    end
  end
end</blockquote>
