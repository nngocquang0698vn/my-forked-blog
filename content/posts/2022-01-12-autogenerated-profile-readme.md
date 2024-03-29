---
title: "Building an Automagically Updating Personal README for GitLab and GitHub"
description: "Announcing the publishing of readme.jvt.me as well as automagically updating READMEs in my GitLab and GitHub profiles."
tags:
- go
- github
- gitlab
- readme.jvt.me
- microformats2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-12T16:21:13+0000
slug: "autogenerated-profile-readme"
---
If you land on someone's profile on a source hosting platform, you're likely to be interested in who they are and a bit more of what they like, and you may end up clicking out to their personal website, if they have one.

It's not new that it's possible to now add a `README` to your [GitLab](https://docs.gitlab.com/ee/user/profile/#add-details-to-your-profile-with-a-readme) or [GitHub](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme) profile, so your profile looks something like this:

![Screenshot of Jamie's profile on GitLab, with the banner information about him, a short description and some social links, followed by his contribution graph, and then the rendered README with more text about himself, including information about his current job, and some recent blog posts](https://media.jvt.me/6333624792.png)

This allows you to give a bit more context for who you are as a person, what projects you like working on, and anything else really. But as good as static content is, it does put a bit more onus on you to make sure that you update it regularly.

However, because the it's a repository hosted by GitLab or GitHub means that you can use tools like GitLab CI or GitHub Actions to automagically update the contents.

I've seen <span class="h-card"><a class="u-url" href="https://brandur.org">Brandur</a></span> [write about this in the past](https://brandur.org/fragments/self-updating-github-readme), who based it on something <span class="h-card"><a class="u-url" href="https://simonwillison.net/">Simon Willison</a></span> [did and blogged about](https://simonwillison.net/2020/Jul/10/self-updating-profile-readme/), and both of their approaches is pretty great to making sure the content stays relevant.

As the screenshot above shows, the README produced has some information like my current job (which admittedly doesn't change very often) as well as the most recent blog posts on my site, and even the last book I read, or how many steps I took yesterday. This is all automagically generated from my website, which in a very IndieWeb-y fashion, is the source of truth.

What I particularly like about my approach is that it uses the [Microformats2](https://microformats.io) markup that's already on my pages, as part of interoperability with one of the open standards that the IndieWeb community own, and I have been using for some time now. This has meant that there's absolutely nothing I've needed to do to get this data readily available, and I've been able to populate a lot of interesting things in the READMEs, purely by interacting with the metadata on posts that I use to track my life.

You can check out what it looks like on [my GitLab profile](https://gitlab.com/jamietanna) and on [my GitHub profile](https://github.com/jamietanna), or on [readme.jvt.me](https://readme.jvt.me) which is a platform agnostic version.

The automation is built from [my first real Go program, `readme-generator`](https://gitlab.com/jamietanna/readme-generator) which uses <span class="h-card"><a class="u-url" href="https://willnorris.com">Will Norris</a></span>'s awesome [microformats package for Go](https://github.com/willnorris/microformats) to do the heavy lifting.

It was fun to write a little bit of Go to solve it, and I'm sure I'll come back to improve both the code and the content over time.
