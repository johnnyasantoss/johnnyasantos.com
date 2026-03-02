---
layout: page
title: Presentations
description: Sharing knowledge with the Bitcoin developer community
permalink: /presentations/
---

I believe in the power of open knowledge and collaborative learning. Here are some presentations I've given to help fellow developers understand complex Bitcoin protocols and contribute to a more decentralized future.

All materials are shared under [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) - feel free to use, remix, and build upon them.

---

{% assign sorted = site.presentations | sort: 'date' | reverse %}
{% assign years = "" | split: "" %}

{% for p in sorted %}
  {% assign year = p.name | slice: 0, 4 %}
  {% unless years contains year %}
    {% assign years = years | push: year %}
  {% endunless %}
{% endfor %}

{% assign years = years | sort | reverse %}

{% for year in years %}
## {{ year }}

{% for p in sorted %}
  {% if p.name contains year %}
### [{{ p.title }}]({{ p.url }})

**Event**: {{ p.event }}  
**Location**: {{ p.location }}  
**Date**: {{ p.date | date: "%B %d, %Y" }}

{{ p.description }}

{% if p.slides_url %}[Download slides (PDF)]({{ p.slides_url }}){% endif %}
  {% endif %}
{% endfor %}

{% unless forloop.last %}---
{% endunless %}
{% endfor %}
