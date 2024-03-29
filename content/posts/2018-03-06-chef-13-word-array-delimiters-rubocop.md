---
title: 'Chef 13 Upgrade: Rubocop Changes for Word Array Literals (`%w`)'
description: 'A one-liner shell command to fix Rubocop errors `%w-literals should be delimited by [ and ]`.'
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-rubocop
- chef
- rubocop
- chef-13
- rubocop-0-49
image: https://media.jvt.me/57345b1a3e.png
date: 2018-03-06T20:34:46+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-word-array-delimiters-rubocop
---
<blockquote>As part of an <a href="/posts/2018/03/06/chef-13-upgrades/">upgrade from Chef 12 to Chef 13</a>, this is one of the posts in which I've been <a href="/tags/chef-13-upgrade">detailing the issues I've encountered, and how I've resolved them </a>.</blockquote>

One recommended change with the new version of Rubocop is the error `%w-literals should be delimited by [ and ]`.

For instance:

```diff
-arr = %w(this is an array)
+arr = %w[this is an array]
```

For most cases, you will be able to perform one of the following commands:

```sh
# use Rubocop's automagic autocorrect, if possible
rubocop --auto-correct
# or fall back to a search and replace
find . -iname "*.rb" -exec sed -i 's/%w(\([^)]*\))/%w[\1]/g' {} \;
```
