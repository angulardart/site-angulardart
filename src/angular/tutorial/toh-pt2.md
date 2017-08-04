---
layout: angular
title: Master/Detail
description: Build a master/detail page with a list of heroes.
prevpage:
  title: The Hero Editor
  url: /angular/tutorial/toh-pt1
nextpage:
  title: Multiple Components
  url: /angular/tutorial/toh-pt3
---
<!-- FilePath: src/angular/tutorial/toh-pt2.md -->
<?code-excerpt path-base="toh-2"?>

In this page, you'll expand the Tour of Heroes app to display a list of heroes, and
allow users to select a hero and display the hero's details.

When you're done with this page, the app should look like this <live-example></live-example>.

## Where you left off

Before you continue with this page of the Tour of Heroes,
verify that you have the following structure after [The Hero Editor](./toh-pt1.html) page.
If your structure doesn't match, go back to that page to figure out what you missed.

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

## Displaying heroes

To display a list of heroes, you'll add heroes to the view's template.

### Create heroes

Create a list of ten heroes.

<?code-excerpt "lib/app_component.dart (hero list)" region="hero-array" title?>
```
  final mockHeroes = <Hero>[
    new Hero(11, 'Mr. Nice'),
    new Hero(12, 'Narco'),
    new Hero(13, 'Bombasto'),
    new Hero(14, 'Celeritas'),
    new Hero(15, 'Magneta'),
    new Hero(16, 'RubberMan'),
    new Hero(17, 'Dynama'),
    new Hero(18, 'Dr IQ'),
    new Hero(19, 'Magma'),
    new Hero(20, 'Tornado')
  ];
```

The `mockHeroes` list is of type `Hero`, the class defined in the previous page.
Eventually this app will fetch the list of heroes from a web service, but for now
you can display mock heroes.

### Expose heroes

Create a public property in `AppComponent` that exposes the heroes for binding.


<?code-excerpt "lib/app_component_1.html (hero list property)" region="hero-array-1" title?>
```
  final List<Hero> heroes = mockHeroes;
```

<div class="l-sub-section" markdown="1">
  The hero data is separated from the class implementation
  because ultimately the hero names will come from a data service.
</div>

### Display hero names in a template

To display the hero names in an unordered list,
insert the following chunk of HTML below the title and above the hero details.


<?code-excerpt "lib/app_component_1.html (heroes template)" region="heroes-template-1" title?>
```
  <h2>My Heroes</h2>
  <ul class="heroes">
    <li>
      <!-- each hero goes here -->
    </li>
  </ul>
```

Now you can fill the template with hero names.

### List heroes with ngFor

The goal is to bind the list of heroes in the component to the template, iterate over them,
and display them individually.

Modify the `<li>` tag by adding the built-in directive `*ngFor`.

<?code-excerpt "lib/app_component_1.html (ngFor)" region="heroes-ngfor-1" title?>
```
  <li *ngFor="let hero of heroes">
```


