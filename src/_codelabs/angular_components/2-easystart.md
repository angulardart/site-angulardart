---
title: "Step 2: Start Using AngularDart Components"
description: "Add material components to your app."
nextpage:
  url: /codelabs/angular_components/3-usebuttons
  title: "Step 3: Upgrade Buttons and Inputs"
prevpage:
  url: /codelabs/angular_components/1-base
  title: "Step 1: Get to Know the Software"
header:
  css: ["/codelabs/ng2/darrrt.css"]
---

In this step, you’ll change the app to use a few of the AngularDart Components:

*   \<material-progress>
*   \<glyph>
*   \<acx-scorecard>


## <i class="fa fa-money"> </i> Copy the source code

Make a copy of the base app's source code:

{% prettify none %}
cd one-hour-codelab/angular_components
cp -r 1-base myapp
cd myapp
pub get
{% endprettify %}

From now on, you'll work in this copy of the source code,
using whatever [Dart web development tools](/tools) you prefer.


## <i class="fa fa-money"> </i> Depend on angular_components

<ol markdown="1">

<li markdown="1"> Edit **pubspec.yaml** to add a dependency to **angular_components**:

{% prettify yaml %}
dependencies:
  angular2: ^3.0.0
  [[highlight]]angular_components: ^0.5.0[[/highlight]]
  intl: ^0.14.0
{% endprettify %}
</li>

<li markdown="1"> Get the new package:

{% prettify html %}
pub get
{% endprettify %}
</li>
</ol>

## <i class="fa fa-money"> </i> Set up the root component’s Dart file

Edit **lib/lottery_simulator.dart**,
importing the Angular components and informing Angular about
[`materialDirectives`]({{site.acx_api}}/angular_components/materialDirectives-constant.html) and [`materialProviders`]({{site.acx_api}}/angular_components/materialProviders-constant.html):

{% prettify dart %}
import 'package:angular2/angular2.dart';
[[highlight]]import 'package:angular_components/angular_components.dart';[[/highlight]]
...
@Component(
  selector: 'lottery-simulator',
  styleUrls: const ['lottery_simulator.css'],
  templateUrl: 'lottery_simulator.html',
  directives: const [
    [[highlight]]materialDirectives,[[/highlight]]
    ...
  ],
  providers: const [[[highlight]]materialProviders[[/highlight]], Settings],
)
{% endprettify %}

Now you’re ready to use the components.

## <i class="fa fa-money"> </i> Use material-progress

Edit the template file **lib/lottery_simulator.html** to use the
**\<material-progress>** tag
([MaterialProgressComponent]({{site.acx_api}}/angular_components/MaterialProgressComponent-class.html)).
The diffs should look similar to this:

<img style="border:1px solid black" src="images/material-progress-diffs.png" alt="Progress...</progress> -> <material-progress...>">

Run the app, and you’ll see the new progress bar stretching across the window:

<img style="border:1px solid black" src="images/material-progress-after.png" alt="screenshot showing the material progress bar">

As a reminder, here’s what the progress section looked like before:

<img style="border:1px solid black" src="images/material-progress-before.png" alt="screenshot showing the HTML progress bar">

That change is barely noticeable. Let’s make a bigger difference by adding images to the buttons, using the \<glyph> component.

## <i class="fa fa-money"> </i> Use glyph in buttons

