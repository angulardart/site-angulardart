---
title: "Reference"
short-title: Reference
description: References
toc: false
---

{{page.description}}

{% assign _references = site.pages
      | where_exp: "reference", "reference.url contains '/reference/'"
      | where_exp: "reference", "reference.url != '/reference/'"
      | sort: 'title' -%}
      
{% for reference in _references -%}
- [{{ reference.title }}]({{ reference.url }})
{% endfor %}