<div class="l-sub-section" markdown="1">
  The (`*`) prefix to `ngFor` is a critical part of this syntax.
  It indicates that the `<li>` element and its children
  constitute a master template.

  The `ngFor` directive iterates over the component's `heroes` list
  and renders an instance of this template for each hero in that list.

  The `let hero` part of the expression identifies `hero` as the  template input variable,
  which holds the current hero item for each iteration.
  You can reference this variable within the template to access the current hero's properties.

  Read more about `ngFor` and template input variables in the
  [Showing a list property with *ngFor](../guide/displaying-data.html#ngFor) section of the
  [Displaying Data](../guide/displaying-data.html) page and the
  [ngFor](../guide/template-syntax.html#ngFor) section of the
  [Template Syntax](../guide/template-syntax.html) page.
</div>

Within the `<li>` tags, add content
that uses the `hero` template variable to display the hero's properties.


<?code-excerpt "lib/app_component_1.html (ngFor template)" region="ng-for" title?>
```
  <li *ngFor="let hero of heroes">
    <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
  </li>
```

Refresh the browser, and a list of heroes appears.

### Style the heroes

Users should get a visual cue of which hero they are hovering over and which hero is selected.

To add styles to your component, set the `styles` argument of the `@Component` annotation
to the following CSS classes:

<?code-excerpt "lib/app_component.dart (styles)" region="styles" title?>
```
  styles: const [
    '''
      .selected {
        background-color: #CFD8DC !important;
        color: white;
      }
      .heroes {
        margin: 0 0 2em 0;
        list-style-type: none;
        padding: 0;
        width: 15em;
      }
      .heroes li {
        cursor: pointer;
        position: relative;
        left: 0;
        background-color: #EEE;
        margin: .5em;
        padding: .3em 0em;
        height: 1.6em;
        border-radius: 4px;
      }
      .heroes li.selected:hover {
        color: white;
      }
      .heroes li:hover {
        color: #607D8B;
        background-color: #EEE;
        left: .1em;
      }
      .heroes .text {
        position: relative;
        top: -3px;
      }
      .heroes .badge {
        display: inline-block;
        font-size: small;
        color: white;
        padding: 0.8em 0.7em 0em 0.7em;
        background-color: #607D8B;
        line-height: 1em;
        position: relative;
        left: -1px;
        top: -4px;
        height: 1.8em;
        margin-right: .8em;
        border-radius: 4px 0px 0px 4px;
      }
    '''
  ],
```

Adding these styles makes the file much longer. In a later page you'll move the styles to a separate file.

When you assign styles to a component, they are scoped to that specific component.
These styles apply only to the `AppComponent` and don't affect the outer HTML.

The template for displaying heroes should look like this:


<?code-excerpt "lib/app_component_1.html (styled heroes)" region="heroes-styled" title?>
```
  <h2>My Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
```

## Selecting a hero

The app now displays a list of heroes as well as a single hero in the details view. But
the list and the details view are not connected.
When users select a hero from the list, the selected hero should appear in the details view.
This UI pattern is known as "master/detail."
In this case, the _master_ is the heroes list and the _detail_ is the selected hero.

Next you'll connect the master to the detail through a `selectedHero` component property,
which is bound to a click event.

### Handle click events

Add a click event binding to the `<li>` like this:


<?code-excerpt "lib/app_component_1.html (template excerpt)" region="selectedHero-click" title?>
```
  <li *ngFor="let hero of heroes" (click)="onSelect(hero)">
    <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
  </li>
```

The parentheses identify the `<li>` element's  `click` event as the target.
The `onSelect(hero)` expression calls the  `AppComponent` method, `onSelect()`,
passing the template input variable `hero`, as an argument.
That's the same `hero` variable you defined previously in the `ngFor` directive.

<div class="l-sub-section" markdown="1">
  Learn more about event binding at the
  [User Input](../guide/user-input.html) page and the
  [Event binding](../guide/template-syntax.html#event-binding) section of the
  [Template Syntax](../guide/template-syntax.html) page.
</div>

### Add a click handler to expose the selected hero

You no longer need the `hero` property because you're no longer displaying a single hero; you're displaying a list of heroes.
But the user will be able to select one of the heroes by clicking on it.
So replace the `hero` property with this simple `selectedHero` property:

<?code-excerpt "lib/app_component.dart (selectedHero)" region="selected-hero" title?>
```
  Hero selectedHero;
```

The hero names should all be unselected before the user picks a hero, so
you won't initialize the `selectedHero` as you did with `hero`.

Add an `onSelect()` method that sets the `selectedHero` property to the `hero` that the user clicks.

<?code-excerpt "lib/app_component.dart (onSelect)" region="on-select" title?>
```
  void onSelect(Hero hero) {
    selectedHero = hero;
  }
```

The template still refers to the old `hero` property.
Bind to the new `selectedHero` property instead as follows:


<?code-excerpt "lib/app_component_1.html (template excerpt)" region="selectedHero-details" title?>
```
  <h2>{!{selectedHero.name}!} details!</h2>
  <div><label>id: </label>{!{selectedHero.id}!}</div>
  <div>
      <label>name: </label>
      <input [(ngModel)]="selectedHero.name" placeholder="name">
  </div>
```

### Hide the empty detail with ngIf

When the app loads, `selectedHero` is null.
The selected hero is initialized when the user clicks a hero's name.
Angular can't display properties of the null `selectedHero` and throws the following error,
visible in the browser's console:

```nocode
  EXCEPTION: TypeError: Cannot read property 'name' of undefined in [null]
```

Although `selectedHero.name` is displayed in the template,
you must keep the hero detail out of the DOM until there is a selected hero.

Wrap the HTML hero detail content of the template with a `<div>`.
Then add the `ngIf` built-in directive and set it to `selectedHero != null`.

<?code-excerpt "lib/app_component_1.html (ngIf)" region="ng-if" title?>
```
  <div *ngIf="selectedHero != null">
    <h2>{!{selectedHero.name}!} details!</h2>
    <div><label>id: </label>{!{selectedHero.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="selectedHero.name" placeholder="name">
    </div>
  </div>
```

<div class="alert is-critical" markdown="1">
  Don't forget the asterisk (`*`) in front of `ngIf`.
</div>

Refresh the browser. The app no longer fails and the list of names displays again in the browser.

When there is no selected hero, the `ngIf` directive removes the hero detail HTML from the DOM.
There are no hero detail elements or bindings to worry about.

When the user picks a hero, `selectedHero` becomes non-null and
`ngIf` puts the hero detail content into the DOM and evaluates the nested bindings.

<div class="l-sub-section" markdown="1">
  Read more about `ngIf` and `ngFor` in the
  [Structural Directives](../guide/structural-directives.html) page and the
  [Built-in directives](../guide/template-syntax.html#directives) section of the
  [Template Syntax](../guide/template-syntax.html) page.
</div>


### Style the selected hero

While the selected hero details appear below the list, it's difficult to identify the selected hero within the list itself.

In the `styles` metadata that you added above, there is a custom CSS class named `selected`.
To make the selected hero more visible, you'll apply this `selected` class to the `<li>` when the user clicks on a hero name.
For example, when the user clicks "Magneta", it should render with a distinctive but subtle background color
like this:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/heroes-list-selected.png' %}" alt="Selected hero">

In the template, add the following `[class.selected]` binding to  the `<li>`:

<?code-excerpt "lib/app_component_1.html (setting the CSS class)" region="class-selected-1" title?>
```
  [class.selected]="hero == selectedHero"
```

When the expression (`hero == selectedHero`) is `true`, Angular adds the `selected` CSS class.
When the expression is `false`, Angular removes the `selected` class.


<div class="l-sub-section" markdown="1">
  Read more about the `[class]` binding in the [Template Syntax](../guide/template-syntax.html#ngClass "Template syntax: NgClass") guide.
</div>

The final version of the `<li>` looks like this:

<?code-excerpt "lib/app_component_1.html (styling each hero)" region="class-selected-2" title?>
```
  <li *ngFor="let hero of heroes"
    [class.selected]="hero == selectedHero"
    (click)="onSelect(hero)">
    <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
  </li>
```

After clicking "Magneta", the list should look like this:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/heroes-list-1.png' %}" alt="Output of heroes list app">

Here's the complete `app_component.dart` as of now:

<?code-excerpt "lib/app_component.dart" title linenums?>
```
  import 'package:angular2/angular2.dart';

  class Hero {
    final int id;
    String name;

    Hero(this.id, this.name);
  }

  final mockHeroes = <Hero>[
    new Hero(11, 'Mr. Nice'),
    new Hero(12, 'Narco'),
    new Hero(13, 'Bombasto'),
    new Hero(14, 'Celeritas'),
    new Hero(15, 'Magneta'),
    new Hero(16, 'RubberMan'),
    new Hero(17, 'Dynama'),
    new Hero(18, 'Dr IQ'),
    new Hero(19, 'Magma'),
    new Hero(20, 'Tornado')
  ];

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <h2>My Heroes</h2>
      <ul class="heroes">
        <li *ngFor="let hero of heroes"
          [class.selected]="hero == selectedHero"
          (click)="onSelect(hero)">
          <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
        </li>
      </ul>
      <div *ngIf="selectedHero != null">
        <h2>{!{selectedHero.name}!} details!</h2>
        <div><label>id: </label>{!{selectedHero.id}!}</div>
        <div>
          <label>name: </label>
          <input [(ngModel)]="selectedHero.name" placeholder="name"/>
        </div>
      </div>
    ''',
    styles: const [
      '''
        .selected {
          background-color: #CFD8DC !important;
          color: white;
        }
        .heroes {
          margin: 0 0 2em 0;
          list-style-type: none;
          padding: 0;
          width: 15em;
        }
        .heroes li {
          cursor: pointer;
          position: relative;
          left: 0;
          background-color: #EEE;
          margin: .5em;
          padding: .3em 0em;
          height: 1.6em;
          border-radius: 4px;
        }
        .heroes li.selected:hover {
          color: white;
        }
        .heroes li:hover {
          color: #607D8B;
          background-color: #EEE;
          left: .1em;
        }
        .heroes .text {
          position: relative;
          top: -3px;
        }
        .heroes .badge {
          display: inline-block;
          font-size: small;
          color: white;
          padding: 0.8em 0.7em 0em 0.7em;
          background-color: #607D8B;
          line-height: 1em;
          position: relative;
          left: -1px;
          top: -4px;
          height: 1.8em;
          margin-right: .8em;
          border-radius: 4px 0px 0px 4px;
        }
      '''
    ],
    directives: const [COMMON_DIRECTIVES],
  )
  class AppComponent {
    final title = 'Tour of Heroes';
    final List<Hero> heroes = mockHeroes;
    Hero selectedHero;

    void onSelect(Hero hero) {
      selectedHero = hero;
    }
  }
```

## The road you've travelled

Here's what you achieved in this page:

* The Tour of Heroes app displays a list of selectable heroes.
* You added the ability to select a hero and show the hero's details.
* You learned how to use the built-in directives `ngIf` and `ngFor` in a component's template.

Your app should look like this <live-example></live-example>.

## The road ahead

You've expanded the Tour of Heroes app, but it's far from complete.
An app shouldn't be one monolithic component.
In the [next page](toh-pt3.html), you'll split the app into subcomponents and make them work together.
