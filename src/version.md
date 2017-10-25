---
title: Versions
description: The versions that this documentation and its examples use.
---
{% assign pubPkgUrl = 'https://pub.dartlang.org/packages' %}
This site's documentation and examples reflect the software versions in the
**Current** column of the following table.

<style>
#vers { width: max-content; }
#vers th, #vers td { padding: 8px 16px 8px 16px; }
#vers .material-icons { font-size: 17px; padding-left: 3pt; vertical-align: text-bottom; }
</style>
<table id="vers" class="table table-striped">
  <tr>
    <th>Package/SDK</th>
    {%- if site.prev-url -%} <th>Previous</th> {%- endif -%}
    <th>Current</th>
    {%- if site.dev-url -%} <th>Next</th> {%- endif -%}
  </tr>{%
  for pkgDataPair in site.data.ng-pkg-vers %}{%
  assign name = pkgDataPair[0] %}{%
  assign info = pkgDataPair[1] %}
  <tr>
    <td>{{info.tmp-name | default: name}}</td>

    {%- if site.prev-url -%}
    <td>{% if info.prev-vers %}
      <a href="{{pubPkgUrl}}/{{info.prev-name | default: name}}/versions/{{info.prev-vers}}#pub-pkg-tab-changelog"
        class="no-automatic-external">{{info.prev-vers}}</a>{%
        if info.doc-path%}<a href="{{site.prev-url}}/{{info.doc-path}}"
          class="no-automatic-external" title="documentation"><i class="material-icons md-18">description</i></a>{%
        endif %}{%
        else %}-{%
      endif %}
    </td>
    {%- endif -%}

    <td>
      {%- if info.vers -%}
      <a href="{{pubPkgUrl}}/{{name}}/versions/{{info.vers}}#pub-pkg-tab-changelog"
        class="no-automatic-external">{{info.vers}}</a>{%
      else %}-{%
      endif %}
      {% if info.doc-path %}<a href="/{{info.doc-path}}"
      title="Documentation"><i class="material-icons">description</i></a>{%
      else %}-{%
      endif %}
    </td>

    {%- if site.dev-url -%}
    <td>{% if info.next-vers %}
      <a href="{{pubPkgUrl}}/{{info.next-name | default: name}}/versions/{{info.next-vers}}#pub-pkg-tab-changelog"
        class="no-automatic-external">{{info.next-vers}}</a>{%
        if info.doc-path%}<a href="{{site.dev-url}}/{{info.doc-path}}"
          class="no-automatic-external" title="documentation"><i class="material-icons md-18">description</i></a>{%
        endif %}{%
        else %}-{%
      endif %}
    </td>
    {%- endif -%}

  </tr>
  {%- endfor -%}
</table>

<aside class="alert alert-info" markdown="1">
**Migration tip:**
To see how the AngularDart documentation and examples have changed
in response to each release, read the [changelog](/changelog).
</aside>


## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

<aside class="alert alert-warning" markdown="1">
**[Let us know if you find issues.](https://github.com/dart-lang/angular/issues/new)**
Google's [test and development environment](https://testing.googleblog.com/2014/01/the-google-test-and-development_21.html)
is different from the usual Dart environment,
so sometimes we miss issues with configuration or testing.
</aside>

For more information, see the documentation for
the [pub version scheme]({{site.dartlang}}/tools/pub/versioning).

## Example code

Each example in the AngularDart documentation has a repo under the GitHub organization
[angular-examples]({{site.ghNgEx}}).
These example repos are generated from the [dart-lang/site-webdev]({{site.repo}}) repo,
using files under the [examples]({{site.repo}}/tree/{{site.branch}}/examples) directory.


## Other Angular implementations

AngularDart started out with the same codebase as the TypeScript Angular framework,
which is documented at [angular.io](https://angular.io).

Although the [code is now separate](http://news.dartlang.org/2016/07/angulardart-is-going-all-dart.html),
the two projects are as similar as possible,
while still making the most of Dart features and libraries.

