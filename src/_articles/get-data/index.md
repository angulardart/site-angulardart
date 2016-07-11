---
layout: default
title: "Articles: Get Data"
description: "Articles that describe how to get data, such as JSON files."
permalink: /articles/get-data/
toc: false
---

<div class="break-80">
  <h2>Get Data</h2>
  {% assign articles = site.articles | filter: 'get-data' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>
