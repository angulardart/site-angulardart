---
title: Setup for Development
description: How to use Dart tools to create and run Angular apps
sideNavGroup: basic
prevpage:
  title: Documentation Overview
  url: /angular/guide/index
nextpage:
  title: Learning Angular
  url: /angular/guide/learning-angular
---
<a id="develop-locally"></a>
Setting up a new Angular project is straightforward using common Dart tools.
This page leads you through getting and running the starter app
that's featured in this guide and tutorial.

<a id="sdk"></a>
## Get prerequisites

For information on how to get these prerequisite tools,
see [Get Started](/guides/get-started):

- **Dart SDK** {{site.data.pkg-vers.SDK.vers}} or a compatible version
- Your favorite IDE, or **WebStorm** (recommended).

{% include webstorm-status.md %}

## Create a starter project  {#create}

The examples in this guide and tutorial are based on the
[angular-examples/quickstart]({{site.ghNgEx}}/quickstart/tree/{{site.branch}})
GitHub project.
You can get the project's files by the following methods:
* [Downloading them.]({{site.ghNgEx}}/quickstart/archive/{{site.branch}}.zip)
* Cloning the repo.
* Using Webstorms's Git support.

### Use WebStorm's Git support ###

1. Launch WebStorm.
1. If you haven't already done so,
   [configure Dart support in WebStorm](/tools/webstorm#configuring-dart-support).
1. From the welcome screen, choose **Check out from Version Control > Git**.<br>
   Alternatively, from the menu, choose **VCS > Git > Clone...**<br>
   A **Clone Repository** dialog appears.
1. Fill out the following fields:<a id="directory-name"></a>
   * **Git Repository URL:** `{{site.ghNgEx}}/quickstart`
   * **Parent Directory:** _(wherever you like to keep your practice code)_
   * **Directory Name:** `angular_tour_of_heroes` _(or any other
   [valid package name]({{site.dartlang}}/tools/pub/pubspec#name))_
1. Click **Clone**.
{%- if site.branch != 'master' %}
1. After the project opens, from the menu, choose **VCS > Git > Branches...**<br>
   A **Git Branches** popup appears.
1. From the popup, under **Remote Branches** choose<br>
   **origin/{{site.branch}} > Checkout as new local branch**.
{% endif %}

## Get dependencies  {#get}

In WebStorm:

1. Open the new project.
1. In the project view, double-click `pubspec.yaml`.
1. At the upper right of the editor view of `pubspec.yaml`:
   1. Click **Enable Dart support**.
   1. Click **Get dependencies**.

WebStorm takes several seconds to analyze the sources and
do other housekeeping. This only happens once.
After that, you'll be able to use WebStorm for the usual IDE tasks,
including running the app.

If you aren't using WebStorm,
you can use the following command in a terminal window:

```terminal
$ pub get
```

## Customize the project

Using WebStorm, or your favorite editor:

1. Open **`web/index.html`**, and replace the text of the **`<title>`** element
   with a title suitable for your app. For example: `<title>Angular Tour
   of Heroes</title>`.

1. Open **`pubspec.yaml`**, and update the **description** to suit your project.
   For example: `description: Tour of Heroes`.

1. _Optional_. If you'd like to change your project's name, then do a
   project-wide _search-and-replace_ of the current value of the **pubspec
   `name`** entry (**`angular_app`**) with a name suitable for your app
   &mdash; usually it will be the same as the [directory name](#directory-name)
   you chose earlier.

   This project-global rename will touch: `pubspec.yaml`, `web/main.dart` and
   `test/app_test.dart`.

<div><a id="running-the-app"></a></div>

## Run the app

In WebStorm:

1. In the project view, right-click `web/index.html`.
1. Choose **Run ‘index.html’.**

You should see the following app in a browser window:

![A web page with the header: Hello Angular](/angular/guide/images/starter-app.png)

To run the app from the command line, use [webdev][] to build and serve the app:

```terminal
$ webdev serve
```

Then, to view your app, use the Chrome browser to visit
[localhost:8080](localhost:8080).
(Details about Dart's browser support are
[in the FAQ](/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets).)

## Reload the app  {#reload}

Whenever you change the app, reload the browser window.
As you save updates to the code, the `pub` tool detects changes and
serves the new app.

## Next step

If you're new to Angular, we recommend staying on the [learning path](learning-angular).
If you'd like to know more about the app you just created, see
[The Starter App.](/angular/tutorial/toh-pt0)

[webdev]: /tools/webdev
