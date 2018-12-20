---
layout: components
title: "Step 3: Upgrade Buttons and Inputs"
description: "Add material buttons and inputs to your app."
nextpage:
  url: /codelabs/angular_components/4-final
  title: "Step 4: Add Expansion Panels and Tabs"
prevpage:
  url: /codelabs/angular_components/2-starteasy
  title: "Step 2: Start Using AngularDart Components"
css: [styles.css]
---

<?code-excerpt path-base="examples/acx/lottery"?>

In this step you’ll change many of the controls in the app,
using these components:

- `<material-toggle>`
- `<material-fab>`
- `<material-checkbox>`
- `<material-radio>` and `<material-radio-group>`

These controls appear in two custom components: `<lottery-simulator>` and
`<settings-component>`.

{% include_relative _run_example.md %}

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-toggle

<ol markdown="1">
<li markdown="1">
Make the following changes to `lib/lottery_simulator.dart`:

<?code-excerpt "2-starteasy/lib/lottery_simulator.dart" diff-with="3-usebuttons/lib/lottery_simulator.dart"?>
```diff
--- 2-starteasy/lib/lottery_simulator.dart
+++ 3-usebuttons/lib/lottery_simulator.dart
@@ -25,8 +25,10 @@
   templateUrl: 'lottery_simulator.html',
   directives: [
     HelpComponent,
+    MaterialFabComponent,
     MaterialIconComponent,
     MaterialProgressComponent,
+    MaterialToggleComponent,
     ScoresComponent,
     SettingsComponent,
     StatsComponent,
```

