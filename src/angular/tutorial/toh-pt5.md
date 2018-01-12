---
layout: angular
title: Routing
description: Add the Angular component router and learn to navigate among the views.
prevpage:
  title: Services
  url: /angular/tutorial/toh-pt4
nextpage:
  title: HTTP
  url: /angular/tutorial/toh-pt6
---
<!-- FilePath: src/angular/tutorial/toh-pt5.md -->
<?code-excerpt path-base="examples/ng/doc/toh-5"?>

There are new requirements for the Tour of Heroes app:

* Add a *Dashboard* view.
* Add the ability to navigate between the *Heroes* and *Dashboard* views.
* When users click a hero name in either view, navigate to a detail view of the selected hero.
* When users click a *deep link* in an email, open the detail view for a particular hero.

When you’re done, users will be able to navigate the app like this:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/nav-diagram.png' %}" alt="View navigations">

To satisfy these requirements, you'll add Angular’s router to the app.

<div class="l-sub-section" markdown="1">
  For more information about the router, read the [Routing and Navigation](/angular/guide/router) page.
</div>

When you're done with this page, the app should look like this <live-example></live-example>.

{%comment%}include ../../../_includes/_see-addr-bar{%endcomment%}

## Where you left off

Before continuing with the Tour of Heroes, verify that you have the following structure.

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - hero_detail_component.dart
      - hero_service.dart
      - mock_heroes.dart
  - test
    - app_test.dart
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

{% include_relative _keep-app-running.md %}

## Action plan

Here's the plan:

* Turn `AppComponent` into an app shell that only handles navigation.
* Relocate the *Heroes* concerns within the current `AppComponent` to a separate `HeroesComponent`.
* Add routing.
* Create a new `DashboardComponent`.
* Tie the *Dashboard* into the navigation structure.

<div class="l-sub-section" markdown="1">
  *Routing* is another name for *navigation*. The router is the mechanism for navigating from view to view.
</div>

## Splitting the *AppComponent*

The current app loads `AppComponent` and immediately displays the list of heroes.
The revised app should present a shell with a choice of views (*Dashboard* and *Heroes*)
and then default to one of them.

The `AppComponent` should only handle navigation, so you'll
move the display of *Heroes* out of `AppComponent` and into its own `HeroesComponent`.

### *HeroesComponent*

`AppComponent` is already dedicated to *Heroes*.
Instead of moving the code out of `AppComponent`, rename it to `HeroesComponent`
and create a separate `AppComponent` shell.

Do the following:

* Rename and move the `app_component.*` files to `src/heroes_component.*`.
* Drop the `src/` prefix from import paths.
* Rename the `AppComponent` class to `HeroesComponent` (rename locally, _only_ in this file).
* Rename the selector `my-app` to `my-heroes`.
* Change the template URL to `heroes_component.html` and style file to `heroes_component.css`.

<?code-excerpt "lib/src/heroes_component.dart (showing renamings only)" region="renaming" title?>
```
  @Component(
    selector: 'my-heroes',
    templateUrl: 'heroes_component.html',
    styleUrls: const ['heroes_component.css'],
  )
  class HeroesComponent implements OnInit {
    HeroesComponent(
        this._heroService,
        );
  }
```

### Create *AppComponent*

The new `AppComponent` is the app shell.
It will have some navigation links at the top and a display area below.

Perform these steps:

* Create the file `lib/app_component.dart`.
* Define an `AppComponent` class.
* Add an `@Component` annotation above the class with a `my-app` selector.
* Move the following from the heroes component to `AppComponent`:
  * `title` class property.
  * `@Component` template `<h1>` element, which contains a binding to  `title`.
* Add a `<my-heroes>` element to the app template just below the heading so you still see the heroes.
* Add `HeroesComponent` to the `directives` list of `AppComponent` so Angular recognizes the `<my-heroes>` tags.
* Add `HeroService` to the  `providers` list of `AppComponent` because you'll need it in every other view.
* Remove `HeroService` from the `HeroesComponent` `providers` list since it was promoted.
* Add the supporting `import` statements for `AppComponent`.

The first draft looks like this:

