---
title: Installing and Configuring WebStorm
short-title: WebStorm
description: We recommend WebStorm for developing Dart web apps.
---

WebStorm is an IDE from JetBrains for client-side development.
It comes with the Dart plugin pre-installed.

## Getting started

To get started with WebStorm,
install it and then tell it where to find the Dart SDK.

### Installing software

* [Install the Dart SDK](/tools/sdk#install) version
  **{{site.data.pkg-vers.SDK.vers}}** or later.
* [Install WebStorm](https://www.jetbrains.com/webstorm/download) version
  **2018.1.3** or later.

### Configuring Dart support

Here's one way to configure Dart support in WebStorm:

 1. Create a new Dart project:
    1. From the Welcome screen, click **Create New Project**.
    1. In the next dialog, click **Dart**.
    {:type="a"}
 2. If you don't see a value for the **Dart SDK** path, enter it.
    For example, the SDK path might be<br>
    <code><i>&lt;dart-installation-directory></i>/dart/dart-sdk</code>.
    <aside class="alert alert-info" markdown="1">
      **Note:**
      The **Dart SDK** path specifies the directory that
      contains the SDK's `bin` and `lib` directories;
      the `bin` directory contains tools such as `dart` and `dart2js`.
      WebStorm ensures that the path is valid.
      For more information, see the Dart installation guide for your OS:
      [Windows]({{site.dartlang}}/install/windows),
      [Linux]({{site.dartlang}}/install/linux), or
      [Mac]({{site.dartlang}}/install/mac).
    </aside>

An alternative to Step 1
is to open an existing Dart project,
and then open its `pubspec.yaml` file or any of its Dart files.

{% comment %}
NOTE TO EDITORS OF THIS FILE: To reset to the initial WebStorm experience,
delete the IDE settings by removing the directories specified in
https://www.jetbrains.com/webstorm/help/project-and-ide-settings.html.
{% endcomment %}

## Reporting issues

Please report issues and feedback via the official
[JetBrains issue tracker for Dart.](https://youtrack.jetbrains.com/issues/WEB?q=Subsystem%3A+Dart)
Include details of the expected behavior, the actual behavior,
and screenshots if appropriate.

Your questions are welcome in the
[Dart plugin for WebStorm/IntelliJ editors mailing list.](https://groups.google.com/a/dartlang.org/d/forum/jetbrains-dart-plugin-discuss)

## More information

See the JetBrains website for more information.

* [WebStorm](https://www.jetbrains.com/webstorm/)
  * [Getting started with Dart](https://confluence.jetbrains.com/display/WI/Getting+started+with+Dart)
  * [Features](https://www.jetbrains.com/webstorm/features/)
  * [Quick start](https://www.jetbrains.com/webstorm/quickstart/)
* [Dart Plugin by JetBrains](https://plugins.jetbrains.com/plugin/6351)
* [Migrating From Eclipse to IntelliJ IDEA](https://www.jetbrains.com/help/idea/eclipse.html)
