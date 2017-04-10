---
layout: angular
title: Angular Versions
description: The AngularDart versions that this documentation and its examples use.
---
The AngularDart documentation and the examples embedded in it reflect
the **latest stable release** of the
[angular2 package.](https://pub.dartlang.org/packages/angular2)
The package often has a more recent development _(dev)_ release.

<table>
  <tr>
    <th>Angular release</th>
    <th>Latest version</th>
    <th>Documentation server</th>
  </tr>
  <tr>
    <td>
      Stable
    </td>
    <td>
      <a href="https://pub.dartlang.org/packages/%61ngular2/versions/{{site.custom.angular.stable-version-full}}#-pkg-tab-changelog">
        {{site.custom.angular.stable-version-full}}
      </a>
    </td>
    <td>
      <a href="/angular/guide">{{site.url | regex_replace: '^https?://' }}</a>
    </td>
  </tr>
  <tr>
    <td>
      Dev
    </td>
    <td>
      <a href="https://pub.dartlang.org/packages/%61ngular2/versions/{{site.custom.angular.dev-version}}#-pkg-tab-changelog">
        {{site.custom.angular.dev-version}}
      </a>
    </td>
    <td>
      <a href="{{site.custom.angular.url-next-vers}}/angular/guide">
        {{site.custom.angular.url-next-vers | regex_replace: '^https?://' }}
      </a>
    </td>
  </tr>
</table>

<!--
## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

For more information, see the documentation for
the [pub version scheme](https://www.dartlang.org/tools/pub/versioning).
-->

## Example code

Each example in the AngularDart documentation has a repo under the GitHub organization
[angular-examples](https://github.com/angular-examples).
These example repos are generated from the dart-lang/site-webdev repo,
using files under the
[public/docs/_examples](https://github.com/dart-lang/site-webdev/tree/2.2.x/public/docs/_examples)
directory.

We are creating 3.0 versions of all the examples,
placing them in the `master` branch of the [dart-lang/site-webdev]({{site.repo}}) repo.
Once 3.0 is stable, we'll update the example repos.
