---
layout: components
title: "Step 2: Start Using AngularDart Components"
description: "Add material components to your app."
nextpage:
  url: /codelabs/angular_components/3-usebuttons
  title: "Step 3: Upgrade Buttons and Inputs"
prevpage:
  url: /codelabs/angular_components/1-base
  title: "Step 1: Get to Know the Software"
css: [styles.css]
---

<?code-excerpt path-base="examples/acx/lottery"?>

In this step, you’ll change the app to use a few of the AngularDart Components:

- `<material-icon>`
- `<material-progress>`
- `<acx-scorecard>`

{% include_relative _run_example.md %}

## <i class="far fa-money-bill-alt fa-sm"> </i> Copy the source code

Make a copy of the base app's source code:

```terminal
> cp -r 1-base myapp
> cd myapp
> pub get
```

From now on, you'll work in this copy of the source code,
using whatever [Dart web development tools](/tools) you prefer.


## <i class="far fa-money-bill-alt fa-sm"> </i> Depend on angular_components

<ol markdown="1">

<li markdown="1"> Edit `pubspec.yaml` to add a dependency to `angular_components`:

<?code-excerpt "1-base/pubspec.yaml" diff-with="2-starteasy/pubspec.yaml" to="dev_dependencies"?>
```diff
--- 1-base/pubspec.yaml
+++ 2-starteasy/pubspec.yaml
@@ -7,6 +7,7 @@

 dependencies:
   angular: ^5.2.0
+  angular_components: ^0.11.0
   intl: ^0.15.0

 dev_dependencies:
```
</li>

<li markdown="1"> Get the new package:

```terminal
> pub get
```
</li>
</ol>

## <i class="far fa-money-bill-alt fa-sm"> </i> Set up the root component’s Dart file

Edit `lib/lottery_simulator.dart`,
importing the Angular components and informing Angular about
[`materialProviders`]({{site.acx_api}}/angular_components/materialProviders-constant.html)
and the material directives used in the template:

<?code-excerpt "1-base/lib/lottery_simulator.dart" diff-with="2-starteasy/lib/lottery_simulator.dart"?>
```diff
--- 1-base/lib/lottery_simulator.dart
+++ 2-starteasy/lib/lottery_simulator.dart
@@ -5,6 +5,7 @@
 import 'dart:async';

 import 'package:angular/angular.dart';
+import 'package:angular_components/angular_components.dart';
 import 'package:intl/intl.dart';

 import 'src/help/help.dart';
@@ -24,12 +25,15 @@
   templateUrl: 'lottery_simulator.html',
   directives: [
     HelpComponent,
+    MaterialIconComponent,
+    MaterialProgressComponent,
     ScoresComponent,
     SettingsComponent,
     StatsComponent,
     VisualizeWinningsComponent,
   ],
   providers: [
+    materialProviders,
     ClassProvider(Settings),
   ],
 )
```

Now you’re ready to use the components.

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-progress

