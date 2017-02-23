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
    <th> Angular release </th>
    <th> Latest version </th>
    <th> Documentation </th>
  </tr>
  <tr>
    <td>
      Stable
    </td>
    <td>
      {{site.custom.angular.stable-version-full}}
    </td>
    <td>
      <a href="/angular/guide">AngularDart documentation</a>
    </td>
  </tr>
  <tr>
    <td>
      Dev
    </td>
    <td>
      {{site.custom.angular.dev-version}}
    </td>
    <td>
      <a href="https://pub.dartlang.org/packages/%61ngular2/versions/{{site.custom.angular.dev-version}}#changelog">Changelog</a>
    </td>
  </tr>
</table>

## Angular alpha releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

For more information, see the documentation for
the [pub version scheme](https://www.dartlang.org/tools/pub/versioning).


## Example code

Each example in the AngularDart documentation has a repo under the GitHub organization
[angular-examples](https://github.com/angular-examples).
These example repos are generated from the dart-lang/site-webdev repo,
using files under the
[public/docs/_examples](https://github.com/dart-lang/site-webdev/tree/master/public/docs/_examples)
directory.

We are currently converting the examples from 2.2 to 3.0.
