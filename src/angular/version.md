---
layout: angular
title: AngularDart Versions
description: The AngularDart versions that this documentation and its examples use.
---
{% assign pubPkgUrl = 'https://pub.dartlang.org/packages' %}
This site's documentation and examples reflect the package versions in the
**Current** column of the following table. Some packages also have a development
version, listed in the **Next** column.

<style>
.material-icons { font-size: 16px; }
#vers { table-layout: fixed; width: 100%; }
#vers td, #vers th { text-align: center; }
#vers td:first-child { overflow: hidden; text-overflow: ellipsis;  direction: rtl; }
@media (max-width: 550px) { #vers td { padding: 1px 4px !important; transition: padding 0.5s; }}
</style>
<table id="vers" >
  <tr>
    <th>Package</th>
    <th>Current</th>{%
    if site.dev-url %}
    <th>Next</th>{%
    endif %}
  </tr>{%
  for pkgDataPair in site.data.ng-pkg-vers %}{%
  assign name = pkgDataPair[0] %}{%
  assign info = pkgDataPair[1] %}
  <tr>
    <td>{{info.tmp-name | default: name}}</td>
    <td>{% if info.vers %}
      <a href="{{pubPkgUrl}}/{{info.tmp-name | default: name}}/versions/{{info.vers}}#pub-pkg-tab-changelog"
        class="no-automatic-external">{{info.vers}}</a>
      {% if info.doc-path %}<a href="/{{info.doc-path}}"><i class="material-icons">info_outline</i></a>{% endif %}{%
      else %}-{%
      endif %}
    </td>{%
    if site.dev-url %}
    <td>{% if info.next-vers %}
      <a href="{{pubPkgUrl}}/{{name}}/versions/{{info.next-vers}}#pub-pkg-tab-changelog"
        class="no-automatic-external">{{info.next-vers}}</a>
      {% if info.doc-path%}<a href="{{site.dev-url}}/{{info.doc-path}}"
        class="no-automatic-external"><i class="material-icons md-18">info_outline</i></a>{% endif %}{%
      else %}-{%
      endif %}
    </td>{%
    endif %}
  </tr>{%
  endfor %}
</table>

<aside class="alert alert-info" markdown="1">
**Migration tip:**
To see how the AngularDart documentation and examples have changed
in response to each release, read the [changelog](/angular/changelog).
</aside>


## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

For more information, see the documentation for
the [pub version scheme]({{site.dartlang}}/tools/pub/versioning).

## Example code

Each example in the AngularDart documentation has a repo under the GitHub organization
[angular-examples](https://github.com/angular-examples).
These example repos are generated from the [dart-lang/site-webdev]({{site.repo}}) repo,
using files under the [examples]({{site.repo}}/tree/master/examples) directory.


## Other Angular implementations

AngularDart started out with the same codebase as the TypeScript Angular framework,
which is documented at [angular.io](https://angular.io).

Although the [code is now separate](http://news.dartlang.org/2016/07/angulardart-is-going-all-dart.html),
the two projects are as similar as possible,
while still making the most of Dart features and libraries.

