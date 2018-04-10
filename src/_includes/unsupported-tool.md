
{% assign what = include.what | default: 'is no longer supported' -%}
<aside class="alert alert-warning" markdown="1">
  **{{include.tool}} {{what}}.**
  For details, see [Tools](/dart-2#tools) under
  [Dart 2 Migration](/dart-2).
</aside>