Edit the template file `lib/lottery_simulator.html` to use the
`<material-progress>` tag
([MaterialProgressComponent]({{site.acx_gallery}}/#/material_progress)).
The diffs should look similar to this:

<?code-excerpt "1-base/lib/lottery_simulator.html" diff-with="2-starteasy/lib/lottery_simulator.html" from="Progress" to="<\/material"?>
```diff
--- 1-base/lib/lottery_simulator.html
+++ 2-starteasy/lib/lottery_simulator.html
@@ -23,35 +23,39 @@
     <div class="clear-floats"></div>
   </div>

-  Progress: <strong>{!{progress}!}%</strong> <br>
-  <progress max="100" [value]="progress"></progress>
+  <material-progress  [activeProgress]="progress" class="life-progress">
+  </material-progress>
```

Run the app, and you’ll see the new progress bar stretching across the window:

<img style="border:1px solid black" src="images/material-progress-after.png" alt="screenshot showing the material progress bar">

As a reminder, here’s what the progress section looked like before:

<img style="border:1px solid black" src="images/material-progress-before.png" alt="screenshot showing the HTML progress bar">

That change is barely noticeable. You can make a bigger difference by adding
images to the buttons, using the `<material-icon>` component.

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-icon in buttons

Using `<material-icon>`
([MaterialIconComponent]({{site.acx_gallery}}/#/material_icon))
is similar to using `<material-progress>`,
except that you also need
[material icon fonts](http://google.github.io/material-design-icons/).
You can find icons and instructions for including them at
[design.google.com/icons](https://design.google.com/icons).
Use the following icons in the main simulator UI:


|---------------------+-----------------------------+-----------------|
| Current button text | New icon                    | Icon name       |
|---------------------|-----------------------------|-----------------|
| Play   | ![](images/ic_play_arrow_black_24px.svg) | play arrow      |
| Step   | ![](images/ic_skip_next_black_24px.svg)  | skip next       |
| Pause  | ![](images/ic_pause_black_24px.svg)      | pause           |
| Reset  | ![](images/ic_replay_black_24px.svg)     | replay          |
{:.table .table-striped}

<ol>

<li markdown="1">
Find the icon font value for **play arrow**:

{: type="a"}
 1. Go to [design.google.com/icons.](https://design.google.com/icons)
 2. Enter **play** or **play arrow** in the site search box.
 3. In the results, click the **play arrow** icon
    ![|>](images/ic_play_arrow_black_24px.svg)
    to get more information.
 4. Click **ICON FONT** to get the icon code to use: **play_arrow**.
</li>

<li markdown="1">
Find the icon font values for **skip next**, **pause**, and **replay**.
</li>

<li markdown="1">
Edit the main HTML file (`web/index.html`) to add the following code to the `<head>` section:

<?code-excerpt "1-base/web/index.html" diff-with="2-starteasy/web/index.html"?>
```diff
--- 1-base/web/index.html
+++ 2-starteasy/web/index.html
@@ -13,6 +13,8 @@
       }());
     </script>
     <script defer src="main.dart.js"></script>
+    <link rel="stylesheet" type="text/css"
+          href="https://fonts.googleapis.com/icon?family=Material+Icons">
     <style>
       #wrapper {
         max-width: 600px;
```
</li>

<li markdown="1">
Edit `lib/lottery_simulator.html` to change the first button to use
a `<material-icon>` instead of text:

{: type="a"}
1. Add an `aria-label` attribute to the button, giving it the value of the
  button's text (**Play**).
2. Replace the button's text (**Play**) with a `<material-icon>` element.
3. Set the `icon` attribute to the icon code (`play_arrow`).

Here are the diffs:

<?code-excerpt "1-base/lib/lottery_simulator.html" diff-with="2-starteasy/lib/lottery_simulator.html" from="play" to="<\/button"?>
```diff
--- 1-base/lib/lottery_simulator.html
+++ 2-starteasy/lib/lottery_simulator.html
@@ -23,35 +23,39 @@
     <div class="clear-floats"></div>
   </div>

-  Progress: <strong>{!{progress}!}%</strong> <br>
-  <progress max="100" [value]="progress"></progress>
+  <material-progress  [activeProgress]="progress" class="life-progress">
+  </material-progress>

   <div class="controls">
     <div class="controls__fabs">
       <button (click)="play()"
           [disabled]="endOfDays || inProgress"
           id="play-button"
-      >Play
+          aria-label="Play">
+        <material-icon icon="play_arrow"></material-icon>
       </button>
```

<li markdown="1">
Use similar changes to convert the **Step**, **Pause**, and **Reset** buttons
to use material icons instead of text.
</li>
</li>
</ol>

These small changes make a big difference in the UI:

<img style="border:1px solid black" src="images/material-icon-buttons-after.png" alt='buttons have images now, instead of text'>

<aside class="alert alert-success" markdown="1">
  <i class="fas fa-exclamation-circle"> </i> **Common problem: Forgetting to import material icon fonts**

  If you see words instead of icons, your app needs to import material icon fonts.

  **The solution:** In the app entry point (for example, `web/index.html`),
  **import the Material+Icons font family.**
</aside>


## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-icon in other components

If you scroll down to the Tips section of the page, you’ll see blank spaces where there should be icons:

<img style="border:1px solid black" src="images/material-icon-help-before.png" alt='help text has no images'>

The HTML template (`lib/src/help/help.html`) uses `<material-icon>` already, so why isn’t it working?

<aside class="alert alert-success" markdown="1">
  <i class="fas fa-exclamation-circle"> </i> **Common problem: Forgetting to register a component**

  If an Angular component’s template uses a second Angular component
  without declaring it, that **second component doesn’t appear in the
  first component’s UI**.

  **The solution:** In the first component’s Dart file,
  **import** the second component and **register** the second component’s
  class as a directive.
</aside>

Edit `lib/src/help/help.dart` to import the AngularDart Components and
register `MaterialIconComponent`.

<?code-excerpt "1-base/lib/src/help/help.dart" diff-with="2-starteasy/lib/src/help/help.dart"?>
```diff
--- 1-base/lib/src/help/help.dart
+++ 2-starteasy/lib/src/help/help.dart
@@ -3,12 +3,14 @@
 // BSD-style license that can be found in the LICENSE file.

 import 'package:angular/angular.dart';
+import 'package:angular_components/angular_components.dart';

 @Component(
   selector: 'help-component',
   templateUrl: 'help.html',
   styleUrls: ['help.css'],
   directives: [
+    MaterialIconComponent,
     NgSwitch,
     NgSwitchWhen,
     NgSwitchDefault,
```

<aside class="alert alert-info" markdown="1">
  **Note:**
  Unlike when you edited `lib/lottery_simulator.dart`,
  you don't need to add `materialProviders` to this file.
  The reason: the `<help-component>` UI has no buttons or anything else that
  requires the ripple animations defined in `materialProviders`.

  You also don’t need to do anything to get the material icon fonts,
  since the app’s entry point (`web/index.html`) already imports the font file.
</aside>

Adding those two lines to `lib/src/help/help.dart` makes the material icons display:

<img style="border:1px solid black" src="images/material-icon-help-after.png" alt='help text now has images'>


## <i class="far fa-money-bill-alt fa-sm"> </i> Use acx-scorecard

Make one more change: use
`<acx-scorecard>` ([ScorecardComponent]({{site.acx_gallery}}/#/scorecard))
to display the betting and investing results. You’ll use the
scorecards in the app’s custom `ScoresComponent` (`<scores-component>`), which is
implemented in `lib/src/scores/scores.*`.

<ol markdown="1">

<li markdown="1">
  Edit `lib/src/scores/scores.dart` to register `ScorecardComponent` and the
  `materialProviders` provider:

<?code-excerpt "1-base/lib/src/scores/scores.dart" diff-with="2-starteasy/lib/src/scores/scores.dart"?>
```diff
--- 1-base/lib/src/scores/scores.dart
+++ 2-starteasy/lib/src/scores/scores.dart
@@ -3,11 +3,14 @@
 // BSD-style license that can be found in the LICENSE file.

 import 'package:angular/angular.dart';
+import 'package:angular_components/angular_components.dart';

 @Component(
   selector: 'scores-component',
   styleUrls: ['scores.css'],
   templateUrl: 'scores.html',
+  directives: [ScorecardComponent],
+  providers: [materialProviders],
 )
 class ScoresComponent {
   /// The state of cash the person would have if they saved instead of betting.
```
</li>

<li markdown="1">
  Edit `lib/src/scores/scores.html`
  (the template file for `ScoresComponent`)
  to change the **Betting** section from a `<div>` to an `<acx-scorecard>`.
  Specify the following attributes (documented in the
  `ScorecardComponent` API reference) for each `<acx-scoreboard>`:

  * `label:` Set this to the string in the div’s `<h4>` heading: "Betting".
  * `class:` Set this to "betting",
    so that you can use it to specify custom styles.
  * `value:` Set this to the value of the `cash` property of `ScoresComponent`.
  * `description:` Set this to the second line of content in the div’s
    `<p>` section.
  * `changeType:` Set this to the value that `[class]` is set
    to, surrounded by `{% raw %}{{ }}{% endraw %}`.
</li>

<li markdown="1">

Similarly, change the **Investing** section from a `<div>`
to an `<acx-scorecard>`. A few notes:

- `label:` Set this to "Investing".
- `class:` Set this to "investing".
- `value:` Set this to the value of the `altCash` property of `ScoresComponent`.
- `description:` As before, set this to the second line of content in the div’s
  `<p>` section.
- **Don't** specify a `changeType` attribute.

Here are the code diffs for the last two steps:

<?code-excerpt "1-base/lib/src/scores/scores.html" diff-with="2-starteasy/lib/src/scores/scores.html" from="." to="<\/acx-scorecard"?>
```diff
--- 1-base/lib/src/scores/scores.html
+++ 2-starteasy/lib/src/scores/scores.html
@@ -1,15 +1,14 @@
-<div>
-  <h4>Betting</h4>
-  <p>
-    <strong [class]="cash > altCash ? 'positive' : cash < altCash ? 'negative' : 'neutral'">${!{ cash }!}</strong>
-    {!{ outcomeDescription }!}
-  </p>
-</div>
+<acx-scorecard
+    label="Betting"
+    class="betting"
+    value="${!{ cash }!}"
+    description="{!{ outcomeDescription }!}"
+    changeType="{!{ cash > altCash ? 'positive' : cash < altCash ? 'negative' : 'neutral' }!}">
+</acx-scorecard>
```
</li>

<li markdown="1">
Edit `lib/src/scores/scores.css` (styles for `ScoresComponent`)
to specify that `.investing` floats to the right.
You can also remove the unneeded `.positive` and `.negative` styles.

<?code-excerpt "1-base/lib/src/scores/scores.css" diff-with="2-starteasy/lib/src/scores/scores.css"?>
```diff
--- 1-base/lib/src/scores/scores.css
+++ 2-starteasy/lib/src/scores/scores.css
@@ -1,7 +1,3 @@
-.positive {
-  color: green;
-}
-
-.negative {
-  color: red;
+.investing {
+  float: right;
 }
\ No newline at end of file
```
</li>

<li markdown="1">
  Refresh the app, and look at the nice new UI:

  <img style="border:1px solid black" src="images/acx-scorecard-after.png" alt='new UI of the lottery simulation, with "Betting" and "Investing" scorecards'>

  Remember, it used to look like this:

  <img style="border:1px solid black" src="images/acx-scorecard-before.png" alt='old UI of the lottery simulation'>
</li>
</ol>

<aside class="alert alert-success" markdown="1">
  <i class="fas fa-exclamation-circle"> </i> **Common problem: Registering the wrong component**<br>

  It’s easy to accidentally register the wrong component.
  For example, you might register ScoresComponent instead of
  `ScorecardComponent`.

  **The solution:** If the component doesn’t show up, make sure the **containing
  component’s Dart file includes the right component.**
</aside>

### Problems?

Check your code against the solution in the
[2-starteasy]({{site.ghNgEx}}/lottery/tree/{{site.branch}}/2-starteasy)
directory.
