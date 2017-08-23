---
layout: angular
title: The Hero Editor
description: Build a simple hero editor.
prevpage:
  title: "The Starter App"
  url: /angular/tutorial/toh-pt0
nextpage:
  title: Master/Detail
  url: /angular/tutorial/toh-pt2
---
<?code-excerpt path-base="toh-1"?>
In this part of the tutorial, you'll modify the starter app to display
information about a hero. Then you'll add the ability to edit the hero's data.
When you're done, the app should look like this <live-example></live-example>.

## Where you left off

Before you start writing code, let's verify that you have the following structure.
If not, you'll need to go back and follow the [setup](toh-pt0) instructions
on the previous page.

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.dart
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

{% include_relative _keep-app-running.md %}

## Show the hero

Add two properties to the `AppComponent`: a `title` property for the app name and a `hero` property
for a hero named "Windstorm."

<?code-excerpt "lib/app_component_1.dart (AppComponent class)" region="app-component-1" title?>
```
  class AppComponent {
    String title = 'Tour of Heroes';
    var hero = 'Windstorm';
  }
```

Now update the template in the `@Component` annotation with data bindings to these new properties.

<?code-excerpt "lib/app_component_1.dart (@Component)" region="show-hero" title?>
```
  template: '<h1>{!{title}!}</h1><h2>{!{hero}!} details!</h2>',
```

Refresh the browser, and the page displays the title and hero name.

The double curly braces are Angular's *interpolation binding* syntax.
These interpolation bindings present the component's `title` and `hero` property values,
as strings, inside the HTML header tags.

<div class="l-sub-section" markdown="1">
  Read more about interpolation in the [Displaying Data](../guide/displaying-data.html) page.
</div>

### Hero object

The hero needs more properties.
Convert the `hero` from a literal string to a class.

Create a `Hero` class with `id` and `name` properties.
Add these properties near the top of the `app_component.dart` file, just below the import statement.

<?code-excerpt "lib/app_component.dart (Hero class)" region="hero-class-1" title?>
```
  class Hero {
    final int id;
    String name;

    Hero(this.id, this.name);
  }
```

In the `AppComponent` class, refactor the component's `hero` property to be of type `Hero`,
then initialize it with an `id` of `1` and the name `Windstorm`.

<?code-excerpt "lib/app_component.dart (hero property)" region="hero-property-1" title?>
```
  Hero hero = new Hero(1, 'Windstorm');
```

Because you changed the hero from a string to an object,
update the binding in the template to refer to the hero's `name` property.

<?code-excerpt "lib/app_component_1.dart" region="show-hero-2"?>
```
  template: '<h1>{!{title}!}</h1><h2>{!{hero.name}!} details!</h2>',
```

Refresh the browser, and the page continues to display the hero's name.

### Adding HTML with multi-line template strings

To show all of the hero's properties,
add a `<div>` for the hero's `id` property and another `<div>` for the hero's `name`.
To keep the template readable, place each `<div>` on its own line.

<?code-excerpt "lib/app_component_1.dart (multi-line strings)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <h2>{!{hero.name}!} details!</h2>
    <div><label>id: </label>{!{hero.id}!}</div>
    <div><label>name: </label>{!{hero.name}!}</div>
  ''',
```

## Edit the hero name

Users should be able to edit the hero name in an `<input>` textbox.
The textbox should both _display_ the hero's `name` property
and _update_ that property as the user types.

You need a two-way binding between the `<input>` form element and the `hero.name` property.

### Two-way binding

Refactor the hero name in the template so it looks like this:

<?code-excerpt "lib/app_component_1.dart" region="name-input"?>
```
  <div>
    <label>name: </label>
    <input [(ngModel)]="hero.name" placeholder="name">
  </div>
```

`[(ngModel)]` is the Angular syntax to bind the `hero.name` property
to the textbox.
Data flows _in both directions:_ from the property to the textbox,
and from the textbox back to the property.

<div class="l-sub-section" markdown="1">
  Read more about `ngModel` in the
  [Forms](../guide/forms.html#ngModel) and
  [Template Syntax](../guide/template-syntax.html#ngModel) pages.
</div>

### @Component(directives: ...)

Unfortunately, immediately after this change, the **application breaks**!
If you open the browser console and refresh the page, you'll see Angular
complaining.  To know why, look at the `pub serve` output. The template
compiler doesn't recognize `ngModel`, and issues a parse error for
`AppComponent`:

```
  Can't bind to 'ngModel' since it isn't a known native property or known directive. Please fix typo or add to directives list.
  [(ngModel)]="hero.name"
  ^^^^^^^^^^^^^^^^^^^^^^^
```

Although `NgModel` is a valid Angular directive, it isn't available by default.

Before you can use Angular directives (like `ngModel`) in a template,
you need to list them in the `directives` argument of your component's
`@Component` annotation. Although you can list directives individually,
it is more convenient to include all common directives in one go using
the [COMMON_DIRECTIVES](/api/angular2/angular2/COMMON_DIRECTIVES-constant)
list:

<?code-excerpt "lib/app_component.dart (directives)" title?>
```
  @Component(
    selector: 'my-app',
    /* . . . */
    directives: const [COMMON_DIRECTIVES],
  )
```

Refresh the browser and the app should work again.
You can edit the hero's name and see the changes reflected immediately in the `<h2>` above the textbox.

## The road you've travelled

Take stock of what you've built.

* The Tour of Heroes app uses the double curly braces of interpolation (a type of one-way data binding)
  to display the app title and properties of a `Hero` object.
* You wrote a multi-line template using Dart's template strings to make the template readable.
* You added a two-way data binding to the `<input>` element
  using the built-in `ngModel` directive. This binding both displays the hero's name and allows users to change it.
* You added [COMMON_DIRECTIVES](/api/angular2/angular2/COMMON_DIRECTIVES-constant)
  to the `directives` argument of the app's `@Component` annotation so that Angular knows
  where `ngModel` is defined.

Your app should look like this <live-example></live-example>.

Here's the complete `app_component.dart` as it stands now:

<?code-excerpt "lib/app_component.dart" title linenums?>
```
  import 'package:angular2/angular2.dart';

  class Hero {
    final int id;
    String name;

    Hero(this.id, this.name);
  }

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <h2>{!{hero.name}!} details!</h2>
      <div><label>id: </label>{!{hero.id}!}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero.name" placeholder="name">
      </div>''',
    directives: const [COMMON_DIRECTIVES],
  )
  class AppComponent {
    String title = 'Tour of Heroes';
    Hero hero = new Hero(1, 'Windstorm');
  }
```

## The road ahead

In the [next tutorial page](./toh-pt2.html), you'll build on the Tour of Heroes app to display a list of heroes.
You'll also allow the user to select heroes and display their details.
You'll learn more about how to retrieve lists and bind them to the template.
