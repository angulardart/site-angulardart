---
layout: default
title: "Articles: Performance"
description: "Articles relating to performance aspects of web programming in Dart, such as the event loop."
permalink: /articles/performance/
toc: false
---

<div class="break-80">
  <h2>Performance</h2>
  {% assign articles = site.articles | filter: 'performance' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>
