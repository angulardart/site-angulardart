---
title: "Overview: Angular Engineering Notes"
short-title: Angular Engineering Notes
description: Cutting edge Angular notes written by Angular engineers.
toc: false
---

{{page.description}}

{% assign notes = site.pages
      | where_exp: "note", "note.url contains '/angular/note/'"
      | where_exp: "note", "note.url != '/angular/note/'"
      | sort: 'title' -%}

{% comment %}
## All
{% for note in notes -%}
1. [{{ note.title }}]({{ note.url }})
{% endfor %}
{% endcomment %}

## Migration

{% assign _notes = notes | where_exp: "note", "note.title contains 'Migration'" -%}
{% for note in _notes -%}
- [{{ note.title }}]({{ note.url }})
{% endfor %}

## Effective AngularDart

{% assign _notes = notes | where_exp: "note", "note.url contains '/note/effective/'" -%}
{% for note in _notes -%}
- [{{ note.title | regex_replace: 'Effective AngularDart: '  }}]({{ note.url }})
{% endfor %}

## FAQ

{% assign _notes = notes | where_exp: "note", "note.url contains '/note/faq/'" -%}
{% for note in _notes -%}
- [{{ note.title }}]({{ note.url }})
{% endfor %}

{% assign _notes = notes | where_exp: "note", "note.url contains '/note/router/'" -%}
{% if _notes.size > 1 -%}
## Router

{% for note in _notes -%}
- [{{ note.title }}]({{ note.url }})
{% endfor -%}
{% endif %}

## Testing

{% assign _notes = notes | where_exp: "note", "note.url contains '/note/testing/'" -%}
{% for note in _notes -%}
- [{{ note.title }}]({{ note.url }})
{% endfor %}
