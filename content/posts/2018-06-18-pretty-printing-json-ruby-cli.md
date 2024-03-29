---
title: Pretty Printing JSON on the Command Line with Ruby
description: Using Ruby's JSON module to pretty print JSON objects from the command line.
tags:
- blogumentation
- ruby
- json
- pretty-print
date: 2018-06-18T19:13:49+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: pretty-printing-json-ruby-cli
series: pretty-print-json
image: https://media.jvt.me/00fdea0d32.png
---
This is a follow up to the popular post [Pretty Printing JSON on the Command Line with Python][pp-python-json] that uses Ruby to perform the pretty-printing.

Given the following minified JSON file that we want to be able to inspect:

```json
{"key":[123,456],"key2":"value"}
```

Let's use the following pipeline to output it, taking advantage of [`ARGF`][so-stdin], which is a file descriptor that points to `stdin`:


```bash
$ cat file.json | ruby -rjson -e 'puts JSON.pretty_generate(JSON.parse(ARGF.read))'
#                                                                      ^ read from a file
#                                                           ^ parse a JSON string to a Ruby Hash
#                                      ^ pretty print (https://stackoverflow.com/a/1823885)
#                                 ^ output to stdout
#                        ^ require the Ruby JSON module
# ^ useless use of cat, use recommended pipeline(s) below instead:
$ ruby -rjson -e 'puts JSON.pretty_generate(JSON.parse(ARGF.read))' file.json
$ ruby -rjson -e 'puts JSON.pretty_generate(JSON.parse(ARGF.read))' < file.json
{
    "key": [
        123,
        456
    ],
    "key2": "value"
}
```

To see this article in action, check out the asciicast:

<asciinema-player src="/casts/pretty-printing-json-ruby-cli.json"></asciinema-player>

Note: You can use [`Kernel.jj` as a shorter way to pretty-print an object as JSON](/posts/2019/03/29/pretty-printing-json-ruby/).

[so-stdin]: https://stackoverflow.com/questions/273262/best-practices-with-stdin-in-ruby
[pp-python-json]: /posts/2017/06/05/pretty-printing-json-cli/
