---
layout: codelab
title: "Step 6: Read a  JSON File"
description: "Write asynchronous code to read a JSON file."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/ng2/what-next
  title: "What Next?"
prevpage:
  url: /codelabs/ng2/5-piratenameservice
  title: "Step 5: Create a Name Service"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

In this final step, you learn about Dart's support for
asynchronous file I/O as you modify the pirate name service to fetch
the names and appellations from a JSON file on www.dartlang.org.

## <i class="fa fa-anchor"> </i> Edit name_service.dart.

<div class="trydart-step-details" markdown="1">
Add imports to the top.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
[[highlight]]import 'dart:async';[[/highlight]]
[[highlight]]import 'dart:convert';[[/highlight]]
[[highlight]]import 'dart:html';[[/highlight]]
import 'dart:math' show Random;

import 'package:angular2/core.dart';
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* The `dart:async` library provides for asynchronous programming.

* The `dart:convert` library provides convenient access to the most
  commonly used JSON conversion utilities.

* The `dart:html` library contains the classes for all DOM element
  types, in addition to functions for accessing the DOM.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a constant defining the location of the JSON file.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
import 'package:angular2/core.dart';

[[highlight]]const _namesPath =[[/highlight]]
    [[highlight]]'https://www.dartlang.org/codelabs/darrrt/files/piratenames.json';[[/highlight]]
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

{% comment %}
<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* x
{% endcomment %}

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Replace `_names` and `_appellations` with empty lists.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  static final Random _indexGen = new Random();

  final _names = [[highlight]]<String>[];[[/highlight]]
  final _appellations = [[highlight]]<String>[];[[/highlight]]

  static String _randomFirstName() {
    return (_names[_indexGen.nextInt(_names.length)]);
  }
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `<String>[]` is equivalent to `new List<String>()`.

* You could keep the `List` type on `_names` and `_appellations`,
  but you don't need to.

* A generic list can contain any kind of object,
  but this list is typed to indicate that it only contains strings.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a function, `readyThePirates()`,
to read the names and appellations from the JSON file.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  ...
  String _randomAppellation() {
    return (_appellations[_indexGen.nextInt(_appellations.length)]);
  }

  [[highlight]]Future readyThePirates() async {[[/highlight]]
    [[highlight]]if (_names.isNotEmpty && _appellations.isNotEmpty) return;[[/highlight]]
    [[highlight]]var jsonString = await HttpRequest.getString(_namesPath);[[/highlight]]
    [[highlight]]var pirateNames = JSON.decode(jsonString);[[/highlight]]
    [[highlight]]_names.addAll(pirateNames['names']);[[/highlight]]
    [[highlight]]_appellations.addAll(pirateNames['appellations']);[[/highlight]]
  [[highlight]]}[[/highlight]]
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `readyThePirates` is marked with the `async` keyword.
  An asynchronous function returns a Future immediately,
  so the caller has the opportunity to do something else while
  waiting for the function to complete its work.

* The `Future` class (from `dart:async`)
  provides a way to get a value in the future.
  (Dart Futures are similar to JavaScript Promises.)

* `HttpRequest` is a `dart:html` utility for retrieving data from a URL.

* `getString()` is a convenience method for doing a simple GET
  request that returns a string.

* `getString()` is asynchronous. It sets up the GET request
  and returns a Future that _completes_ when the GET request
  is finished.

* The `await` expression, which can only be used in an async function,
  causes execution to pause until the GET request is finished
  (when the Future returned by `getString()` completes).

* After the GET request returns a JSON string, the code extracts
  pirate names and appellations from the string.

</div></div>

## <i class="fa fa-anchor"> </i> Edit badge_component.html.

<div class="trydart-step-details" markdown="1">
Enable the input field depending on the value of a property.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify html %}{% raw %}
<div class="widgets">
  <input [[highlight]][disabled]="!isInputEnabled"[[/highlight]] (input)="updateBadge($event.target.value)"
         type="text" maxlength="15">
  <button [disabled]="!isButtonEnabled" (click)="generateBadge()">
    {{buttonText}}
  </button>
{% endraw %}{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `isInputEnabled` refers to a property that you'll add to this component's
  Dart file.

</div></div>

## <i class="fa fa-anchor"> </i> Edit badge_component.dart.

Load the pirate names and appellations from a JSON file.
When successfully loaded, enable the UI.

<div class="trydart-step-details" markdown="1">
At startup, disable the button and input field.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class BadgeComponent {
  final NameService _nameService;
  String badgeName = '';
  String buttonText = 'Aye! Gimme a name!';
  bool isButtonEnabled = [[highlight]]false[[/highlight]];
  [[highlight]]bool isInputEnabled = false[[/highlight]];
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

{% comment %}

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

&nbsp; {% comment %} non-breaking space required for bootstrap/markdown bogosity {% endcomment %}
{% endcomment %}

</div></div>


<div class="trydart-step-details" markdown="1">

<hr>

Add a function to get the names from the JSON file,
handling both success and failure.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class BadgeComponent [[highlight]]implements OnInit[[/highlight]] {
  ...
  bool isButtonEnabled = false;
  bool isInputEnabled = false;

  BadgeComponent(this._nameService);

  [[highlight]]ngOnInit() async {[[/highlight]]
    [[highlight]]try {[[/highlight]]
      [[highlight]]await _nameService.readyThePirates();[[/highlight]]
      [[highlight]]//on success[[/highlight]]
      [[highlight]]isButtonEnabled = true;[[/highlight]]
      [[highlight]]isInputEnabled = true;[[/highlight]]
    [[highlight]]} catch (arrr) {[[/highlight]]
      [[highlight]]badgeName = 'Arrr! No names.';[[/highlight]]
      [[highlight]]print('Error initializing pirate names: $arrr');[[/highlight]]
    [[highlight]]}[[/highlight]]
  [[highlight]]}[[/highlight]]
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `ngOnInit()` is one of the
  [lifecycle hooks](https://angular.io/docs/dart/latest/guide/lifecycle-hooks.html)
  available in Angular. Angular calls `ngOnInit()` after the component
  is initialized.

* Mark the function body with `async`, so this function can use
  the `await` keyword.

* Asynchronous functions must return a Future, so you can either
  specify a Future return type or leave it blank.

* Call the `readyThePirates()` function, which immediately returns
  a Future.

* When the Future returned by `readyThePirates()` successfully completes,
  set up the UI.

* Use `try` and `catch` to detect and handle errors.

</div></div>

## <i class="fa fa-anchor"> </i> Test it!

<div class="trydart-step-details" markdown="1">

Click run ( {% img 'green-run.png' %} ) to run the app.

The app should work as before, but this time the pirate name is
constructed from the JSON file.
</div>

## Problems?

Look in WebStorm's window for possible errors.
If that fails, look in your browser's JavaScript console.
In Dartium or Chrome, bring up the console using
**View > Developer > JavaScript Console**.

Finally, if you still haven't found the problem
check your code against the files in
[6-readjsonfile](https://github.com/dart-lang/one-hour-codelab/tree/master/ng2/6-readjsonfile).

* [lib/badge_component.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/6-readjsonfile/lib/badge_component.dart)
* [lib/name_service.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/6-readjsonfile/lib/name_service.dart)
