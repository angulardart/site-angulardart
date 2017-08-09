---
layout: angular
title: AngularDart Versions
description: The AngularDart versions that this documentation and its examples use.
---
This site's documentation and examples reflect
the **latest stable release** of the
[angular2](https://pub.dartlang.org/packages/%61ngular2) and
[angular_components](https://pub.dartlang.org/packages/%61ngular_components)
packages. These packages often have a more recent development _(dev)_ release.

<table>
  <tr>
    <th>Release</th>
    <th>Latest version</th>
    <th>Documentation</th>
  </tr>
  <tr>
    <td>
    {% if site.ng.vers.full contains "alpha" or site.ng.vers.full contains "beta" %}
      Current
    {% else %}
      Stable
    {% endif %}
    </td>
    <td>
      <div>
        <a href="https://pub.dartlang.org/packages/%61ngular2/versions/{{site.ng.vers.full}}#pub-pkg-tab-changelog"
          class="no-automatic-external">
          angular2 <b>{{site.ng.vers.full}}</b>
        </a>
      </div>
      <div>
        <a href="https://pub.dartlang.org/packages/%61ngular_components/versions/{{site.acx.vers.full}}#pub-pkg-tab-changelog"
          class="no-automatic-external">
          angular_components <b>{{site.acx.vers.full}}</b>
        </a>
      </div>
    </td>
    <td>
      <a href="/angular/guide">
        {{site.url | regex_replace: '^https?://'}}<b>/angular/guide</b>
      </a>
      <br>
      <a href="/components">
        {{site.url | regex_replace: '^https?://'}}<b>/components</b>
      </a>
    </td>
  </tr>
  {% if site.dev %}
  <tr>
    <td>
      Dev
    </td>
    <td>
      {% if site.ng.dev.version %}
      <div>
        <a href="https://pub.dartlang.org/packages/%61ngular/versions/{{site.ng.dev.version}}#pub-pkg-tab-changelog" class="no-automatic-external">
          angular <b>{{site.ng.dev.version}}</b>
        </a>
      </div>
      {% endif %}
      {% if site.acx.dev.version %}
      <div>
        <a href="https://pub.dartlang.org/packages/%61ngular_components/versions/{{site.acx.dev.version}}#pub-pkg-tab-changelog" class="no-automatic-external">
          angular_components <b>{{site.acx.dev.version}}</b>
        </a>
      </div>
      {% endif %}
    </td>
    <td>
      {% if site.ng.dev.version %}
      <div>
        <a href="{{site.dev.url}}/angular/guide" class="no-automatic-external">
          {{site.dev.url | regex_replace: '^https?://' }}<b>/angular/guide</b>
        </a>
      </div>
      {% endif %}
      {% if site.acx.dev.version %}
      <div>
        <a href="{{site.dev.url}}/components" class="no-automatic-external">
          {{site.dev.url | regex_replace: '^https?://' }}<b>/components</b>
        </a>
      </div>
      {% endif %}
    </td>
  </tr>
  {% endif %}
</table>

<aside class="alert alert-info" markdown="1">
**Migration tip:**
To see how the AngularDart documentation and examples have changed
in response to each release, read the [changelog](/angular/changelog).
</aside>


{% if site.ng.vers.full contains "alpha" or site.ng.dev.version contains "alpha" or site.acx.dev.version contains "alpha" %}
## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

For more information, see the documentation for
the [pub version scheme](https://www.dartlang.org/tools/pub/versioning).
{% endif %}

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

