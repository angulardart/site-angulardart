---
layout: codelab
title: "Step 3: Add an Input Field"
description: "Add an input field to your Angular app."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/ng2/4-buttonbadge
  title: "Step 4: Add a Button"
prevpage:
  url: /codelabs/ng2/2-blankbadge
  title: "Step 2: Add a Pirate Badge Component"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

In this step, you add an input field.
As the user types into the input field,
the badge updates.

## <i class="fa fa-anchor"> </i> Edit badge_component.html.

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">

Add a div containing an input field to the top of the file:

{% prettify html %}
[[highlight]]<div class="widgets">[[/highlight]]
  [[highlight]]<input (input)="updateBadge($event.target.value)"[[/highlight]]
         [[highlight]]type="text" maxlength="15">[[/highlight]]
[[highlight]]</div>[[/highlight]]

<div class="badge">
  <div class="greeting">Arrr! Me name is</div>
  <div class="name">{{badgeName}}</div>
</div>
{% endprettify %}

</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `<input...>` defines an HTML5 input element.

* The `(input)="updateBadge(...)"` text creates an _event binding_.

* The target of the event appears to the left of the equals
  sign in parentheses, `(input)`.  This event binding listens
  for an input event on the input field.

* The _template statement_, `updateBadge($event.target.value)`,
  appears (in quotes) to the right of the equals sign.

* This template statement calls a method called `updateBadge()`
  that you'll define soon in Dart code. The argument is the value
  that the user entered.

* As you can see, a template statement can use
  functions and variables defined in a component's Dart code.

* The event object, `$event`, contains the value of the raised event.
  In this example, the event object represents the DOM event object,
  so the new value resides in `$event.target.value`.

* The template statement executes whenever an input event occurs on this
  element.

* By convention, a template statement is short&mdash;more
  complex logic should be placed in a function and called
  from the template statement.

* The `maxLength="15"` text limits user input to 15 characters.

</div> </div>

## <i class="fa fa-anchor"> </i> Edit badge_component.dart.

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">

Delete the hardcoded badge name and add an event handler,
`updateBadge()`, to the BadgeComponent class.

{% prettify dart %}
class BadgeComponent {
  String badgeName = [[highlight]]''[[/highlight]];
  [[highlight]]void updateBadge(String inputName) {[[/highlight]]
    [[highlight]]badgeName = inputName;[[/highlight]]
  [[highlight]]}[[/highlight]]
}
{% endprettify %}

</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* When an input event occurs on the badge component,
  Angular calls `updateBadge()` with the value entered by the user.

</div> </div>

## <i class="fa fa-anchor"> </i> Test it!

<div class="trydart-step-details" markdown="1">

Click run ( {% img 'green-run.png' %} ) to run the app.
Type into the input field.
The name badge updates to display what you've typed.
</div>

<div class="trydart-step-details" markdown="1">
<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Tip** <br>
If your changes don't show up, try forcing a reload.
To do this, hold the Shift key while clicking the reload button
<img src="images/Chrome-reload-button.png" alt="the round reload button">.
</aside>
</div>

## Problems?

Look in WebStorm's window for possible errors.
If that fails, look in your browser's JavaScript console.
In Dartium or Chrome, bring up the console using
**View > Developer > JavaScript Console**.

Finally, if you still haven't found the problem
check your code against the files in
[3-inputnamebadge](https://github.com/dart-lang/one-hour-codelab/tree/master/ng2/3-inputnamebadge).

* [lib/badge_component.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/3-inputnamebadge/lib/badge_component.dart)
* [lib/badge_component.html](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/3-inputnamebadge/lib/badge_component.html)
