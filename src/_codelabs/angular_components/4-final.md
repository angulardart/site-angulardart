---
layout: components
title: "Step 4: Add Expansion Panels and Tabs"
description: "Add material panels and tabs to your app."
nextpage:
  url: /codelabs/angular_components/what-next
  title: "What Next?"
prevpage:
  url: /codelabs/angular_components/3-usebuttons
  title: "Step 3: Upgrade Buttons and Inputs"
css: [styles.css]
---

<?code-excerpt path-base="examples/acx/lottery"?>

In this final step, you’ll use expansion panels and tabs to hide information
until the user needs it. You’ll use these components:

- `<material-expansionpanel>` and `<material-expansionpanel-set>`
- `<material-tab>` and `<material-tab-panel>`

{% include_relative _run_example.md %}

## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-expansionpanel and material-expansionpanel-set

Expansion panels are especially good for settings, so use them in the
custom `<settings-component>`, implemented in
lib/src/settings/settings_component.* files.


<ol>

<li markdown="1">
  Edit the Dart file
  (`lib/src/settings/settings_component.dart`),
  adding the expansion panel directives
  [MaterialExpansionPanel]({{site.acx_api}}/angular_components/MaterialExpansionPanel-class.html) and
  [MaterialExpansionPanelSet]({{site.acx_api}}/angular_components/MaterialExpansionPanelSet-class.html):

<?code-excerpt "3-usebuttons/lib/src/settings/settings_component.dart" diff-with="4-final/lib/src/settings/settings_component.dart"?>
```diff
--- 3-usebuttons/lib/src/settings/settings_component.dart
+++ 4-final/lib/src/settings/settings_component.dart
@@ -15,6 +15,8 @@
   templateUrl: 'settings_component.html',
   directives: [
     MaterialCheckboxComponent,
+    MaterialExpansionPanel,
+    MaterialExpansionPanelSet,
     MaterialRadioComponent,
     MaterialRadioGroupComponent,
     NgFor
```
</li>

<li markdown="1">
  Edit the template file
  (`lib/src/settings/settings_component.html`) to change the
  enclosing `<div>` element (the first and last lines of the file)
  to be a `<material-expansionpanel-set>`.
</li>

