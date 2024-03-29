---
title: "Marking up my pronouns with Microformats"
description: "Adding my pronouns to my personal h-card to help others determine how I identify."
tags:
- announcement
- microformats
- diversity-and-inclusion
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-10T22:46:22+0100
slug: "pronouns-microformats"
image: https://media.jvt.me/a8371cdde8.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/microformats
---
Following <span class="h-card"><a class="p-name u-url" href="https://twitter.com/aimeegamble">Aimee Gamble-Milner</a></span>'s talk [Error: Property "X" does not exist on type "Genders"](/posts/2019/04/10/tech-nottingham-april/#error-property-x-does-not-exist-on-type-genders), I was thinking about making my pronouns more visible.

At [DevOpsDays London 2018](/posts/2018/10/25/devopsdays-london-2018/#inclusivity), I was incredibly impressed with the use of pronoun stickers to share with other attendees how you want others to refer to you.

There have been some discussions at [Women in Tech Nottingham](https://twitter.com/WIT_Notts) (after DevOpsDays donated the stickers) since then about it, and how cis-gendered people need to share their pronouns too.

This makes it much more normalised, meaning it's not just non cis-gendered people who should add their pronouns, but everyone! This makes it much more inclusive and allows for people to share how they want to be referred to - guessing is **never** a good idea!

At this time, I'd added my pronouns to [my personal Twitter account](https://twitter.com/jamietanna) but also wanted something in my Microformats setup.

After reaching out in the IndieWeb chat around whether it'd been considered yet (as I had an inkling that I had seen something about it before), I was pointed to [the _Pronouns_ section in h-card Brainstorming](http://microformats.org/wiki/h-card-brainstorming#Pronouns) by <span class="h-card"><a class="p-name u-url" href="https://aaronparecki.com/">Aaron Parecki</a></span>.

I've followed <span class="h-card"><a class="p-name u-url" href="https://gregorlove.com/">gRegor Morrill</a></span>'s pattern and added my pronouns to my personal h-card on `https://www.jvt.me` with three forms:

```html
<span class="p-pronoun-nominative p-x-pronoun-nominative">he</span>/
<span class="p-pronoun-oblique p-x-pronoun-oblique">him</span>/
<span class="p-pronoun-possessive p-x-pronoun-possessive">his</span>/
```

Currently it's just a draft for Microformats, but in the future I hope it'll become part of the spec.

Update 2020-12-28: I've dropped the `-x` from the above, as folks within the Microformats community have shared that often it takes longer to get a `-x` property widespread, and then migrated to a non `-x` property. I've added support on my site for both, but with the preference for i.e `p-pronoun-nominative`.
