---
layout: angular
title: The Starter App
description: A bare-bones Angular app
prevpage:
  title: "Tutorial: Tour of Heroes"
  url: /angular/tutorial
nextpage:
  title: The Hero Editor
  url: /angular/tutorial/toh-pt1
---
<?code-excerpt path-base="examples/ng/doc/toh-0"?>
This tutorial starts with a bare-bones Angular app.
Run the {% example_ref %} to see the app.

## Create the app

Let's get started.
Create a project named `angular_tour_of_heroes`,
using WebStorm or the command line
and the [angular-examples/quickstart]({{site.ghNgEx}}/quickstart/tree/{{site.branch}})
GitHub project
{%- if site.branch != 'master' %}
(`{{site.branch}}` branch)
{%- endif %}.
For detailed instructions, see
[Create a starter project](/angular/guide/setup#create-a-starter-project)
from the [Setup for Development](/angular/guide/setup) page.

## Run the app, and keep it running

Run the app from your IDE or the command line,
as explained in the
[Run the app](/angular/guide/setup#run-the-app) section of the
[Setup for Development](/angular/guide/setup) page.

You'll be making changes to the app throughout this tutorial.
When you are ready to view your changes, reload the browser window.
This will [reload the app](/angular/guide/setup#reload-the-app).
As you save updates to the code, the `pub` tool detects changes and
serves the new app.

## Angular app basics

Angular apps are made up of _components_.
A _component_ is the combination of an HTML template and a component class that controls a portion of the screen. The starter app has a component that displays a simple string:

<?code-excerpt "lib/app_component.dart" title linenums?>
```
  import 'package:angular/angular.dart';

  @Component(
    selector: 'my-app',
    template: '<h1>Hello {!{name}!}</h1>',
  )
  class AppComponent {
    var name = 'Angular';
  }
```

Every component begins with an `@Component` [annotation](/angular/glossary#annotation '"annotation" explained')
that describes how the HTML template and component class work together.

The `selector` property tells Angular to display the component inside a custom `<my-app>` tag in the `index.html`.

<?code-excerpt "web/index.html (inside &lt;body&gt;)" region="my-app" title?>
```
  <my-app>Loading...</my-app>
```

The `template` property defines a message inside an `<h1>` header.
The message starts with "Hello" and ends with `{!{name}!}`,
which is an Angular [interpolation binding](../guide/displaying-data) expression.
At runtime, Angular replaces `{!{name}!}` with
the value of the component's `name` property.
Interpolation binding is one of many Angular features you'll discover in this documentation.

<a id="seed"></a>
## The starter app's code

The app contains the following core files:

<code-tabs>
  <?code-pane "lib/app_component.dart" linenums?>
  <?code-pane "test/app_test.dart" linenums?>
  <?code-pane "web/main.dart" linenums?>
  <?code-pane "web/index.html" linenums?>
  <?code-pane "../_boilerplate/web/styles.css (quickstart)" title="web/styles.css (excerpt)" linenums?>
  <?code-pane "pubspec.yaml" linenums?>
</code-tabs>

These files are organized as follows:

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.dart
  - test
    - app_test.dart
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
</div>

All the examples in this documentation have _at least these core files_.
Each file has a distinct purpose and evolves independently as the app grows.

<style>td, th {vertical-align: top}</style>
<table width="100%"><col width="20%"><col width="80%">
<tr><th>File</th> <th>Purpose</th></tr>
<tr>
  <td><code>lib/app_component.dart</code></td>
  <td markdown="1">Defines `<my-app>`, the **root** component of what will become a tree of nested components as the app evolves.
  </td>
</tr><tr>
  <td><code>test/app_test.dart</code></td>
  <td markdown="1">Defines `AppComponent` tests. While testing isn't covered in this tutorial, you can learn how to test the Tour of Heroes app from the [Testing](../guide/testing) page.
  </td>
</tr><tr>
  <td><code>web/main.dart</code></td>
  <td markdown="1">Launches the app in the browser.
  </td>
</tr><tr>
  <td><code>web/index.html</code></td>
  <td markdown="1">Contains the `<my-app>` tag in its `<body>`. This is where the app lives!
  </td>
</tr><tr>
  <td><code>web/styles.css</code></td>
  <td markdown="1">A set of styles used throughout the app.
  </td>
</tr><tr>
  <td><code>analysis_options.yaml</code></td>
  <td markdown="1">The analysis options file. For details, see [Customize Static Analysis.][]
  </td>
</tr><tr>
  <td><code>pubspec.yaml</code></td>
  <td markdown="1">The file that describes this Dart package (the app) and its dependencies. For details, see [Pubspec Format.][]
  </td>
</tr>
</table>

## What's next

In the [next tutorial page](toh-pt1),
you'll modify the starter app to display more interesting data,
and to allow the user to edit that data.

[Customize Static Analysis.]: {{site.www}}/guides/language/analysis-options
[Pubspec Format.]: {{site.dartlang}}/tools/pub/pubspec