<?code-excerpt "lib/app_component_1.dart" title?>
```
  import 'package:angular/angular.dart';

  import 'src/hero_service.dart';
  import 'src/heroes_component.dart';

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <my-heroes></my-heroes>
    ''',
    directives: const [HeroesComponent],
    providers: const [HeroService],
  )
  class AppComponent {
    final title = 'Tour of Heroes';
  }
```

<i class="material-icons">open_in_browser</i>
**Refresh the browser.** The app still runs and displays heroes.

## Add routing

Instead of displaying automatically, heroes should display after users click a button.
In other words, users should be able to navigate to the list of heroes.

<?code-excerpt path-base="examples/ng/doc"?>

### Update the pubspec

Use the Angular router ([angular_router][]) to enable navigation. Since the
router is in its own package, first add the package to the app's pubspec:

<?code-excerpt "toh-4/pubspec.yaml" diff-with="toh-5/pubspec.yaml" to="angular_router"?>
```diff
--- toh-4/pubspec.yaml
+++ toh-5/pubspec.yaml
@@ -8,11 +8,13 @@
 dependencies:
   angular: ^4.0.0
   angular_forms: ^1.0.0
+  angular_router: ^1.0.2
```

Not all apps need routing, which is why the Angular router is
in a separate, optional package.

<?code-excerpt path-base="examples/ng/doc/toh-5"?>

### Import the library

The Angular router is a combination of multiple services
([ROUTER_PROVIDERS][]), directives ([ROUTER_DIRECTIVES][]), and
configuration classes. You get them all by importing
the router library:

<?code-excerpt "lib/app_component.dart (router import)" title?>
```
  import 'package:angular_router/angular_router.dart';
```

### Make the router available

To tell Angular that your app uses the router,
specify [ROUTER_PROVIDERS][] in your app's bootstrap function:

<?code-excerpt "web/main.dart" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';
  import 'package:angular_tour_of_heroes/app_component.dart';

  void main() {
    bootstrap(AppComponent, [
      ROUTER_PROVIDERS,
      // Remove next line in production
      provide(LocationStrategy, useClass: HashLocationStrategy),
    ]);
  }
```

{% include location-strategy-callout.md %}

Next, add [ROUTER_DIRECTIVES][] to the `@Component` annotation, and remove `HeroesComponent`:

<?code-excerpt "lib/app_component.dart (directives)" title?>
```
  directives: const [ROUTER_DIRECTIVES],
```

You can remove `HeroesComponent` from the directives list because `AppComponent` won't directly display heroes; that's the router's job. Soon you'll remove `<my-heroes>` from the template.

### *\<base href>*

Open `index.html` and ensure there is a `<base href="...">` element
(or a script that dynamically sets this element)
at the top of the `<head>` section.

As explained in the [Set the base href](/angular/guide/router/1#base-href)
section of the [Routing and Navigation](/angular/guide/router) page,
the example apps use the following script:

<?code-excerpt "web/index.html (base-href)" title?>
```
  <head>
    <script>
      // WARNING: DO NOT set the <base href> like this in production!
      // Details: https://webdev.dartlang.org/angular/guide/router
      (function () {
        var m = document.location.pathname.match(/^(\/[-\w]+)+\/web($|\/)/);
        document.write('<base href="' + (m ? m[0] : '/') + '" />');
      }());
    </script>
```

### Configure routes

*Routes* tell the router which views to display when a user clicks a link or
pastes a URL into the browser address bar.

Create a route configuration ([RouteConfig][]) to hold a list of app *route definitions*.
Define the first route as a route to the heroes component.

<?code-excerpt "lib/app_component.dart (Heroes route)" title?>
```
  @RouteConfig(const [
    const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
  ])