<li markdown="1">
  Convert the Wallet div into a
  `<material-expansionpanel>`
  ([MaterialExpansionPanel]({{site.acx_gallery}}/#/material_expansion_panel)):

{: type="a" }
1. Change the `<div>` element to `<material-expansionpanel>`.
2. Move the title (`h2` content) and summary content
   (`p` content) into the `<material-expansionpanel>` `name` and
   `secondaryText` attributes, respectively.
3. Remove the buttons from the bottom of the panel,
   putting their event handling code into `(save)` and
   `(cancel)` bindings. Your code changes to the _beginning_ of
   this file should look like this:

<?code-excerpt "3-usebuttons/lib/src/settings/settings_component.html" diff-with="4-final/lib/src/settings/settings_component.html" to="betting-panel"?>
```diff
--- 3-usebuttons/lib/src/settings/settings_component.html
+++ 4-final/lib/src/settings/settings_component.html
@@ -1,7 +1,9 @@
-<div>
-  <div>
-    <h2>Wallet</h2>
-    <p>Initial: ${!{ settings.initialCash }!}. Daily disposable income: ${!{ settings.dailyDisposable }!}.</p>
+<material-expansionpanel-set>
+  <material-expansionpanel
+      name="Wallet"
+      secondaryText="Initial: ${!{ settings.initialCash }!}. Daily disposable income: ${!{ settings.dailyDisposable }!}."
+      (save)="settingsUpdated()"
+      (cancel)="resetWallet()">
     <div>
       <h3>Initial cash</h3>
       <material-radio-group>
@@ -21,12 +23,12 @@
         </material-radio>
       </material-radio-group>
     </div>
-    <button (click)="settingsUpdated()">Save</button>
-    <button (click)="resetWallet()">Cancel</button>
-  </div>
-  <div class="betting-panel">
```

</li>

<li markdown="1">
  Test the app. The Wallet settings should look like this at first:

  <img src="images/material-expansionpanel-wallet-1.png" alt='screenshot'>

  When you expand the Wallet settings, they should look like this:

  <img src="images/material-expansionpanel-wallet-2.png" alt='screenshot'>

  When you change settings and click the SAVE button at bottom right, the new values should appear in the UI:

  <img src="images/material-expansionpanel-wallet-3.png" alt='screenshot'>
</li>

<li markdown="1">
  Once the app runs correctly, convert the two remaining major divs (Betting and
  Other) into material expansion panels.
</li>
</ol>

That bit of work saved a lot of UI space:

<img style="border:1px solid black" src="images/material-expansionpanel-after.png" alt='screenshot>'>


## <i class="far fa-money-bill-alt fa-sm"> </i> Use material-tab and material-tab-panel

You can save more by moving auxiliary text into separate tabs.
This affects the main UI, implemented in `lib/lottery_simulator.*` files.

<ol markdown="1">
<li markdown="1">
Make the following changes to `lib/lottery_simulator.dart`:

<?code-excerpt "3-usebuttons/lib/lottery_simulator.dart" diff-with="4-final/lib/lottery_simulator.dart"?>
```diff
--- 3-usebuttons/lib/lottery_simulator.dart
+++ 4-final/lib/lottery_simulator.dart
@@ -28,6 +28,8 @@
     MaterialFabComponent,
     MaterialIconComponent,
     MaterialProgressComponent,
+    MaterialTabComponent,
+    MaterialTabPanelComponent,
     MaterialToggleComponent,
     ScoresComponent,
     SettingsComponent,
```
</li>

<li markdown="1">
Edit `lib/lottery_simulator.html`:

<ol type="a" markdown="1">

<li markdown="1">
  After the end of the first `<div>`, add a `<material-tab-panel>` tag.
</li>
<li markdown="1">
  Put the closing tag of the `<material-tab-panel>` at the end of the file.
</li>
<li markdown="1">Just after the opening `<material-tab-panel>` tag,
    add a `<material-tab>` tag with the label set to “Simulation”.
</li>

<li markdown="1"> Close the `<material-tab-panel>` near the bottom
    of the file, just before the `<div>` containing the Help heading.

Your changes, so far, should look like this:

{% comment %}
Using manually created excerpt since the diff is too big and not
easy to trim

<?disabled-code-excerpt "3-usebuttons/lib/lottery_simulator.html" diff-with="4-final/lib/lottery_simulator.html"?>
```diff
```
{% endcomment %}

{% prettify html %}
  <h1>Lottery Simulator</h1>

  <div class="help">
    ...
  </div>

  [[highlight]]<material-tab-panel>[[/highlight]]
    [[highlight]]<material-tab label="Simulation">[[/highlight]]
      ...
    [[highlight]]</material-tab>[[/highlight]]
  <div>
    <h2>Help`</h2>`
    ...
  </div>
  [[highlight]]</material-tab-panel>[[/highlight]]
{% endprettify %}

If you run the app now, the top of the UI should look like this:

<img style="border:1px solid black" src="images/material-tab-after.png" alt='screenshot: a "Simulation" tab is visible above the "Playing Powerball heading">'>
</li>
<li markdown="1"> Change the next two `<div>`-`<h2>`
    combinations into `<material-tabs>`, with the labels “Help” and “About”.
</li>
</ol>
</li>
</ol>

The end of the file should look like this:

<?code-excerpt "3-usebuttons/lib/lottery_simulator.html" diff-with="4-final/lib/lottery_simulator.html" from="\/material-tab" to="\/material-tab-panel"?>
```diff
--- 3-usebuttons/lib/lottery_simulator.html
+++ 4-final/lib/lottery_simulator.html
@@ -7,78 +7,79 @@
  </p>
 </div>

-<div>
-  <h2>Playing {!{ settings.lottery.shortName }!}</h2>
-
-  <scores-component [cash]="cash" [altCash]="altCash"
-      class="scores-component"></scores-component>
-
-  <div class="days">
-    <div class="days__start-day">
-      <span>{!{ currentDay }!}</span>
-    </div>
-    <div class="days__end-day">
-      <span>{!{ settings.years }!} years from now</span>
-    </div>
-    <div class="clear-floats"></div>
-  </div>
-
-  <material-progress  [activeProgress]="progress" class="life-progress">
-  </material-progress>
-
-  <div class="controls">
-    <div class="controls__fabs">
-      <material-fab raised (trigger)="play()"
-          [disabled]="endOfDays || inProgress"
-          id="play-button"
-          aria-label="Play">
-        <material-icon icon="play_arrow"></material-icon>
-      </material-fab>
-
-      <material-fab mini raised (trigger)="step()"
-          [disabled]="endOfDays || inProgress"
-          aria-label="Step">
-        <material-icon icon="skip_next"></material-icon>
-      </material-fab>
-
-      <material-fab mini raised (trigger)="pause()"
-          [disabled]="!inProgress"
-          aria-label="Pause">
-        <material-icon icon="pause"></material-icon>
-      </material-fab>
-
-      <material-fab mini raised (trigger)="reset()"
-          aria-label="Reset">
-        <material-icon icon="replay"></material-icon>
-      </material-fab>
+<material-tab-panel>
+  <material-tab label="Simulation">
+    <div>
+      <h2>Playing {!{ settings.lottery.shortName }!}</h2>
+
+      <scores-component [cash]="cash" [altCash]="altCash"
+          class="scores-component"></scores-component>
+
+      <div class="days">
+        <div class="days__start-day">
+          <span>{!{ currentDay }!}</span>
+        </div>
+        <div class="days__end-day">
+          <span>{!{ settings.years }!} years from now</span>
+        </div>
+        <div class="clear-floats"></div>
+      </div>
+
+      <material-progress  [activeProgress]="progress" class="life-progress">
+      </material-progress>
+
+      <div class="controls">
+        <div class="controls__fabs">
+          <material-fab raised (trigger)="play()"
+              [disabled]="endOfDays || inProgress"
+              id="play-button"
+              aria-label="Play">
+            <material-icon icon="play_arrow"></material-icon>
+          </material-fab>
+
+          <material-fab mini raised (trigger)="step()"
+              [disabled]="endOfDays || inProgress"
+              aria-label="Step">
+            <material-icon icon="skip_next"></material-icon>
+          </material-fab>
+
+          <material-fab mini raised (trigger)="pause()"
+              [disabled]="!inProgress"
+              aria-label="Pause">
+            <material-icon icon="pause"></material-icon>
+          </material-fab>
+
+          <material-fab mini raised (trigger)="reset()"
+              aria-label="Reset">
+            <material-icon icon="replay"></material-icon>
+          </material-fab>
+        </div>
+        <material-toggle class="controls__faster-button"
+            label="Go faster"
+            [(checked)]="fastEnabled">
+        </material-toggle>
+        <div class="clear-floats"></div>
+      </div>
+
+      <div class="history">
+        <stats-component [winningsMap]="winningsMap"
+            class="history__stats"></stats-component>
+        <visualize-winnings #vis
+            class="history__vis"></visualize-winnings>
+        <div class="clear-floats"></div>
+      </div>
+
+      <h2>Settings</h2>
+
+      <settings-component [settings]="settings"
+          (settingsChanged)="updateFromSettings()">
+      </settings-component>
     </div>
-    <material-toggle class="controls__faster-button"
-        label="Go faster"
-        [(checked)]="fastEnabled">
-    </material-toggle>
-    <div class="clear-floats"></div>
-  </div>
-
-  <div class="history">
-    <stats-component [winningsMap]="winningsMap"
-        class="history__stats"></stats-component>
-    <visualize-winnings #vis
-        class="history__vis"></visualize-winnings>
-    <div class="clear-floats"></div>
-  </div>
-
-  <h2>Settings</h2>
-
-  <settings-component [settings]="settings"
-      (settingsChanged)="updateFromSettings()">
-  </settings-component>
-</div>
-<div>
-  <h2>Help</h2>
-  <help-component content="help"></help-component>
-</div>
-<div>
-  <h2>About</h2>
-  <help-component content="about"></help-component>
-</div>
-
+  </material-tab>
+  <material-tab label="Help">
+    <help-component content="help"></help-component>
+  </material-tab>
+  <material-tab label="About">
+    <help-component content="about"></help-component>
+  </material-tab>
+</material-tab-panel>
```

Your app should now look exactly like the one you saw in the first page of this
codelab.

Congratulations! You’ve converted a functional but UI-challenged app into a good
looking, well-behaved app that uses the next generation of AngularDart
Components.

### Problems?

Check your code against the solution in the
[4-final]({{site.ghNgEx}}/lottery/tree/{{site.branch}}/4-final) directory.
