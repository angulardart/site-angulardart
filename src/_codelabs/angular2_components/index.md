---
layout: codelab
title: "Code Lab: AngularDart Components"
description: "Learn how to use AngularDart Components—a preview of material design components that are widely used in Google's Dart apps."
toc: false
permalink: /codelabs/angular2_components
snippet_img: /codelabs/angular2_components/images/cartoon.jpeg

nextpage:
  url: /codelabs/angular2_components/1-base
  title: "Step 1: Get to Know the Software"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

This code lab introduces you to a preview release of *AngularDart Components*,
part of a large group of well-tested components that are widely used in
Google’s Dart apps.

<aside class="alert alert-info" markdown="1">
**Note:**
When this code lab says _AngularDart_, it means _Angular 2 for Dart_.
Full documentation for AngularDart is at [angulardart.org](https://angulardart.org).
</aside>

To complete this code lab, you need the following:

*   A Windows, Mac, or Linux computer with Dart SDK 1.20 (or a higher version)
*   A web connection and modern browser

This code lab assumes that you are familiar with Dart web app development.
If you aren’t, instead try one of the [other webdev code labs](/codelabs).
Familiarity with AngularDart development isn't required but is helpful,
since this code lab doesn't explain
[Angular concepts](https://angular.io/docs/dart/latest/guide/architecture.html).

In this code lab, you’ll take a basic AngularDart app, called Lottery Simulator,
and use AngularDart Components to simplify the code and beautify the UI.
You can play with a
[live copy of the final app](https://filiph.github.io/components_codelab/).

Here are screenshots of the app’s UI, before and after conversion to
use AngularDart Components.

|----------------+-----------------------|
| Base app       | Final app             |
|:--------------:|:---------------------:|
| ![HTML app](/codelabs/angular2_components/images/app-base.png) | ![AngularDart Components app](/codelabs/angular2_components/images/app-final.png) |

<img src="/codelabs/angular2_components/images/cartoon-guy.png"
    alt="top-hatted guy from the cartoon that appears in the app's About tab"
    align="right">
<h2> Contents </h2>

* [Step 1: Get to Know the Software](/codelabs/angular2_components/1-base)
  * Get the app code
  * Get familiar with the base app
  * Get familiar with AngularDart Components
* [Step 2: Start Using AngularDart Components](/codelabs/angular2_components/2-easystart)
  * Copy the source code
  * Depend on angular2_components
  * Set up the root component’s Dart file
  * Use \<material-progress>
  * Use \<glyph> in buttons
    * <i class="fa fa-exclamation-circle"> </i> Common problem: Forgetting to import glyph fonts
  * Use \<glyph> in other components
    * <i class="fa fa-exclamation-circle"> </i> Common problem: Forgetting to register a component
  * Use \<acx-scorecard>
    * <i class="fa fa-exclamation-circle"> </i> Common problem: Registering the wrong component
* [Step 3: Upgrade Buttons and Inputs](/codelabs/angular2_components/3-usebuttons)
  * Use \<material-toggle>
  * Use \<material-fab>
    * <i class="fa fa-exclamation-circle"> </i> Common pattern: (trigger)
  * Use \<material-checkbox>
  * Use \<material-radio> and \<material-radio-group>
* [Step 4: Add Expansion Panels and Tabs](/codelabs/angular2_components/4-final)
  * Use \<material-expansionpanel> and \<material-expansionpanel-set>
  * Use \<material-tab> and \<material-tab-panel>
* [What Next?](/codelabs/angular2_components/what-next)
