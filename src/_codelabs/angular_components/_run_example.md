{% assign part = page.url | regex_replace: '^.*/([-\w]+)', '\1' %}
Run the [live example](/examples/lottery/{{part}}/)
([view source]({{site.ghNgEx}}/lottery/tree/{{site.branch}}/{{part}}))
of the `{{part}}` version of the app.