```

The route definition is a [Route][] object that has the following named arguments:

- `path`: The router matches this string against the URL in the browser
  address bar (`/heroes`).
- `name`: The route name (`Heroes`).
  It must begin with a capital letter to avoid confusion with the path.
- `component`: The component that will be activated when this
  route is navigated to (`HeroesComponent`).

<div class="l-sub-section" markdown="1">
  Read more about defining routes in the [Routing & Navigation](/angular/guide/router) page.
</div>

### Router outlet

If you visit [localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external},
the router should match the URL to the heroes route and display a `HeroesComponent`.
However, you have to tell the router where to display the component.

To do this, add a `<router-outlet>` element at the end of the template.
[RouterOutlet][] is one of the [ROUTER_DIRECTIVES][]. The router displays each
component immediately below the `<router-outlet>` as users navigate through
the app.

<i class="material-icons">open_in_browser</i>
**Refresh the browser,** then visit
[localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external}.
You should see the heroes list.

### Router links

Users shouldn't have to paste a route path into the address bar.
Instead, add an anchor to the template that, when clicked,
triggers navigation to `HeroesComponent`.

The revised template looks like this:

<?code-excerpt "lib/app_component_2.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <a [routerLink]="['Heroes']">Heroes</a>
    <router-outlet></router-outlet>
  ''',
```

Note the `[routerLink]` binding in the anchor tag. The [RouterLink][] directive
tells the router where to navigate when the user
clicks the link.

You define a *routing instruction* with a *link parameters list*.
The list only has one element in our little sample, the quoted **_name_ of the route** to follow.
Looking back at the route configuration, confirm that `'Heroes'` is the name of the route to the `HeroesComponent`.

