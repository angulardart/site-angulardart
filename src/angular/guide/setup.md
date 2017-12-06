---
layout: angular
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

## Get prerequisites: Dart SDK, Dartium, and WebStorm  {#sdk}

You need the following tools:
* **Dart SDK** (**1.24** or a compatible version)
* **Dartium**

We also recommend that you get **WebStorm**.

For more information on how to get the tools, see [Get Started](/guides/get-started).

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
you can use the command line to download dependencies:
in a terminal window, go to the project root and run `pub get`.

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

**Note:** If a dialog says that Chromium wants to use your confidential information,
click **Deny**. Dartium is not for general-purpose browsing,
and Dartium doesn’t need your information to run this app.

You should see the following app in a [Dartium](/tools/dartium) browser window:

![A web page with the header: Hello Angular](/angular/guide/images/starter-app.png)

To run the app from the command line, use the `pub serve` command
to start the Dart compiler and an HTTP server.
Then, to view your app, use a browser to navigate to
the URL that `pub serve` displays.

## Reload the app  {#reload}

Whenever you change the app, reload the browser window.
As you save updates to the code, the `pub` tool detects changes and
serves the new app.

## Next step

If you're new to Angular, we recommend staying on the [learning path](learning-angular.html).
If you'd like to know more about the app you just created, see
[The Starter App.](/angular/tutorial/toh-pt0)
