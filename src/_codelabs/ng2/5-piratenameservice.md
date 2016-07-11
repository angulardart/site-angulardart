---
layout: codelab
title: "Step 5: Create a Name Service"
description: "Take your first step to learning Dart fast."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/ng2/6-readjsonfile
  title: "Step 6: Read a JSON File"
prevpage:
  url: /codelabs/ng2/4-buttonbadge
  title: "Step 4: Add a Button"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

A proper pirate name consists of a name and an appellation,
such as "Margy the Fierce" or "Renée the Fighter".
In this step, you learn about Angular's support for
[dependency injection](https://angular.io/docs/dart/latest/guide/dependency-injection.html)
as you add a service that returns a pirate name.

## <i class="fa fa-anchor"> </i> Create a class for the name service.

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">

<ol markdown="1">
<li markdown="1">In WebStorm's Project view,
   right-click the `lib` directory and
   select **New > Dart File** from the menu that pops up.
</li>
<li markdown="1">Enter "name_service" as the filename
   and click **OK**.
</li>
</ol>
</div>

</div> <div class="col-md-5" markdown="1">

{% comment %}
<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* x
{% endcomment %}

&nbsp; {% comment %} non-breaking space required for bootstrap/markdown bogosity {% endcomment %}
</div> </div>

## <i class="fa fa-anchor"> </i> Edit name_service.dart.

<div class="trydart-step-details" markdown="1">
Add imports to the file.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
[[highlight]]import 'dart:math' show Random;[[/highlight]]

[[highlight]]import 'package:angular2/core.dart';[[/highlight]]
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* The `show` keyword lets you import only the classes, top-level
  functions, or top-level variables that you need.

* `Random` provides a random number generator.

* The `angular2/core.dart` library gives you access to the
  `Injectable` class that you'll add next.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a class declaration below the import and annotate it with
`@Injectable()`.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
[[highlight]]@Injectable()[[/highlight]]
[[highlight]]class NameService {[[/highlight]]
[[highlight]]}[[/highlight]]
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* Dependency injection, also referred to as _DI_, allows you to write
  more robust code that is easier to test.

* When Angular detects the `@Injectable()` annotation,
  it generates necessary metadata so that the annotated object is injectable.

* Later, you'll add a constructor to BadgeComponent
  that enables injecting an instance of NameService.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Create a class-level Random object.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  [[highlight]]static final Random _indexGen = new Random();[[/highlight]]
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* The `static` annotation makes the field a class variable,
  rather than an instance variable.
  Therefore, the random number generator is shared with all
  instances of this class.

* `final` variables must be initialized and cannot change.

* Private variables start with underscore (`_`);
  Dart has no `private` keyword.

* The `new` keyword indicates a call to the constructor.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Create two static lists within the class that provide a small
collection of names and appellations to choose from.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  static final Random _indexGen = new Random();

  [[highlight]]final List _names = [[[/highlight]]
    [[highlight]]'Anne', 'Mary', 'Jack', 'Morgan', 'Roger',[[/highlight]]
    [[highlight]]'Bill', 'Ragnar', 'Ed', 'John', 'Jane' ];[[/highlight]]
  [[highlight]]final List _appellations = [[[/highlight]]
    [[highlight]]'Jackal', 'King', 'Red', 'Stalwart', 'Axe',[[/highlight]]
    [[highlight]]'Young', 'Brave', 'Eager', 'Wily', 'Zesty'];[[/highlight]]
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* Lists are built into the language and are similar to arrays in
  other languages.
  These lists are created using list literals.

* The `List` class provides the API for lists.

</div></div>

<div class="trydart-step-details" markdown="1">
<hr>

Provide helper methods that retrieve a randomly chosen first name
and appellation.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  ...
  final List _appellations = [
    'Jackal', 'King', 'Red', 'Stalwart', 'Axe',
    'Young', 'Brave', 'Eager', 'Wily', 'Zesty'];

  [[highlight]]String _randomFirstName()[[/highlight]]
      [[highlight]]=> _names[_indexGen.nextInt(_names.length)];[[/highlight]]

  [[highlight]]String _randomAppellation() =>[[/highlight]]
      [[highlight]]_appellations[_indexGen.nextInt(_appellations.length)];[[/highlight]]
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* The code uses a random number as an index into the list.

* The fat arrow ( `=> expr;` ) syntax is a shorthand for
  `{ return expr; }`.

* The `nextInt()` function gets a new random integer
from the random number generator.

* Use square brackets (`[` and `]`) to index into a list.

* The `length` property returns the number of items in a list.

</div> </div>

<div class="trydart-step-details" markdown="1">

<hr>

Provide a method that gets a pirate name.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class NameService {
  ...
  String _randomAppellation() =>
      _appellations[_indexGen.nextInt(_appellations.length)];

  [[highlight]]String getPirateName(String firstName) {[[/highlight]]
    [[highlight]]if (firstName == null || firstName.trim().isEmpty) {[[/highlight]]
      [[highlight]]firstName = _randomFirstName();[[/highlight]]
    [[highlight]]}[[/highlight]]

    [[highlight]]return '$firstName the ${_randomAppellation()}';[[/highlight]]
  }
}
{% endprettify %}
</div>

</div><div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* String interpolation (`'$firstName the ${_randomAppellation()}'`)
  lets you easily build strings from other objects.
  To insert the value of an expression, use `${expr}`.
  You can drop the curly brackets when the expression
  is an identifier: `$id`.

* Dart's string interpolation is different from Angular's expression
  interpolation.

</div></div>

## <i class="fa fa-anchor"> </i> Edit badge_component.dart.

Hook up the pirate name service to the pirate badge component.

<div class="trydart-step-details" markdown="1">
Import the pirate name service.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
import 'package:angular2/core.dart';
[[highlight]]import 'name_service.dart';[[/highlight]]
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

Add `NameService` as a provider by adding the text
 `, providers: const [NameService]`
to the `@Component` annotation. After formatting,
it should look as follows:
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
@Component(
    selector: 'pirate-badge',
    templateUrl: 'badge_component.html',
    styleUrls: const ['badge_component.css'][[highlight]],[[/highlight]]
    [[highlight]]providers: const [NameService][[/highlight]])
class BadgeComponent {
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* The `providers` part of `@Component` tells Angular what objects are
  available for injection in this component.

* You can reformat your code by right-clicking in the editor view
  and selecting **Reformat with Dart Style**. For more information,
  see [step 2](2-blankbadge).

</div></div>


<div class="trydart-step-details" markdown="1">

<hr>

Add a `_nameService` instance variable.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
@Component(
    selector: 'pirate-badge',
    templateUrl: 'badge_component.html',
    providers: const [NameService])
class BadgeComponent {
  [[highlight]]final NameService _nameService;[[/highlight]]
  String badgeName = '';
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* A final variable can be set only once.
  `_nameService` is a final field&ndash;an instance
  variable that's declared `final`. Final fields must
  be set before the constructor body runs.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a constructor that assigns a value to `_nameService`.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class BadgeComponent {
  final NameService _nameService;
  String badgeName = '';
  String buttonText = 'Aye! Gimme a name!';
  bool isButtonEnabled = true;

  [[highlight]]BadgeComponent(this._nameService);[[/highlight]]
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

<ul markdown="1">

<li markdown="1">Whenever Angular creates a pirate-badge component,
  Angular's dependency injection framework supplies the
  NameService object that the BadgeComponent
  constructor needs.
</li>

<li markdown="1">The `@Injectable` annotation on NameService,
  combined with the `providers` list containing NameService,
  lets Angular create the NameService object.
</li>

<li markdown="1"> If you've used Java, you've seen `this` before.
  You can access local instance variables using `this`. Dart only
  uses `this` when necessary, otherwise Dart style omits it.

</li>

<li markdown="1"> Note that the BadgeComponent constructor has no body.
  The `this._nameService` text in the argument list
  assigns the passed-in parameter to the `_nameService` variable.
  Since the assignment happens in the argument list,
  and the constructor doesn't need to do anything else,
  the body isn't needed.

  If `_nameService` weren't a final variable,
  this code could be replaced with:

{% prettify dart %}
BadgeComponent(var nameService) {
  _nameService = nameService;
}
{% endprettify %}

  But since `_nameService` is final, it has to be initialized
  when it's declared, or in the constructor's argument list.
</li>
</ul>

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Add a `setBadgeName()` method.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class BadgeComponent {
  ...
  [[highlight]]void setBadgeName([String newName = '']) {[[/highlight]]
    [[highlight]]if (newName == null) return;[[/highlight]]
    [[highlight]]badgeName = _nameService.getPirateName(newName);[[/highlight]]
  [[highlight]]}[[/highlight]]
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* `[String newName = '']` is an optional positional parameter with a default
  value of the empty string.

</div></div>

<div class="trydart-step-details" markdown="1">

<hr>

Modify the `generateBadge()` and `updateBadge()`  methods.
</div>

<div class="row"> <div class="col-md-7" markdown="1">

<div class="trydart-step-details" markdown="1">
{% prettify dart %}
class BadgeComponent implements OnInit {
  ...
  void generateBadge() {
    [[highlight]]setBadgeName();[[/highlight]]
  }

  void updateBadge(String inputName) {
    [[highlight]]setBadgeName(inputName);[[/highlight]]
    if (inputName.trim().isEmpty) {
      buttonText = 'Aye! Gimme a name!';
      isButtonEnabled = true;
    } else {
      buttonText = 'Arrr! Write yer name!';
      isButtonEnabled = false;
    }
  }
  ...
}
{% endprettify %}
</div>

</div> <div class="col-md-5" markdown="1">

{% comment %}
<i class="fa fa-key key-header"> </i> <strong> Key information </strong>

* x
{% endcomment %}

</div></div>

## <i class="fa fa-anchor"> </i> Test it!

<div class="trydart-step-details" markdown="1">

Click run ( {% img 'green-run.png' %} ) to run the app.

Click the button&mdash;each click displays a new pirate name composed
of a name and an appellation.

## Problems?

Look in WebStorm's window for possible errors.
If that fails, look in your browser's JavaScript console.
In Dartium or Chrome, bring up the console using
**View > Developer > JavaScript Console**.

Finally, if you still haven't found the problem
check your code against the files in
[5-piratenameservice](https://github.com/dart-lang/one-hour-codelab/tree/master/ng2/5-piratenameservice).

* [lib/badge_component.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/5-piratenameservice/lib/badge_component.dart)
* [lib/name_service.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/master/ng2/5-piratenameservice/lib/name_service.dart)
