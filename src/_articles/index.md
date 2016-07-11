---
layout: default
title: "Overview: Web Articles"
short-title: "Web Articles"
description: "Articles relating to programming Dart for the web."
permalink: /articles/
toc: false
---

Read these articles for insight into programming Dart for the web.

Also see: [Articles about the Dart language and libraries]({{site.dartlang}}/articles/)

<div class="break-80">
  <h2>Getting Data</h2>
  {% assign articles = site.articles | filter: 'get-data' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

<div class="break-80">
  <h2>Performance</h2>
  {% assign articles = site.articles | filter: 'performance' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

<div class="break-80">
  <h2>Low-Level HTML</h2>
  {% assign articles = site.articles | filter: 'low-level-html' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