Using \<glyph> 
([GlyphComponent]({{site.acx_api}}/angular_components/GlyphComponent-class.html))
is similar to using \<material-progress>,
except that you also need
[material icon fonts](http://google.github.io/material-design-icons/).
You can find icons and instructions for including them at
[design.google.com/icons](https://design.google.com/icons).
Let’s use the following icons in the main simulator UI:


|---------------------+-----------------------------+-----------------|
| Current button text | New icon                    | Icon name       |
|---------------------|-----------------------------|-----------------|
| Play   | ![](images/ic_play_arrow_black_24px.svg) | play arrow      |
| Step   | ![](images/ic_skip_next_black_24px.svg)  | skip next       |
| Pause  | ![](images/ic_pause_black_24px.svg)      | pause           |
| Reset  | ![](images/ic_replay_black_24px.svg)     | replay          |
{:.table .table-striped}

<ol>

<li>
Find the icon font value for <b>play arrow</b>:
<ol style="list-style-type: lower-alpha">
  <li>
  Go to <a href="https://design.google.com/icons">design.google.com/icons</a>. </li>
  <li>
  Enter <b>play</b> or <b>play arrow</b> in the site search box. </li>
  <li>
  In the results, click the <b>play arrow</b> icon
  (<img src="images/ic_play_arrow_black_24px.svg">)
  to get more information. </li>
  <li>
  Click <b>ICON FONT</b> to get the icon code to use: <b>play_arrow</b>. </li></ol></li>
<li>
Find the icon font values for <b>skip next</b>, <b>pause</b>, and <b>replay</b>. </li>

<li>
  <p>
  Edit the main HTML file (<b>web/index.html</b>) to add the following code to the &lt;head> section:
  </p>

{% prettify html %}
<link rel="stylesheet" type="text/css"
    href="https://fonts.googleapis.com/icon?family=Material+Icons">
{% endprettify %}
</li>

<li>
  Edit <b>lib/lottery_simulator.html</b> to change the first button to use
  a glyph instead of text:
<ol style="list-style-type: lower-alpha">
  <li>
  Add an <b>aria-label</b> attribute to the button,
  giving it the value of the button's text (<b>Play</b>).
  </li>
  <li>
  Replace the button's text (<b>Play</b>) with a <b>&lt;glyph></b> element.
  </li>
  <li>
  Set the glyph's <b>icon</b> attribute to the icon code (<b>play_arrow</b>).
  </li></ol>
  <p>
  Here are the diffs:
  </p>
  <p>
  <img style="border:1px solid black" src="images/glyph-play-diffs.png" alt='id="play-button">Play -> id="play-button" aria-label="Play"><glyph icon="play_arrow"></glyph>'>
  </p>
<li><p>Use similar changes to convert the <b>Step</b>, <b>Pause</b>, and
<b>Reset</b> buttons to use glyphs instead of text.</p></li></li></ol>

These small changes make a big difference in the UI:

<img style="border:1px solid black" src="images/glyph-buttons-after.png" alt='buttons have images now, instead of text'>

<aside class="alert alert-success" markdown="1">
<i class="fa fa-exclamation-circle"> </i> **Common problem: Forgetting to import glyph fonts**

If you see words instead of glyphs, your app needs to
import glyph fonts.

**The solution:** In the app entry point (for example, `web/index.html`),
**import the Material+Icons font family.**
</aside>


## <i class="fa fa-money"> </i> Use glyph in other components

If you scroll down to the Tips section of the page, you’ll see blank spaces where there should be icons:

<img style="border:1px solid black" src="images/glyph-help-before.png" alt='help text has no images'>

The HTML template (lib/src/help/help.html) uses \<glyph> already, so why isn’t it working?

<aside class="alert alert-success" markdown="1">
<i class="fa fa-exclamation-circle"> </i> **Common problem: Forgetting to register a component**

If an Angular component’s template uses a second Angular component
without declaring it, that **second component doesn’t appear in the
first component’s UI**.

**The solution:** In the first component’s Dart file,
**import** the second component and **register** the second component’s
class as a directive.
</aside>

Edit **lib/src/help/help.dart** to import the AngularDart Components and
register `materialDirectives`.


{% prettify dart %}
...
[[highlight]]import 'package:angular_components/angular_components.dart';[[/highlight]]

@Component(
  ...
  directives: const [
    [[highlight]]materialDirectives,[[/highlight]]
    ...
  ],
  ...
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Note:**
Unlike when you edited lib/lottery_simulator.dart,
you don't need to add `materialProviders` to this file.
The reason: the \<help-component> UI has no buttons or anything else that
requires the ripple animations defined in `materialProviders`.

You also don’t need to do anything to get the material icon fonts,
since the app’s entry point (web/index.html) already imports the font file.
</aside>

Adding those two lines to lib/src/help/help.dart makes the glyphs display:

<img style="border:1px solid black" src="images/glyph-help-after.png" alt='help text now has images'>


## <i class="fa fa-money"> </i> Use acx-scorecard

Let’s make one more change: using scorecards (\<acx-scorecard>)
to display the betting and investing results.
Because \<acx-scorecard> isn’t included in `materialDirectives`,
you need to explicitly register its Dart class,
[ScorecardComponent]({{site.acx_api}}/angular_components/ScorecardComponent-class.html).
We’ll use the scorecards in the app’s custom ScoresComponent
(\<scores-component>), which is implemented in `lib/src/scores/scores.*`.

<ol markdown="1">

<li markdown="1"> Edit **lib/src/scores/scores.dart** (the Dart file
    for ScoresComponent) to register ScorecardComponent and the
    `materialProviders` provider:

{% prettify dart %}
...
[[highlight]]import 'package:angular_components/angular_components.dart';[[/highlight]]

@Component(
  ...
  [[highlight]]directives: const [ScorecardComponent],[[/highlight]]
  [[highlight]]providers: const [materialProviders],[[/highlight]]
)
{% endprettify %}
</li>

<li markdown="1"> Edit **lib/src/scores/scores.html**
    (the template file for ScoresComponent)
    to change the **Betting** section from a \<div> to an \<acx-scorecard>.
    Specify the following attributes (documented in the
    ScorecardComponent API reference) for each \<acx-scoreboard>:

* **label:** Set this to the string in the div’s \<h4> heading: "Betting".
* **class:** Set this to "betting",
  so that you can use it to specify custom styles.
* **value:** Set this to the value of the `cash` property of ScoresComponent.
* **description:** Set this to the second line of content in the div’s
  \<p> section.
* **changeType:** Set this to the value that [class] is set
  to, surrounded by `{% raw %}{{ }}{% endraw %}`.

Here are the code diffs:

<img style="border:1px solid black" src="images/acx-scorecard-betting-diffs.png" alt='code diffs for <div><h4>Betting</h4>...</div>'>
</li>
<li markdown="1"> Similarly, change the **Investing** section from a \<div>
to an \<acx-scorecard>. A few notes:
* **label:** Set this to "Investing".
* **class:** Set this to "investing".
* **value:** Set this to the value of the `altCash` property of ScoresComponent.
* **description:** As before, set this to the second line of content in the div’s
  \<p> section.
* **Don't** specify a `changeType` attribute.
</li>
<li markdown="1"> Edit **lib/src/scores/scores.css** (styles for ScoresComponent)
    to specify that `.investing` floats to the right.
    You can also remove the unneeded `.positive` and `.negative` styles.

{% prettify none %}
.investing {
  float: right;
}
{% endprettify %}
</li>

<li markdown="1"> Refresh the app, and look at the nice new UI:

<img style="border:1px solid black" src="images/acx-scorecard-after.png" alt='new UI of the lottery simulation, with "Betting" and "Investing" scorecards'>

Remember, it used to look like this:

<img style="border:1px solid black" src="images/acx-scorecard-before.png" alt='old UI of the lottery simulation'>
</li>
</ol>

<aside class="alert alert-success" markdown="1">
<i class="fa fa-exclamation-circle"> </i> **Common problem: Registering the wrong component**<br>

It’s easy to accidentally register the wrong component.
For example, you might register ScoresComponent instead of
ScorecardComponent.

**The solution:** If the component doesn’t show up, make sure the **containing
component’s Dart file includes the right component.**
</aside>

### Problems?

Check your code against the solution
in the `2-starteasy` directory.

