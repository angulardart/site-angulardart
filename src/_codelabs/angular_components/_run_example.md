{% assign part = page.id | split: '/' | last %}
Run the {% example_ref repo="lottery" %} of the `{{part}}` version of the app.
