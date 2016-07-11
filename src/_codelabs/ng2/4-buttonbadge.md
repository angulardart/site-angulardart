---
layout: codelab
title: "Step 4: Add a Button"
description: "Add a button to your Angular app."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/ng2/5-piratenameservice
  title: "Step 5: Create a Name Service"
prevpage:
  url: /codelabs/ng2/3-inputnamebadge
  title: "Step 3: Add an Input Field"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

In this step, you add a button that's enabled
when the input field is empty.
When the user clicks the button,
the app displays "Anne Bonney" on the badge.

## <i class="fa fa-anchor"> </i> Edit badge_component.html.

<div class="trydart-step-details" markdown="1">
Add a button to the `widgets` div.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify html %}{% raw %}
<div class="widgets">
  <input (input)="updateBadge($event.target.value)"
         type="text" maxlength="15">
  [[highlight]]<button [disabled]="!isButtonEnabled" (click)="generateBadge()">[[/highlight]]
    [[highlight]]{{buttonText}}[[/highlight]]
  [[highlight]]</button>[[/highlight]]
</div>
<div class="badge">
  <div class="greeting">Arrr! Me name is</div>
  <div class="name">{{badgeName}}</div>
</div>
{% endraw %}{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* Square brackets `[]` specify a _property_ on the element.
  This example references the `disabled` property on the button.

* The `[disabled] = "!isButtonEnabled"` text enables or disables
  the button element, based on the value of the corresponding Dart variable.

* You will add `isButtonEnabled` to the Dart code in the next section.

* The `(click)="generateBadge()"` text sets up an event handler for button
  clicks. Whenever the user clicks the button, the `generateBadge()`
  method is called.
  You'll add the `generateBadge()` event handler to the Dart
  code in the next section.

* The `buttonText` variable will soon be defined in the Dart code.
  The {% raw %}`<button ...> {{buttonText}} </button>`{% endraw %}
  code tells Angular to display the value of `buttonText` on the button.

&nbsp; {% comment %} non-breaking space required for bootstrap/markdown bogosity {% endcomment %}

</div></div>

## <i class="fa fa-anchor"> </i> Edit badge_component.dart.

<div class="trydart-step-details" markdown="1">
Add two variables to the BadgeComponent class.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">

{% prettify dart %}
class BadgeComponent {
  String badgeName = '';
  [[highlight]]String buttonText = 'Aye! Gimme a name!';[[/highlight]]
  [[highlight]]bool isButtonEnabled = true;[[/highlight]]
  ...
}
{% endprettify %}

</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* All instance variables defined in an Angular component are visible
  to the template for that component.

* As you've seen, the HTML template uses `isButtonEnabled`
  when determining whether to display the button.

&nbsp; {% comment %} non-breaking space required for bootstrap/markdown bogosity {% endcomment %}

</div> </div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a `generateBadge()` function.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details">
{% prettify dart %}
@Component(selector: 'pirate-badge', templateUrl: 'badge_component.html')
class BadgeComponent {
  String badgeName = '';
  String buttonText = 'Aye! Gimme a name!';
  bool isButtonEnabled = true;

  [[highlight]]void generateBadge() {[[/highlight]]
    [[highlight]]badgeName = 'Anne Bonney';[[/highlight]]
  [[highlight]]}[[/highlight]]

  void updateBadge(String inputName) {
    badgeName = inputName;
  }
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* Clicking the button displays "Anne Bonney" on the pirate badge.
  In Step 5, you replace this with more interesting logic.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Modify the `updateBadge()` function to toggle the button's
state based on whether there is text in the input field.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details">
{% prettify dart %}
class BadgeComponent {
  ...
  void updateBadge(String inputName) {
    badgeName = inputName;
    [[highlight]]if (inputName.trim().isEmpty) {[[/highlight]]
      [[highlight]]buttonText = 'Aye! Gimme a name!';[[/highlight]]
      [[highlight]]isButtonEnabled = true;[[/highlight]]
    [[highlight]]} else {[[/highlight]]
      [[highlight]]buttonText = 'Arrr! Write yer name!';[[/highlight]]
      [[highlight]]isButtonEnabled = false;[[/highlight]]
    [[highlight]]}[[/highlight]]
  }
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* Enable the button if the input field is empty,
  otherwise disable it.

* The text on the button also changes depending on whether it's
  enabled.

</div></div>

## <i class="fa fa-anchor"> </i> Test it!

<div class="trydart-step-details" markdown="1">

Click run ( {% img 'green-run.png' %} } to run the app.

Type in the input field. The name badge updates to display what you've typed,
and the button is disabled.  Remove the text from the input field and the
button is enabled. Click the button. The name badge displays "Anne Bonney".

## Problems?

Look in WebStorm's window for possible errors.
If that fails, look in your browser's JavaScript console.
In Dartium or Chrome, bring up the console using
**View > Developer > JavaScript Console**.

Finally, if you still haven't found the problem
check your code against the files in
[4-buttonbadge](https://github.com/dart-lang/one-hour-codelab/tree/master/ng2/4-buttonbadge).

* [lib/badge_component.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/4-buttonbadge/lib/badge_component.dart)
* [lib/badge_component.html](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/4-buttonbadge/lib/badge_component.html)
