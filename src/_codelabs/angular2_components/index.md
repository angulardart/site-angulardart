---
layout: codelab
title: "Code Lab: AngularDart Components"
description: "Learn how to use AngularDart Components—a preview of material design components that are widely used in Google's Dart apps."
toc: false
permalink: /codelabs/angular2_components
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/angular2_components/1-base
  title: "Step 1: Get to Know the Software"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

```
PENDING:
* change snippet_img to the image from the About tab
* what should the "header: css" value be? (currently /codelabs/ng2/darrrt.css)
```

This code lab introduces you to a preview release of *AngularDart Components*,
part of a large group of well-tested components that are widely used in
Google’s Dart apps.

To complete this code lab, you need the following:

*   A Windows, Mac, or Linux computer with Dart SDK 1.20 (or a higher version)
*   A web connection and browser

This code lab assumes that you are familiar with Dart web app development.
If you aren’t, instead try one of the [other webdev code labs](/codelabs).

You’ll take an ugly but functional Angular 2 app, called Lottery Simulator,
and use AngularDart Components to simplify the code and beautify the UI.
You can play with a live copy of the final app at `[PENDING: URL]`.

Here are screenshots of the app’s UI, before and after conversion to
use AngularDart Components:

```
PENDING: Show before & after here
```

```
PENDING: make sure the titles in the following TOC reflect the final titles.
Make at least the Step entries links.
```

## Contents

* Step 1: Get to Know the Software
  * Get the app code
  * Run the base app
    * Custom components in the Lottery Simulator
  * Get familiar with AngularDart Components
* Step 2: Start Using AngularDart Components
  * Copy the source code
  * Add angular2_components to pubspec.yaml
  * Set up the root component’s Dart file
  * Use \<material-progress>
  * Use \<glyph> in buttons
  * Use \<glyph> in other components
    * Common problem: Forgetting to register a component
  * Use \<acx-scorecard>
    * Common problem: Registering the wrong component
* Step 3: Upgrade Buttons and Inputs
  * Use \<material-toggle>
  * Use \<material-fab>
    * Common pattern: (trigger)
  * Use \<material-checkbox>
  * Use \<material-radio> and \<material-radio-group>
* Step 4: Add Expansion Panels and Tabs
  * Use \<material-expansionpanel> and \<material-expansionpanel-set>
  * Use \<material-tab> and \<material-tab-panel>
* What Next?