</li>
<li markdown="1">
Edit `lib/lottery_simulator.html` to convert the “Go faster” `<div>`
(and its children) into a `<material-toggle>` ([MaterialToggleComponent]({{site.acx_gallery}}/#/material_toggle)), as the following diff shows:

<?code-excerpt "2-starteasy/lib/lottery_simulator.html" diff-with="3-usebuttons/lib/lottery_simulator.html" from="controls__faster-button" to="\/material-toggle"?>
```diff
--- 2-starteasy/lib/lottery_simulator.html
+++ 3-usebuttons/lib/lottery_simulator.html
@@ -28,37 +28,34 @@

   <div class="controls">
     <div class="controls__fabs">
-      <button (click)="play()"
+      <material-fab raised (trigger)="play()"
           [disabled]="endOfDays || inProgress"
           id="play-button"
           aria-label="Play">
         <material-icon icon="play_arrow"></material-icon>
-      </button>
+      </material-fab>

-      <button (click)="step()"
+      <material-fab mini raised (trigger)="step()"
           [disabled]="endOfDays || inProgress"
           aria-label="Step">
         <material-icon icon="skip_next"></material-icon>
-      </button>
+      </material-fab>

-      <button (click)="pause()"
+      <material-fab mini raised (trigger)="pause()"
           [disabled]="!inProgress"
           aria-label="Pause">
         <material-icon icon="pause"></material-icon>
-      </button>
+      </material-fab>

-      <button (click)="reset()"
+      <material-fab mini raised (trigger)="reset()"
           aria-label="Reset">
         <material-icon icon="replay"></material-icon>
-      </button>
-    </div>
-    <div class="controls__faster-button">
-      <label>
-        <input #fastCheckbox type="checkbox"
-          (change)="fastEnabled = fastCheckbox.checked">
-        Go faster
-      </label>
+      </material-fab>
     </div>
+    <material-toggle class="controls__faster-button"
+        label="Go faster"
+        [(checked)]="fastEnabled">
+    </material-toggle>
```

</li>
</ol>

Here’s the resulting UI:

<img style="border:1px solid black" src="images/material-toggle-after.png" alt='tiny but attractive toggle button'>

The class behind `<material-toggle>`,
[MaterialToggleComponent]({{site.acx_api}}/angular_components/MaterialToggleComponent-class.html),
defines `label` and `checked` attributes.
The `label` attribute contains the main text for the toggle,
which the app previously specified in the `<label>` element.
A two-way binding to the `checked` property simplifies setting the
toggle’s state.

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-fab

Now convert the buttons that have icons into floating action buttons (FABs).

<ol markdown="1">
<li markdown="1"> Edit `lib/lottery_simulator.html`.
</li>

<li markdown="1"> Convert the Play button from a `<button>` to a
    `<material-fab>`
   ([MaterialFabComponent]({{site.acx_gallery}}/#/material_button)),
    adding the `raised` attribute and
    changing `(click)` to `(trigger)`:

<?code-excerpt "2-starteasy/lib/lottery_simulator.html" diff-with="3-usebuttons/lib/lottery_simulator.html" from="play" to="\/material-fab"?>
```diff
--- 2-starteasy/lib/lottery_simulator.html
+++ 3-usebuttons/lib/lottery_simulator.html
@@ -28,37 +28,34 @@

   <div class="controls">
     <div class="controls__fabs">
-      <button (click)="play()"
+      <material-fab raised (trigger)="play()"
           [disabled]="endOfDays || inProgress"
           id="play-button"
           aria-label="Play">
         <material-icon icon="play_arrow"></material-icon>
-      </button>
+      </material-fab>
```
</li>

<li markdown="1"> Convert the remaining three buttons in the same way,
    but add the `mini` attribute. For example:

<?code-excerpt "2-starteasy/lib/lottery_simulator.html" diff-with="3-usebuttons/lib/lottery_simulator.html" from="step" to="\/material-fab"?>
```diff
--- 2-starteasy/lib/lottery_simulator.html
+++ 3-usebuttons/lib/lottery_simulator.html
@@ -28,37 +28,34 @@

   <div class="controls">
     <div class="controls__fabs">
-      <button (click)="play()"
+      <material-fab raised (trigger)="play()"
           [disabled]="endOfDays || inProgress"
           id="play-button"
           aria-label="Play">
         <material-icon icon="play_arrow"></material-icon>
-      </button>
+      </material-fab>

-      <button (click)="step()"
+      <material-fab mini raised (trigger)="step()"
           [disabled]="endOfDays || inProgress"
           aria-label="Step">
         <material-icon icon="skip_next"></material-icon>
-      </button>
+      </material-fab>
```
</li>
</ol>

Once you’re done, run the app and play with the buttons.
They look good, and they have a nice ripple animation when you click them.

<img style="border:1px solid black" src="images/material-fab-after.png" alt='main UI buttons are now round'>

<aside class="alert alert-success" markdown="1">
  <i class="fas fa-exclamation-circle"> </i> **Common pattern: (trigger)** <br>

  Many of the AngularDart Components support trigger events. As a rule,
  your app should **handle trigger events instead of click events**,
  because trigger is better for accessibility. For example,
  trigger events fire on both click and keypress,
  and trigger events don’t fire when the element is disabled.
</aside>

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-checkbox

The primary UI is looking good!
Now start improving the settings section of the UI,
which is implemented in `lib/src/settings/settings_component.*` files.
First, change the checkbox to use `<material-checkbox>` ([MaterialCheckboxComponent]({{site.acx_gallery}}/#/material_checkbox)).

<ol markdown="1">

<li markdown="1"> Make the following changes to the Dart file for `<settings-component>` (`lib/src/settings/settings_component.dart`):

<?code-excerpt "2-starteasy/lib/src/settings/settings_component.dart" diff-with="3-usebuttons/lib/src/settings/settings_component.dart"?>
```diff
--- 2-starteasy/lib/src/settings/settings_component.dart
+++ 3-usebuttons/lib/src/settings/settings_component.dart
@@ -5,6 +5,7 @@
 import 'dart:async';

 import 'package:angular/angular.dart';
+import 'package:angular_components/angular_components.dart';
 import 'package:components_codelab/src/lottery/lottery.dart';
 import 'package:components_codelab/src/settings/settings.dart';

@@ -12,7 +13,13 @@
   selector: 'settings-component',
   styleUrls: ['settings_component.css'],
   templateUrl: 'settings_component.html',
-  directives: [NgFor],
+  directives: [
+    MaterialCheckboxComponent,
+    MaterialRadioComponent,
+    MaterialRadioGroupComponent,
+    NgFor
+  ],
+  providers: [materialProviders],
 )
 class SettingsComponent implements OnInit {
   final initialCashOptions = [0, 10, 100, 1000];
```
</li>

<li markdown="1"> Edit the template file
    (`lib/src/settings/settings_component.html`),
    changing the “checkbox” input and its surrounding label
    into a `<material-checkbox>`.

<?code-excerpt "2-starteasy/lib/src/settings/settings_component.html" diff-with="3-usebuttons/lib/src/settings/settings_component.html" from="Annual interest rate" to="\/material-checkbox"?>
```diff
--- 2-starteasy/lib/src/settings/settings_component.html
+++ 3-usebuttons/lib/src/settings/settings_component.html
@@ -4,28 +4,22 @@
     <p>Initial: ${!{ settings.initialCash }!}. Daily disposable income: ${!{ settings.dailyDisposable }!}.</p>
     <div>
       <h3>Initial cash</h3>
-      <div>
-        <label *ngFor="let item of initialCashOptions">
-          <input
-                 type="radio"
-                 #current
-                 [checked]="item == initialCash"
-                 (click)="initialCash = current.checked ? item : initialCash">
+      <material-radio-group>
+        <material-radio *ngFor="let item of initialCashOptions"
+            [checked]="item == initialCash"
+            (checkedChange)="initialCash = $event ? item : initialCash">
           ${!{ item }!}
-        </label>
-      </div>
+        </material-radio>
+      </material-radio-group>

       <h3>Daily disposable income</h3>
-      <div>
-        <label *ngFor="let item of dailyDisposableOptions">
-          <input
-              type="radio"
-              #current
-              [checked]="item == dailyDisposable"
-              (click)="dailyDisposable = current.checked ? item : dailyDisposable">
+      <material-radio-group>
+        <material-radio *ngFor="let item of dailyDisposableOptions"
+            [checked]="item == dailyDisposable"
+            (checkedChange)="dailyDisposable = $event ? item : dailyDisposable">
           ${!{ item }!}
-        </label>
-      </div>
+        </material-radio>
+      </material-radio-group>
     </div>
     <button (click)="settingsUpdated()">Save</button>
     <button (click)="resetWallet()">Cancel</button>
@@ -35,29 +29,23 @@
     <p>Lottery: {!{ settings.lottery.shortName }!}. Strategy: {!{ settings.strategy.shortName }!}.</p>
     <div>
       <h3>Lottery</h3>
-      <div>
-        <label *ngFor="let item of settings.lotteries">
-          <input
-              type="radio"
-              #current
-              [checked]="item == lottery"
-              (click)="lottery = current.checked ? item : lottery">
+      <material-radio-group>
+        <material-radio *ngFor="let item of settings.lotteries"
+            [checked]="item == lottery"
+            (checkedChange)="lottery = $event ? item : lottery">
           {!{ item.name }!}
-        </label>
-      </div>
+        </material-radio>
+      </material-radio-group>
       <p><strong>Description:</strong> {!{ lottery.description }!}</p>

       <h3>Strategy</h3>
-      <div>
-        <label *ngFor="let item of settings.strategies">
-          <input
-              type="radio"
-              #current
-              [checked]="item == strategy"
-              (click)="strategy = current.checked ? item : strategy">
+      <material-radio-group>
+        <material-radio *ngFor="let item of settings.strategies"
+            [checked]="item == strategy"
+            (checkedChange)="strategy = $event ? item : strategy">
           {!{ item.shortName }!} ({!{ item.name }!})
-        </label>
-      </div>
+        </material-radio>
+      </material-radio-group>
       <p><strong>Description:</strong> {!{ strategy.description }!}</p>
     </div>
     <button (click)="settingsUpdated()">Save</button>
@@ -68,35 +56,25 @@
     <p>Interest rate: {!{ settings.interestRate }!}%. Years: {!{ settings.years }!}.</p>
     <div>
       <h3>Annual interest rate</h3>
-      <label>
-        <input #investingCheckbox type="checkbox"
-               [checked]="isInvesting"
-               (change)="isInvesting = investingCheckbox.checked">
-        Investing
-      </label><br>
-      <div>
-        <label *ngFor="let value of interestRateOptions">
-          <input
-              type="radio"
-              #current
-              [checked]="value == interestRate"
-              [disabled]="!isInvesting"
-              (click)="interestRate = current.checked ? value : interestRate">
+      <material-checkbox label="Investing" [(checked)]="isInvesting">
+      </material-checkbox><br>
```
</li>
</ol>

Look how much simpler that code is!
`MaterialCheckboxComponent` supports a `label` attribute and
two-way binding to `checked`, enabling much cleaner HTML.

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-radio and material-radio-group

Still working on the settings, convert radio buttons
into `<material-radio>` components. Each group of radio buttons
is contained by a `<material-radio-group>` ([MaterialRadioComponent]({{site.acx_gallery}}/#/material_radio)).

<ol markdown="1">

<li markdown="1"> Edit the Dart file for `<settings-component>`
    (`lib/src/settings/settings_component.dart`) to register
    [MaterialRadioComponent]({{site.acx_api}}/angular_components/MaterialRadioComponent-class.html) and
    [MaterialRadioGroupComponent]({{site.acx_api}}/angular_components/MaterialRadioGroupComponent-class.html):

<?code-excerpt "2-starteasy/lib/src/settings/settings_component.dart" diff-with="3-usebuttons/lib/src/settings/settings_component.dart" from="directives:" to="providers:"?>
```diff
--- 2-starteasy/lib/src/settings/settings_component.dart
+++ 3-usebuttons/lib/src/settings/settings_component.dart
@@ -5,6 +5,7 @@
 import 'dart:async';

 import 'package:angular/angular.dart';
+import 'package:angular_components/angular_components.dart';
 import 'package:components_codelab/src/lottery/lottery.dart';
 import 'package:components_codelab/src/settings/settings.dart';

@@ -12,7 +13,13 @@
   selector: 'settings-component',
   styleUrls: ['settings_component.css'],
   templateUrl: 'settings_component.html',
-  directives: [NgFor],
+  directives: [
+    MaterialCheckboxComponent,
+    MaterialRadioComponent,
+    MaterialRadioGroupComponent,
+    NgFor
+  ],
+  providers: [materialProviders],
```
</li>

<li markdown="1">
  In the template file
  (`lib/src/settings/settings_component.html`),
  find the string `"radio"`. Change the enclosing label to
  `<material-radio>`, and then the immediately enclosing `<div>`
  to `<material-radio-group>`.
</li>

<li markdown="1">
  Move the input’s `[checked]` and `(click)`
  code into the material-radio component.
  If the input has `[disabled]` code, move that too.
</li>

<li markdown="1">
  Change `(click)` to `(checkedChange)`,
  and `current.checked` to `$event`.
  Here’s why:
  [MaterialRadioComponent]({{site.acx_api}}/angular_components/MaterialRadioComponent-class.html)
  fires checkedChange when the radio button’s selection state changes.
  The event’s value is true if the radio button has become selected,
  and otherwise false.
</li>

<li markdown="1"> Remove the `<input>` tag.
    Your code changes should look like this:

<?code-excerpt "2-starteasy/lib/src/settings/settings_component.html" diff-with="3-usebuttons/lib/src/settings/settings_component.html" from="Initial cash" to="\/material-radio-group"?>
```diff
--- 2-starteasy/lib/src/settings/settings_component.html
+++ 3-usebuttons/lib/src/settings/settings_component.html
@@ -4,28 +4,22 @@
     <p>Initial: ${!{ settings.initialCash }!}. Daily disposable income: ${!{ settings.dailyDisposable }!}.</p>
     <div>
       <h3>Initial cash</h3>
-      <div>
-        <label *ngFor="let item of initialCashOptions">
-          <input
-                 type="radio"
-                 #current
-                 [checked]="item == initialCash"
-                 (click)="initialCash = current.checked ? item : initialCash">
+      <material-radio-group>
+        <material-radio *ngFor="let item of initialCashOptions"
+            [checked]="item == initialCash"
+            (checkedChange)="initialCash = $event ? item : initialCash">
           ${!{ item }!}
-        </label>
-      </div>
+        </material-radio>
+      </material-radio-group>
```
</li>

<li markdown="1"> Repeat the process for the remaining radio button groups.
</li>

<li markdown="1"> Run the app. You might notice a small problem with
    the appearance of the Strategy settings:

<img style="border:1px solid black" src="images/material-radio-after-1.png" alt='screenshot'>
</li>

<li markdown="1"> Fix the appearance problem by editing
    `lib/src/settings/settings_component.css` to add a rule that
    maximizes that component’s width:

<?code-excerpt "2-starteasy/lib/src/settings/settings_component.css" diff-with="3-usebuttons/lib/src/settings/settings_component.css"?>
```diff
--- 2-starteasy/lib/src/settings/settings_component.css
+++ 3-usebuttons/lib/src/settings/settings_component.css
@@ -1,5 +1,5 @@
-.betting-panel label {
-    display: block;
+.betting-panel material-radio {
+    width: 100%;
 }

 h3:not(:first-child) {
```

</li>
</ol>

The app is now much better looking, but it still displays too much
information. You’ll fix that in the next step.

<aside class="alert alert-info" markdown="1">
  **Note:** You might notice that the
  `lib/src/settings/settings_component.html` still has a few `<button>`
  elements—all the **Save** and **Cancel** buttons.
  You’ll remove those in the next step.
</aside>

### Problems?

Check your code against the solution in the
[3-usebuttons]({{site.ghNgEx}}/lottery/tree/{{site.branch}}/3-usebuttons)
directory.