<div class="l-sub-section" markdown="1">
  Learn about the *link parameters list*
  in the [Routing](/angular/guide/router/appendices#link-parameters-list) chapter.
</div>

<i class="material-icons">open_in_browser</i>
**Refresh the browser**. The browser displays the app title and heroes link,
but not the heroes list. Click the *Heroes* navigation link. The address bar
updates to `/#/heroes` (or the equivalent `/#heroes`),
and the list of heroes displays.

`AppComponent` now looks like this:

<?code-excerpt "lib/app_component_2.dart" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';

  import 'src/hero_service.dart';
  import 'src/heroes_component.dart';

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <a [routerLink]="['Heroes']">Heroes</a>
      <router-outlet></router-outlet>
    ''',
    directives: const [ROUTER_DIRECTIVES],
    providers: const [HeroService],
  )
  @RouteConfig(const [
    const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
  ])
  class AppComponent {
    final title = 'Tour of Heroes';
  }
```

The  *AppComponent* has a router and displays routed views.
For this reason, and to distinguish it from other kinds of components,
this component type is called a *router component*.

## Add a dashboard

Routing only makes sense when multiple views exist.
To add another view, create a placeholder `DashboardComponent`.

<?code-excerpt "lib/src/dashboard_component_1.dart (v1)" region="" title?>
```
  import 'package:angular/angular.dart';

  @Component(
    selector: 'my-dashboard',
    template: '<h3>My Dashboard</h3>',
  )
  class DashboardComponent {}
```

You'll make this component more useful later.

### Configure the dashboard route

Add a dashboard route similar to the heroes route:

<?code-excerpt "lib/app_component.dart (Dashboard route)" title?>
```
  const Route(
    path: '/dashboard',
    name: 'Dashboard',
    component: DashboardComponent,
  ),
```

### Add a redirect route

Currently, the browser launches with `/` in the address bar.
When the app starts, it should show the dashboard and
display the `/#/dashboard` path in the address bar.

To make this happen, add a redirect route:

<?code-excerpt "lib/app_component.dart (Redirect route)" title?>
```
  const Redirect(path: '/', redirectTo: const ['Dashboard']),
```

<div class="l-sub-section" markdown="1">
  Alternatively, you could define `Dashboard` as a _default_ route.
  Read more about
  [default routes](/angular/guide/router/2#default-route) and
  [redirects](/angular/guide/router/2#redirect-route) in the
  [Routing & Navigation](/angular/guide/router/2) page.
</div>

### Add navigation to the dashboard

Add a dashboard navigation link to the template, just above the heroes link.

<?code-excerpt "lib/app_component.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <nav>
      <a [routerLink]="['Dashboard']">Dashboard</a>
      <a [routerLink]="['Heroes']">Heroes</a>
    </nav>
    <router-outlet></router-outlet>
  ''',
```

<div class="l-sub-section" markdown="1">
  The `<nav>` tags don't do anything yet, but they'll be useful later when you style the links.
</div>

<i class="material-icons">open_in_browser</i>
**In your browser**, go to the app root (`/`) and reload.
The app displays the dashboard and you can navigate between the dashboard and the heroes list.

## Add heroes to the dashboard

To make the dashboard more interesting, you'll display the top four heroes at a glance.

Replace the `template` metadata with a `templateUrl` property that points to a new
template file, and add the directives shown below (you'll add the necessary imports soon):

<?code-excerpt "lib/src/dashboard_component.dart (metadata)" region="metadata-wo-styles" title?>
```
  @Component(
    selector: 'my-dashboard',
    templateUrl: 'dashboard_component.html',
    directives: const [CORE_DIRECTIVES, ROUTER_DIRECTIVES],
  )
```

<div class="l-sub-section" markdown="1">
  The value of `templateUrl` can be an [asset][] in this package or another
  package. To use an asset in another package, use a full package reference,
  such as `'package:some_other_package/dashboard_component.html'`.

  [asset]: {{site.dartlang}}/tools/pub/glossary#asset
</div>

Create the template file with this content:

<?code-excerpt "lib/src/dashboard_component_1.html" title linenums?>
```
  <h3>Top Heroes</h3>
  <div class="grid grid-pad">
    <div *ngFor="let hero of heroes">
      <div class="module hero">
        <h4>{!{hero.name}!}</h4>
      </div>
    </div>
  </div>
```

`*ngFor` is used again to iterate over a list of heroes and display their names.
The extra `<div>` elements will help with styling later.

### Sharing the *HeroService*

To populate the component's `heroes` list, you can reuse the `HeroService`.

Earlier, you removed the `HeroService` from the `providers` list of `HeroesComponent`
and added it to the `providers` list of `AppComponent`.
That move created a singleton `HeroService` instance, available to all components of the app.
Angular injects `HeroService` and you can use it in the `DashboardComponent`.

### Get heroes

In `dashboard_component.dart`, add the following `import` statements.

<?code-excerpt "lib/src/dashboard_component.dart (imports)" title?>
```
  import 'dart:async';

  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';

  import 'hero.dart';
  import 'hero_service.dart';
```

Now create the `DashboardComponent` class like this:

<?code-excerpt "lib/src/dashboard_component.dart (class)" title?>
```
  class DashboardComponent implements OnInit {
    List<Hero> heroes;

    final HeroService _heroService;

    DashboardComponent(this._heroService);

    Future<Null> ngOnInit() async {
      heroes = (await _heroService.getHeroes()).skip(1).take(4).toList();
    }
  }
```

This kind of logic is also used in the `HeroesComponent`:

* Define a `heroes` list property.
* Inject the `HeroService` in the constructor and hold it in a private `_heroService` field.
* Call the service to get heroes inside the Angular `ngOnInit()` lifecycle hook.

In this dashboard you specify four heroes (2nd, 3rd, 4th, and 5th).

<i class="material-icons">open_in_browser</i>
**Refresh the browser** to see four hero names in the new dashboard.

## Navigating to hero details

While the details of a selected hero displays at the bottom of the `HeroesComponent`,
users should be able to navigate to a `HeroDetailComponent` in the following additional ways:

* From the dashboard to a selected hero.
* From the heroes list to a selected hero.
* From a "deep link" URL pasted into the browser address bar.

### Routing to a hero detail

You can add a route to the `HeroDetailComponent` in `AppComponent`, where the other routes are defined.

The new route is unusual in that you must tell the `HeroDetailComponent` which hero to show.
You didn't have to tell the `HeroesComponent` or the `DashboardComponent` anything.

Currently, the parent `HeroesComponent` sets the component's `hero` property to a
hero object with a binding like this:

<?code-excerpt "../toh-3/lib/app_component.html (hero-detail)"?>
```html
  <hero-detail [hero]="selectedHero"></hero-detail>
```

But this binding won't work in any of the routing scenarios.

### Parameterized route

You can add the hero's `id` to the route path. When routing to the hero whose `id` is 11,
you could expect to see a path such as this:

```nocode
/detail/11
```

The `/detail/` part is constant. The trailing numeric `id` changes from hero to hero.
You need to represent the variable part of the route with a *parameter* that stands for the hero's `id`.

### Add a route with a parameter

First, import the hero detail component:

<?code-excerpt "lib/app_component.dart (hero-detail-import)"?>
```
  import 'src/hero_detail_component.dart';
```

Next, add the following route:

<?code-excerpt "lib/app_component.dart (HeroDetail route)" title?>
```
  const Route(
    path: '/detail/:id',
    name: 'HeroDetail',
    component: HeroDetailComponent,
  ),
```

The colon (:) in the path indicates that `:id` is a placeholder for a specific hero `id`
when navigating to the `HeroDetailComponent`.

You're finished with the app routes.

You didn't add a hero detail link to the template because users
don't click a navigation *link* to view a particular hero;
they click a *hero name*, whether the name is displayed on the dashboard or in the heroes list.
But this won't work until the `HeroDetailComponent`
is revised and ready to be navigated to.

## Revise *HeroDetailComponent*

Here's what the `HeroDetailComponent` looks like now:

<?code-excerpt "../toh-4/lib/src/hero_detail_component.dart" region="" title="lib/src/hero_detail_component.dart (current)" linenums?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_forms/angular_forms.dart';

  import 'hero.dart';

  @Component(
    selector: 'hero-detail',
    template: '''
      <div *ngIf="hero != null">
        <h2>{!{hero.name}!} details!</h2>
        <div><label>id: </label>{!{hero.id}!}</div>
        <div>
          <label>name: </label>
          <input [(ngModel)]="hero.name" placeholder="name"/>
        </div>
      </div>
    ''',
    directives: const [CORE_DIRECTIVES, formDirectives],
  )
  class HeroDetailComponent {
    @Input()
    Hero hero;
  }
```

The template won't change. Hero names will display the same way.
The major changes are driven by how you get hero names.

You will no longer receive the hero in a parent component property binding, so
you can **remove the `@Input()` annotation** from the `hero` field:

<?code-excerpt "lib/src/hero_detail_component.dart (hero with @Input removed)" region="hero" title?>
```
  class HeroDetailComponent implements OnInit {
    Hero hero;
  }
```

The new `HeroDetailComponent` will take the `id` parameter from the router's
`RouteParams` service and use the `HeroService` to fetch the hero with that `id`.

Add the following imports:

<?code-excerpt "lib/src/hero_detail_component.dart (added-imports)" title?>
```
  import 'dart:async';

  import 'package:angular_router/angular_router.dart';

  import 'hero_service.dart';
```

Inject the [RouteParams][], `HeroService`, and [Location][] services
into the constructor, saving their values in private fields:

<?code-excerpt "lib/src/hero_detail_component.dart (constructor)" region="ctor" title?>
```
  final HeroService _heroService;
  final RouteParams _routeParams;
  final Location _location;

  HeroDetailComponent(this._heroService, this._routeParams, this._location);
```

Tell the class to implement the `OnInit` interface.

<?code-excerpt "lib/src/hero_detail_component.dart (implement)"?>
```
  class HeroDetailComponent implements OnInit {
```

Inside the `ngOnInit()` lifecycle hook, extract the `id` parameter value from the `RouteParams` service and use the `HeroService` to fetch the hero with that `id`.

<?code-excerpt "lib/src/hero_detail_component.dart (ngOnInit)" title?>
```
  Future<Null> ngOnInit() async {
    var _id = _routeParams.get('id');
    var id = int.parse(_id ?? '', onError: (_) => null);
    if (id != null) hero = await (_heroService.getHero(id));
  }
```

Notice how you can extract the `id` by calling the `RouteParams.get()` method.

The hero `id` is a number. Route parameters are always strings.
So the route parameter value is converted to a number.

### Add *HeroService.getHero()*

In `ngOnInit()`, you used the `getHero()` method, which `HeroService` doesn't
have yet. To fix this issue, open `HeroService` and add a `getHero()` method
that filters the heroes list from `getHeroes()` by `id`.

<?code-excerpt "lib/src/hero_service.dart (getHero)" title?>
```
  Future<Hero> getHero(int id) async =>
      (await getHeroes()).firstWhere((hero) => hero.id == id);
```

### Find the way back

Users have several ways to navigate *to* the `HeroDetailComponent`.

To navigate somewhere else, users can click one of the two links in the `AppComponent` or click the browser's back button.
Now add a third option, a `goBack()` method that navigates backward one step in the browser's history stack
using the `Location` service you injected previously.

<?code-excerpt "lib/src/hero_detail_component.dart (goBack)" title?>
```
  void goBack() => _location.back();
```

<div class="l-sub-section" markdown="1">
  Going back too far could take users out of the app.
  In a real app, you can prevent this issue with the _routerCanDeactivate()_ hook.
  Read more on the [CanDeactivate](/api/angular_router/angular_router/CanDeactivate-class) page.
</div>

You'll wire this method with an event binding to a *Back* button that you'll add to the component template.

<?code-excerpt "lib/src/hero_detail_component.html (back-button)"?>
```
  <button (click)="goBack()">Back</button>
```

Migrate the template to its own file called `hero_detail_component.html`:

<?code-excerpt "lib/src/hero_detail_component.html" title?>
```
  <div *ngIf="hero != null">
    <h2>{!{hero.name}!} details!</h2>
    <div>
      <label>id: </label>{!{hero.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="hero.name" placeholder="name" />
    </div>
    <button (click)="goBack()">Back</button>
  </div>
```

Update the component metadata with a `templateUrl` pointing to the template file that you just created.

<?code-excerpt "lib/src/hero_detail_component.dart (metadata)" region="metadata-wo-style" title?>
```
  @Component(
    selector: 'hero-detail',
    templateUrl: 'hero_detail_component.html',
    directives: const [CORE_DIRECTIVES, formDirectives],
  )
```

<i class="material-icons">open_in_browser</i>
**Refresh the browser** and visit
[localhost:8080/#detail/11](http://localhost:8080/#detail/11){:.no-automatic-external}.
Details for hero 11 should be displayed. Selecting a hero
in either the dashboard or the heroes list doesn't work yet.
You'll deal with that next.

## Select a dashboard hero

When a user selects a hero in the dashboard, the app should navigate to a
`HeroDetailComponent` to allow the user to view and edit the selected hero.

The dashboard heroes should behave like anchor tags:
when hovering over a hero name, the target URL should display in the browser status bar
and the user should be able to copy the link or open the hero detail view in a new tab.

To achieve this effect, open `dashboard_component.html` and replace the
`<div *ngFor...>` element with an anchor
(the child elements remain the same):

<?code-excerpt "lib/src/dashboard_component.html (repeated &lt;a&gt; tag)" region="click" title?>
```
  <a *ngFor="let hero of heroes" [routerLink]="['HeroDetail', {id: hero.id.toString()}]" class="col-1-4">
    <div class="module hero">
      <h4>{!{hero.name}!}</h4>
    </div>
  </a>
```

Notice the `[routerLink]` binding. As described in the
[Router links](#router-links) section of this page, top-level navigation in
the `AppComponent` template has router links set to fixed names of the
destination routes, `/dashboard` and `/heroes`.

This time, you're binding to an expression containing a *link parameters list*.
The list has two elements: the *name* of
the destination route and a *route parameter* set to the value of the current hero's `id`.

The two list items align with the *name* and *:id* in the parameterized hero detail route
definition that you added earlier:

<?code-excerpt "lib/app_component.dart (HeroDetail route)" title?>
```
  const Route(
    path: '/detail/:id',
    name: 'HeroDetail',
    component: HeroDetailComponent,
  ),
```

<i class="material-icons">open_in_browser</i>
**Refresh the browser** and select a hero from the dashboard; the app navigates to that hero’s details.

## Select a hero in the *HeroesComponent*

In the `HeroesComponent`,
the current template exhibits a "master/detail" style with the list of heroes
at the top and details of the selected hero below.

<?code-excerpt "lib/src/heroes_component_1.html" title?>
```
  <h2>My Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes"
        [class.selected]="hero === selectedHero"
        (click)="onSelect(hero)">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
  <hero-detail [hero]="selectedHero"></hero-detail>
```

You'll no longer show the full `HeroDetailComponent` here.
Instead, you'll display the hero detail on its own page and route to it as you did in the dashboard.
Make these changes:

- Remove the `<hero-detail>` element from the last line of the template.
- Remove `HeroDetailComponent` from list of `directives`.
- Remove the hero detail import.

When users select a hero from the list, they won't go to the detail page.
Instead, they'll see a mini detail on *this* page and have to click a button to navigate to the *full detail* page.

### Add the *mini detail*

Add the following HTML fragment at the bottom of the template where the `<hero-detail>` used to be:

<?code-excerpt "lib/src/heroes_component.html (mini detail)" title?>
```
  <div *ngIf="selectedHero != null">
    <h2>
      {!{selectedHero.name | uppercase}!} is my hero
    </h2>
    <button (click)="gotoDetail()">View Details</button>
  </div>
```

After clicking a hero (but don't try now since it won't work yet), users should see something like this below the hero list:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/mini-hero-detail.png' %}" alt="Mini Hero Detail" width="250">

The hero's name is displayed in capital letters because of the `uppercase` pipe
that's included in the interpolation binding, right after the pipe operator ( | ).

<?code-excerpt "lib/src/heroes_component.html (pipe)"?>
```
  {!{selectedHero.name | uppercase}!} is my hero
```

Pipes are a good way to format strings, currency amounts, dates and other display data.
Angular ships with several pipes and you can write your own.

<i class="material-icons">warning</i> Before you can use an Angular pipe in a
template, you need to list it in the `pipes` argument of your component's
`@Component` annotation. You can add pipes
individually, or for convenience you can use groups like [COMMON_PIPES][].

<?code-excerpt "lib/src/heroes_component.dart (pipes)" title?>
```
  @Component(
    selector: 'my-heroes',
    pipes: const [COMMON_PIPES],
  )
```

<div class="l-sub-section" markdown="1">
  Read more about pipes on the [Pipes](/angular/guide/pipes) page.
</div>

<i class="material-icons">open_in_browser</i>
**Refresh the browser.** Selecting a hero from the heroes list will activate the mini
detail view. The view details button doesn't work yet.

### Update the _HeroesComponent_ class

The `HeroesComponent` navigates to the `HeroesDetailComponent` in response to a button click.
The button's click event is bound to a `gotoDetail()` method that should navigate _imperatively_
by telling the router where to go.

This approach requires the following changes to the component class:

1. Import the [angular_router][].
1. Inject the `Router` in the constructor, along with the `HeroService`.
1. Implement `gotoDetail()` by calling the router `navigate()` method.

Here's the revised `HeroesComponent` class:

<?code-excerpt "lib/src/heroes_component.dart (class)" title?>
```
  class HeroesComponent implements OnInit {
    final HeroService _heroService;
    final Router _router;
    List<Hero> heroes;
    Hero selectedHero;

    HeroesComponent(
        this._heroService,
        this._router
        );

    Future<Null> getHeroes() async {
      heroes = await _heroService.getHeroes();
    }

    void ngOnInit() => getHeroes();

    void onSelect(Hero hero) => selectedHero = hero;

    Future<Null> gotoDetail() => _router.navigate([
          'HeroDetail',
          {'id': selectedHero.id.toString()}
        ]);
  }
```

In `gotoDetail()`, you're passing a two-element *link parameters list* &mdash; a
name and the route parameter &mdash; to
the router `navigate()` method, just as you did in the `[routerLink]` binding
back in the `DashboardComponent`.

<i class="material-icons">open_in_browser</i>
**Refresh the browser** and start clicking.
Users can navigate around the app, from the dashboard to hero details and back,
from heroes list to the mini detail to the hero details and back to the heroes again.

You've met all of the navigational requirements that propelled this page.

## Style the app

The app is functional but it needs styling.
The dashboard heroes should display in a row of rectangles.
You've received around 60 lines of CSS for this purpose, including some simple media queries for responsive design.

As you now know, adding the CSS to the component `styles` metadata
would obscure the component logic.
Instead, you'll add the CSS to separate `.css` files.

### Dashboard styles

Create a `dashboard_component.css` file in the `lib/src` folder and reference
that file in the component metadata's `styleUrls` list property like this:

<code-tabs>
  <?code-pane "lib/src/dashboard_component.dart (styleUrls)" region="metadata" linenums?>
  <?code-pane "lib/src/dashboard_component.css" linenums?>
</code-tabs>


### Hero detail styles

Create a `hero_detail_component.css` file in the `lib/src`
folder and reference that file in the component metadata’s `styleUrls` list:

<code-tabs>
  <?code-pane "lib/src/hero_detail_component.dart (styleUrls)" region="metadata" linenums?>
  <?code-pane "lib/src/hero_detail_component.css" linenums?>
</code-tabs>

### Style the navigation links

Create an `app_component.css` file in the `lib` folder
and reference that file in the component metadata’s `styleUrls` list:

<code-tabs>
  <?code-pane "lib/app_component.dart (styleUrls)" linenums?>
  <?code-pane "lib/app_component.css" linenums?>
</code-tabs>

The provided CSS makes the navigation links in the `AppComponent` look more like selectable buttons.
Earlier, you surrounded those links with a `<nav>` element:

<div class="l-sub-section" markdown="1">
  **The *router-link-active* class**

  The Angular router adds the `router-link-active` class to the HTML navigation element
  whose route matches the active route. All you have to do is define the style for it.
</div>

### Global app styles

When you add styles to a component, you keep everything a component needs&mdash;HTML,
the CSS, the code&mdash;together in one convenient place.
It's easy to package it all up and reuse the component somewhere else.

You can also create styles at the *app level* outside of any component.

The designers provided some basic styles to apply to elements across the entire app.
These correspond to the full set of master styles that you installed earlier during [setup](/angular/guide/setup).
Here's an excerpt:

<?code-excerpt "../_boilerplate/styles.css (toh)" title="web/styles.css (excerpt)"?>
```
  @import url(https://fonts.googleapis.com/css?family=Roboto);
  @import url(https://fonts.googleapis.com/css?family=Material+Icons);

  /* Master Styles */
  h1 {
    color: #369;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 250%;
  }
  h2, h3 {
    color: #444;
    font-family: Arial, Helvetica, sans-serif;
    font-weight: lighter;
  }
  body {
    margin: 2em;
  }
  body, input[text], button {
    color: #888;
    font-family: Cambria, Georgia;
  }
  /* ··· */
  /* everywhere else */
  * {
    font-family: Arial, Helvetica, sans-serif;
  }
```

Create the file `web/styles.css`, if necessary.
Ensure that the file contains the [master styles provided here][master styles].
Also edit `web/index.html` to refer to this stylesheet.

<?code-excerpt "web/index.html (link ref)" region="css" title?>
```
  <link rel="stylesheet" href="styles.css">
```

Look at the app now. The dashboard, heroes, and navigation links are styled.

<img class="image-display" src="{% asset_path 'ng/devguide/toh/dashboard-top-heroes.png' %}" alt="View navigations">

## App structure and code

Review the sample source code in the <live-example></live-example> for this page.
Verify that you have the following structure:

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart}
    - src
      - dashboard_component.{css,dart,html}
      - hero.dart
      - hero_detail_component.{css,dart,html}
      - hero_service.dart
      - heroes_component.{css,dart,html}
      - mock_heroes.dart
  - test
    - app_test.dart
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

## The road you’ve travelled

Here's what you achieved in this page:

- You added the Angular router to navigate among different components.
- You learned how to create router links to represent navigation menu items.
- You used router link parameters to navigate to the details of the user-selected hero.
- You shared the `HeroService` among multiple components.
- You added the `uppercase` pipe to format data.

Your app should look like this <live-example></live-example>.

### The road ahead

You have much of the foundation you need to build an app.
You're still missing a key piece: remote data access.

In the next page,
you’ll replace the mock data with data retrieved from a server using http.

{%comment%}TODO: Add Recap and What's next sections{%endcomment%}

[angular_router]: /api/angular_router
[COMMON_PIPES]: /api/angular/angular/COMMON_PIPES-constant
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[master styles]: https://raw.githubusercontent.com/angular/angular.io/master/public/docs/_examples/_boilerplate/src/styles.css
[Location]: /api/angular_router/angular_router/Location-class
[Route]: /api/angular_router/angular_router/Route-class
[RouteConfig]: /api/angular_router/angular_router/RouteConfig-class
[RouteParams]: /api/angular_router/angular_router/RouteParams-class
[ROUTER_DIRECTIVES]: /api/angular_router/angular_router/ROUTER_DIRECTIVES-constant
[RouterLink]: /api/angular_router/angular_router/RouterLink-class
[RouterOutlet]: /api/angular_router/angular_router/RouterOutlet-class
[ROUTER_PROVIDERS]: /api/angular_router/angular_router/ROUTER_PROVIDERS-constant
