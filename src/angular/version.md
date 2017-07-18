---
layout: angular
title: AngularDart Versions
description: The AngularDart versions that this documentation and its examples use.
---
This site's documentation and examples reflect
the **latest stable release** of the
[angular2](https://pub.dartlang.org/packages/angular2) and
[angular_components](https://pub.dartlang.org/packages/angular_components)
packages. These packages often have a more recent development _(dev)_ release.

<table>
  <tr>
    <th>Release</th>
    <th>Latest version</th>
    <th>Documentation</th>
  </tr>
  <tr>
    <td>
      Stable
    </td>
    <td>
      <a href="https://pub.dartlang.org/packages/angular2/versions/{{site.custom.angular.stable-version-full}}#pub-pkg-tab-changelog">
        angular2 <b>{{site.custom.angular.stable-version-full}}</b>
      </a>
      <br>
      <a href="https://pub.dartlang.org/packages/angular_components/versions/{{site.custom.components.stable-version-full}}#pub-pkg-tab-changelog">
        angular_components <b>{{site.custom.components.stable-version-full}}</b>
      </a>
    </td>
    <td>
      <a href="/angular/guide">
        {{site.url | regex_replace: '^https?://' }}<b>/angular/guide</b>
      </a>
      <br>
      <a href="/components">
        {{site.url | regex_replace: '^https?://' }}<b>/components</b>
      </a>
    </td>
  </tr>
  <tr>
    <td>
      Dev
    </td>
    <td>
      {% if site.custom.angular.dev-version == nil and site.custom.components.dev-version == nil %}
      (none yet)
      {% elsif site.custom.angular.dev-version %}
      <a href="https://pub.dartlang.org/packages/angular/versions/{{site.custom.angular.dev-version}}#pub-pkg-tab-changelog">
        angular <b>{{site.custom.angular.dev-version}}</b>
      </a>
      <br>
      {% elsif site.custom.components.dev-version %}
      <a href="https://pub.dartlang.org/packages/angular_components/versions/{{site.custom.angular.dev-version}}#pub-pkg-tab-changelog">
        angular_components <b>{{site.custom.components.dev-version}}</b>
      </a>
      {% endif %}
    </td>
    <td>
      {% if site.custom.angular.dev-version == nil and site.custom.components.dev-version == nil %}
      (none yet)
      {% elsif site.custom.angular.dev-version %}
      <a href="{{site.custom.angular.url-next-vers}}/angular/guide">
        {{site.custom.angular.url-next-vers | regex_replace: '^https?://' }}<b>/angular/guide</b>
      </a>
      <br>
      {% elsif site.custom.components.dev-version %}
      <a href="{{site.custom.angular.url-next-vers}}/components">
        {{site.custom.angular.url-next-vers | regex_replace: '^https?://' }}<b>/components</b>
      </a>
      {% endif %}
    </td>
  </tr>
</table>

<!-- Comment out when we're not in alpha -->
## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

For more information, see the documentation for
the [pub version scheme](https://www.dartlang.org/tools/pub/versioning).
<!-- -->

## Example code

Each example in the AngularDart documentation has a repo under the GitHub organization
[angular-examples](https://github.com/angular-examples).
These example repos are generated from the [dart-lang/site-webdev]({{site.repo}}) repo,
using files under the [examples]({{site.repo}}/tree/master/examples) directory.


## Other Angular versions

AngularDart started out with the same codebase as the TypeScript Angular framework,
which is documented at [angular.io](https://angular.io).

Although the [code is now separate](http://news.dartlang.org/2016/07/angulardart-is-going-all-dart.html),
the two projects are as similar as possible,
while still making the most of Dart features and libraries.
