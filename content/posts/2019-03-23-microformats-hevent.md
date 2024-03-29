---
title: "Marking up Events with Microformats"
description: "Announcing the events content type and their markup with `h-event`."
tags:
- announcement
- indieweb
- microformats
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-23T14:19:49+00:00
slug: "microformats-hevent"
image: https://media.jvt.me/a8371cdde8.png
---
As I called out in [_Homebrew Website Club: Nottingham, Session 1_](/posts/2019/03/20/hwc-nottingham-session-1/), I wanted to have Microformats automagically generated for the content.

This was because I had manually hand-crafted this [`h-event`](http://microformats.org/wiki/h-event) for the [last event](/posts/2019/03/14/homebrew-website-club-nottingham/), which although perfectly fine was a bit more work than I'd want to do in the future, as well as duplicating a lot of the basics of the markup across many events.

However, before I did this, I needed to have a new content type in Hugo for these events, so I could render them differently than blog posts / content pages. This is as simple as creating a new folder in Hugo's directory structure, which is really nice, and then adding the relevant templates in my theme to render the `h-event`s.

The largest piece of work for this ([as with the work for `h-entry`s](/posts/2019/03/19/microformats-hentry/)) was getting HTML-Proofer checks in place to verify that the content is well-formed and that I don't have regressions in the future.

This is very exciting for better interoperability with others!
