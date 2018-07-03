{% assign newPageUrl = site.main-url | append: page.url | regex_replace: '/$' -%}
<div class="alert alert-danger" markdown="1">
  This **preview site has been deprecated** in favor of
  [{{site.webdev | regex_replace: '^https?://'}},]({{site.webdev}})
  which has up-to-date coverage of Dart 2 and AngularDart 5.
  Please visit the new URL:
  [{{newPageUrl | regex_replace: '^https?://'}}]({{newPageUrl}})
</div>

[survey]: https://services.google.com/fb/forms/dart4web-may2018/
