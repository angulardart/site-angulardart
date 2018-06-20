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

<?code-excerpt path-base="examples/ng/doc/toh-5"?>
<?code-excerpt replace="/_\d((\.template)?\.(dart|html))/$1/g"?>

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
      - hero_component.dart
      - hero_service.dart
      - mock_heroes.dart
  - test
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
* Relocate the *Heroes* concerns within the current `AppComponent` to a separate `HeroListComponent`.
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
move the display of *Heroes* out of `AppComponent` and into its own `HeroListComponent`.

### *HeroListComponent*

`AppComponent` is already dedicated to *Heroes*.
Instead of moving the code out of `AppComponent`, rename it to `HeroListComponent`
and create a separate `AppComponent` shell.

Do the following:

* Rename and move the `app_component.*` files to `src/hero_list_component.*`.
* Drop the `src/` prefix from import paths.
* Rename the `AppComponent` class to `HeroListComponent` (rename locally, _only_ in this file).
* Rename the selector `my-app` to `my-heroes`.
* Change the template URL to `hero_list_component.html` and style file to `hero_list_component.css`.

<?code-excerpt "lib/src/hero_list_component.dart (showing renamings only)" region="renaming" replace="/, this._router//g" title?>
```
  @Component(
    selector: 'my-heroes',
    templateUrl: 'hero_list_component.html',
    styleUrls: ['hero_list_component.css'],
    // ···
  )
  class HeroListComponent implements OnInit {
    // ···
    HeroListComponent(this._heroService);
    // ···
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
* Add `HeroListComponent` to the `directives` list of `AppComponent` so Angular recognizes the `<my-heroes>` tags.
* Add `HeroService` to the  `providers` list of `AppComponent` because you'll need it in every other view.
* Remove `HeroService` from the `HeroListComponent` `providers` list since it was promoted.
* Add the supporting `import` statements for `AppComponent`.

The first draft looks like this:

<?code-excerpt "lib/app_component_1.dart" title?>
```
  import 'package:angular/angular.dart';

  import 'src/hero_service.dart';
  import 'src/hero_list_component.dart';

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <my-heroes></my-heroes>
    ''',
    directives: [HeroListComponent],
    providers: [ClassProvider(HeroService)],
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
   angular: ^5.0.0-alpha+15
   angular_forms: ^2.0.0-alpha
+  angular_router: ^2.0.0-alpha
```

Not all apps need routing, which is why the Angular router is
in a separate, optional package.

<?code-excerpt path-base="examples/ng/doc/toh-5"?>

### Import the library

The Angular router is a combination of multiple services
([routerProviders][]/[routerProvidersHash][]),
directives ([routerDirectives][]), and
configuration classes. You get them all by importing
the router library:

<?code-excerpt "lib/app_component.dart (router import)" title?>
```
  import 'package:angular_router/angular_router.dart';
```

### Make the router available

To tell Angular that your app uses the router, pass as an argument to `runApp()`
an injector seeded with [routerProvidersHash][]:

<?code-excerpt "web/main.dart" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';
  import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;

  import 'main.template.dart' as self;

  @GenerateInjector(
    routerProvidersHash, // You can use routerProviders in production
  )
  final InjectorFactory injector = self.injector$Injector;

  void main() {
    runApp(ng.AppComponentNgFactory, createInjector: injector);
  }
```

{% include location-strategy-callout.md %}

Next, add [routerDirectives][] to the `@Component` annotation, and remove `HeroListComponent`:

<?code-excerpt "lib/app_component.dart (directives)" title?>
```
  directives: [routerDirectives],
```

You can remove `HeroListComponent` from the directives list because `AppComponent` won't directly display heroes; that's the router's job. Soon you'll remove `<my-heroes>` from the template.

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

First create a file to hold route paths. Initialize it with this content:

<?code-excerpt "lib/src/route_paths.dart" region="v1" title?>
```
  import 'package:angular_router/angular_router.dart';
  // ···
  final heroes = RoutePath(path: 'heroes');
```

As a first route, define a route to the heroes component:

<?code-excerpt "lib/src/routes.dart (a first route)" plaster="none" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';

  import 'route_paths.dart' as paths;
  import 'hero_list_component.template.dart' as hlct;

  @Injectable()
  class Routes {
    RoutePath get heroes => paths.heroes;

    final List<RouteDefinition> all = [
      RouteDefinition(
        path: paths.heroes.path,
        component: hlct.HeroListComponentNgFactory,
      ),
    ];
  }
```

The `Routes.all` field is a list of *route definitions*.
It contains only one route, but you'll be adding more routes shortly.

The heroes [RouteDefinition][] has the following named arguments:

- `routePath`: The router matches this path against the URL in the browser
  address bar (`heroes`).
- `component`: The (factory of the) component that will be activated when this
  route is navigated to (`hlct.HeroListComponentNgFactory`).

The Angular compiler generates **component factories** behind the scenes. To
access the factory you need to import the generated component template file:

<?code-excerpt "lib/src/routes.dart (hlct)"?>
```
  import 'hero_list_component.template.dart' as hlct;
```

The first line of the routes file is a Dart analyzer directive.
Without it, the analyzer will report that the named import doesn't exist
because files generated by the Angular compiler are not accessible.
By naming the import (`hlct`) you can use the not-yet-generated template without
warnings from the analyzer.

<div class="l-sub-section" markdown="1">
  Read more about defining routes in the [Routing & Navigation](/angular/guide/router) page.
</div>

### Router outlet

If you visit [localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external},
the router should match the URL to the heroes route and display a `HeroListComponent`.
However, you have to tell the router where to display the component.

To do this, add a `<router-outlet>` element at the end of the template.
[RouterOutlet][] is one of the [routerDirectives][]. The router displays each
component immediately below the `<router-outlet>` as users navigate through
the app.

The `<router-outlet>` takes a list of routes as input, so import the app
routes and bind them to the `routes` property as shown here:

<?code-excerpt "lib/app_component.dart (routes and template)" plaster="none" remove="/nav|routerLink|title/" replace="/(\s+)(.router-outlet.*)/$1...$1[!$2!]/g" title?>
```
  import 'src/routes.dart';

  @Component(
    template: '''
      ...
      [!<router-outlet [routes]="routes.all"></router-outlet>!]
    ''',
    providers: [
      ClassProvider(HeroService),
      ClassProvider(Routes),
    ],
  )
  class AppComponent {
    final Routes routes;

    AppComponent(this.routes);
  }
```

<i class="material-icons">open_in_browser</i>
**Refresh the browser,** then visit
[localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external}.
You should see the heroes list.

### Router links

Users shouldn't have to paste a route path into the address bar.
Instead, add an anchor to the template that, when clicked,
triggers navigation to `HeroListComponent`.

The revised template looks like this:

<?code-excerpt "lib/app_component.dart (template)" remove="/[Dd]ashboard/" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <nav>
      <a [routerLink]="routes.heroes.toUrl()"
         routerLinkActive="active">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
```

Note the `routerLink` [property binding][] in the anchor tag. The [RouterLink][] directive
is bound to an expression whose string value that tells the router where to navigate to when the user
clicks the link.

Looking back at the route definitions, you can confirm that
`'heroes'` is the path of the route to the `HeroListComponent`.

{% comment %} The path string isn't visible anymore so this callout isn't really pertinent:
<div class="callout is-important" markdown="1">
  Notice that `routerLink` is bound to `/heroes` and not `/#/heroes`, even if
  your app uses the [HashLocationStrategy][] during development.  This uniform
  use of route paths makes it easy to switch to the [PathLocationStrategy][]
  when deploying in production.
</div>
{% endcomment %}

<i class="material-icons">open_in_browser</i>
**Refresh the browser**. The browser displays the app title and heroes link,
but not the heroes list. Click the *Heroes* navigation link. The address bar
updates to `/#/heroes` (or the equivalent `/#heroes`),
and the list of heroes displays.

`AppComponent` now looks like this:

<?code-excerpt "lib/app_component.dart" remove="/style|[Dd]ash/" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';

  import 'src/routes.dart';
  import 'src/hero_service.dart';

  @Component(
    selector: 'my-app',
    template: '''
      <h1>{!{title}!}</h1>
      <nav>
        <a [routerLink]="routes.heroes.toUrl()"
           routerLinkActive="active">Heroes</a>
      </nav>
      <router-outlet [routes]="routes.all"></router-outlet>
    ''',
    directives: [routerDirectives],
    providers: [
      ClassProvider(HeroService),
      ClassProvider(Routes),
    ],
  )
  class AppComponent {
    final title = 'Tour of Heroes';
    final Routes routes;

    AppComponent(this.routes);
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
    template: '<h3>Dashboard</h3>',
  )
  class DashboardComponent {}
```

You'll make this component more useful later.

### Configure the dashboard route

Add a dashboard route similar to the heroes route by adding a path
and then creating a route definition.

<?code-excerpt "lib/src/route_paths.dart (dashboard)" title?>
```
  final dashboard = RoutePath(path: 'dashboard');
```

<?code-excerpt "lib/src/routes.dart (dashboard)" replace="/(all = \[)[\S\s]+?···/$1/g" title?>
```
  RoutePath get dashboard => paths.dashboard;
  // ···
  final List<RouteDefinition> all = [
    RouteDefinition(
      path: paths.dashboard.path,
      component: dct.DashboardComponentNgFactory,
    ),
    // ···
  ];
```

You'll also need to import the compiled dashboard template:

<?code-excerpt "lib/src/routes.dart (dct)" title?>
```
  import 'dashboard_component.template.dart' as dct;
```

### Add a redirect route

Currently, the browser launches with `/` in the address bar.
When the app starts, it should show the dashboard and
display the `/#/dashboard` path in the address bar.

To make this happen, add a redirect route:

<?code-excerpt "lib/src/routes.dart (redirect route)" title?>
```
  RouteDefinition.redirect(path: '', redirectTo: paths.dashboard.toUrl()),
```

<div class="l-sub-section" markdown="1">
  Alternatively, you could define `Dashboard` as a _default_ route.
  Read more about
  [default routes](/angular/guide/router/2#default-route) and
  [redirects](/angular/guide/router/2#redirect-route) in the
  [Routing & Navigation](/angular/guide/router/2) page.
</div>

### Add navigation to the dashboard

Add a dashboard link to the app component template, just above the heroes link.

<?code-excerpt "lib/app_component.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <nav>
      <a [routerLink]="routes.dashboard.toUrl()"
         routerLinkActive="active">Dashboard</a>
      <a [routerLink]="routes.heroes.toUrl()"
         routerLinkActive="active">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
```

<div class="l-sub-section" markdown="1">
  The `<nav>` element and the `routerLinkActive` directives don't do anything yet,
  but they'll be useful later when you [style the links](#style-the-navigation-links).
</div>

<i class="material-icons">open_in_browser</i> **Refresh the browser,** then
visit [localhost:8080/](http://localhost:8080/){:.no-automatic-external}. The
app displays the dashboard and you can navigate between the dashboard and the
heroes list.

## Add heroes to the dashboard

To make the dashboard more interesting, you'll display the top four heroes at a glance.

Replace the `template` metadata with a `templateUrl` property that points to a new
template file, and add the directives shown below (you'll add the necessary imports soon):

<?code-excerpt "lib/src/dashboard_component_2.dart (metadata)" region="metadata-wo-styles" title?>
```
  @Component(
    selector: 'my-dashboard',
    templateUrl: 'dashboard_component.html',
    // ···
    directives: [coreDirectives],
  )
```

<div class="l-sub-section" markdown="1">
  The value of `templateUrl` can be an [asset][] in this package or another
  package. To refer to an asset from another package, use a full package reference,
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

### Reusing the *HeroService*

To populate the component's `heroes` list, you can reuse the `HeroService`.

Earlier, you removed the `HeroService` from the `providers` list of `HeroListComponent`
and added it to the `providers` list of `AppComponent`.
That move created a singleton `HeroService` instance, available to all components of the app.
Angular injects `HeroService` and you can use it in the `DashboardComponent`.

### Get heroes

In `dashboard_component.dart`, add the following `import` statements.

<?code-excerpt "lib/src/dashboard_component_2.dart (imports)" title?>
```
  import 'dart:async';

  import 'package:angular/angular.dart';

  import 'hero.dart';
  import 'hero_service.dart';
```

Now create the `DashboardComponent` class like this:

<?code-excerpt "lib/src/dashboard_component_2.dart (class)" title?>
```
  class DashboardComponent implements OnInit {
    List<Hero> heroes;

    final HeroService _heroService;

    DashboardComponent(this._heroService);

    Future<void> ngOnInit() async {
      heroes = (await _heroService.getAll()).skip(1).take(4).toList();
    }
  }
```

You're using the same kind of features for the dashboard as you did for the heroes component:

* Define a `heroes` list property.
* Inject a `HeroService` in the constructor, saving it to a private field.
* Call the service to get heroes inside the Angular `ngOnInit()` lifecycle hook.

In this dashboard you specify four heroes (2nd, 3rd, 4th, and 5th).

<i class="material-icons">open_in_browser</i>
**Refresh the browser** to see four hero names in the new dashboard.

## Navigating to hero details

While the details of a selected hero displays at the bottom of the `HeroListComponent`,
users should be able to navigate to a `HeroComponent` in the following additional ways:

* From the dashboard to a selected hero.
* From the heroes list to a selected hero.
* From a "deep link" URL pasted into the browser address bar.

### Routing to a hero detail

You can add a route to the `HeroComponent` in `AppComponent`, where the other routes are defined.

The new route is unusual in that you must tell the `HeroComponent` which hero to show.
You didn't have to tell the `HeroListComponent` or the `DashboardComponent` anything.

Currently, the parent `HeroListComponent` sets the component's `hero` property to a
hero object with a binding like this:

<?code-excerpt "../toh-3/lib/app_component.html (my-hero)"?>
```html
  <my-hero [hero]="selected"></my-hero>
```

But this binding won't work in any of the routing scenarios.

### Parameterized route

You can add the hero's ID to the route path. When routing to the hero whose ID is 11,
you could expect to see a path such as this:

```nocode
/heroes/11
```

The `/heroes/` part is constant. The trailing numeric ID changes from hero to hero.
You need to represent the variable part of the route with a *parameter* that stands for the hero's ID.

### Add a route with a parameter

First, define the route path:

<?code-excerpt "lib/src/route_paths.dart (hero)" title?>
```
  const idParam = 'id';
  final hero = RoutePath(path: '${heroes.path}/:$idParam');
```

The colon (:) in the path indicates that `:$idParam` (`:id`) is a placeholder
for a specific hero ID when navigating to hero view.

In the routes file, import the hero detail component template:

<?code-excerpt "lib/src/routes.dart (excerpt)" region="hct" title?>
```
  import 'hero_component.template.dart' as hct;
```

Next, add the following route:

<?code-excerpt "lib/src/routes.dart (hero)" title?>
```
  RoutePath get hero => paths.hero;

  final List<RouteDefinition> all = [
    // ···
    RouteDefinition(
      path: paths.hero.path,
      component: hct.HeroComponentNgFactory,
    ),
    // ···
  ];
```

You're finished with the app routes.

You didn't add a hero detail link to the template because users
don't click a navigation *link* to view a particular hero;
they click a *hero name*, whether the name is displayed on the dashboard or in the heroes list.
But this won't work until the `HeroComponent`
is revised and ready to be navigated to.

## Revise *HeroComponent*

Here's what the `HeroComponent` looks like now:

<?code-excerpt "../toh-4/lib/src/hero_component.dart" region="" title="lib/src/hero_component.dart (current)" linenums?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_forms/angular_forms.dart';

  import 'hero.dart';

  @Component(
    selector: 'my-hero',
    template: '''
      <div *ngIf="hero != null">
        <h2>{!{hero.name}!}</h2>
        <div><label>id: </label>{!{hero.id}!}</div>
        <div>
          <label>name: </label>
          <input [(ngModel)]="hero.name" placeholder="name"/>
        </div>
      </div>
    ''',
    directives: [coreDirectives, formDirectives],
  )
  class HeroComponent {
    @Input()
    Hero hero;
  }
```

The template won't change. Hero names will display the same way.
The major changes are driven by how you get hero names.

### Drop *@Input()*

You will no longer receive the hero in a parent component property binding, so
you can **remove the `@Input()` annotation** from the `hero` field:

<?code-excerpt "lib/src/hero_component.dart (hero with @Input removed)" region="hero" replace="/implements \w+ //g" plaster="none" title?>
```
  class HeroComponent {
    Hero hero;
  }
```

### Add *onActivate()* life-cycle hook

The new `HeroComponent` will take the `id` parameter from the router's
state and use the `HeroService` to fetch the hero with that `id`.

Add the following imports:

<?code-excerpt "lib/src/hero_component.dart (added-imports)" title?>
```
  import 'dart:async';
  // ···
  import 'package:angular_router/angular_router.dart';
  // ···
  import 'hero_service.dart';
  import 'route_paths.dart' as paths;
```

Inject the `HeroService` and [Location][] service
into the constructor, saving their values in private fields:

<?code-excerpt "lib/src/hero_component.dart (constructor)" region="ctor" title?>
```
  final HeroService _heroService;
  final Location _location;

  HeroComponent(this._heroService, this._location);
```

To get notified when a hero route is natigated to, make `HeroComponent`
implement the [OnActivate][] interface, and update `hero` from
the [onActivate()][] [router lifecycle hook][]:

<?code-excerpt "lib/src/hero_component.dart (OnActivate)" title?>
```
  class HeroComponent implements OnActivate {
    // ···
    @override
    Future<void> onActivate(_, RouterState current) async {
      final id = paths.getId(current.parameters);
      if (id != null) hero = await (_heroService.get(id));
    }
    // ···
  }
```

The hook implementation makes use of the `getId()` helper function that
extracts the `id` from the [RouterState.parameters][] map.

<?code-excerpt "lib/src/route_paths.dart (getId)" title?>
```
  int getId(Map<String, String> parameters) {
    final id = parameters[idParam];
    return id == null ? null : int.tryParse(id);
  }
```

The hero ID is a number. Route parameters are always strings.
So the route parameter value is converted to a number.

### Add *HeroService.get()*

In `onActivate()`, you used the `get()` method, which `HeroService` doesn't
have yet. To fix this issue, open `HeroService` and add a `get()` method
that filters the heroes list from `getAll()` by `id`.

<?code-excerpt "lib/src/hero_service.dart (get)" title?>
```
  Future<Hero> get(int id) async =>
      (await getAll()).firstWhere((hero) => hero.id == id);
```

### Find the way back

Users have several ways to navigate *to* the `HeroComponent`.

To navigate somewhere else, users can click one of the two links in the `AppComponent` or click the browser's back button.
Now add a third option, a `goBack()` method that navigates backward one step in the browser's history stack
using the `Location` service you injected previously.

<?code-excerpt "lib/src/hero_component.dart (goBack)" title?>
```
  void goBack() => _location.back();
```

<div class="l-sub-section" markdown="1">
  Going back too far could take users out of the app.
  In a real app, you can prevent this issue with the _canDeactivate()_ hook.
  Read more on the [CanDeactivate](/api/angular_router/angular_router/CanDeactivate-class) page.
</div>

You'll wire this method with an event binding to a *Back* button that you'll add to the component template.

<?code-excerpt "lib/src/hero_component.html (back-button)"?>
```
  <button (click)="goBack()">Back</button>
```

Migrate the template to its own file called `hero_component.html`:

<?code-excerpt "lib/src/hero_component.html" title?>
```
  <div *ngIf="hero != null">
    <h2>{!{hero.name}!}</h2>
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

<?code-excerpt "lib/src/hero_component.dart (metadata)" region="metadata-wo-style" title?>
```
  @Component(
    selector: 'my-hero',
    templateUrl: 'hero_component.html',
    // ···
    directives: [coreDirectives, formDirectives],
  )
```

<i class="material-icons">open_in_browser</i>
**Refresh the browser** and visit
[localhost:8080/#heroes/11](http://localhost:8080/#heroes/11){:.no-automatic-external}.
Details for hero 11 should be displayed. Selecting a hero
in either the dashboard or the heroes list doesn't work yet.
You'll deal with that next.

## Select a dashboard hero

When a user selects a hero in the dashboard, the app should navigate to a
`HeroComponent` to allow the user to view and edit the selected hero.

The dashboard heroes should behave like anchor tags:
when hovering over a hero name, the target URL should display in the browser status bar
and the user should be able to copy the link or open the hero detail view in a new tab.

To achieve this, you'll need to make changes to the dashboard component and its
template.

Update the dashboard component:

- Import `route_paths.dart` as `paths`
- Add `routerDirectives` to the `directives` list
- Add the following method:

<?code-excerpt "lib/src/dashboard_component.dart (heroUrl)" title?>
```
  String heroUrl(int id) =>
      paths.hero.toUrl(parameters: {paths.idParam: id.toString()});
```

Edit the dashboard template:

- Replace the `div` opening and closing tags in the `<div *ngFor...>` element
  with anchor tags.
- Add a router link property binding, as shown.

<?code-excerpt "lib/src/dashboard_component.html (repeated &lt;a&gt; tag)" region="click" replace="/\ba\b|\[routerLink\][^\x3E]+/[!$&!]/g" title?>
```
  <[!a!] *ngFor="let hero of heroes" class="col-1-4"
     [![routerLink]="heroUrl(hero.id)"!]>
    <div class="module hero">
      <h4>{!{hero.name}!}</h4>
    </div>
  </[!a!]>
```

As described in the
[Router links](#router-links) section of this page, top-level navigation in
the `AppComponent` template has router links set to paths like, `/dashboard` and `/heroes`.
This time, you're binding to the parameterized `hero` path you defined earlier:

<?code-excerpt "lib/src/route_paths.dart (hero)"?>
```
  const idParam = 'id';
  final hero = RoutePath(path: '${heroes.path}/:$idParam');
```

The `heroUrl()` method generates the string representation of the path using the
`toUrl()` method, passing route parameter values using a map literal. For
example, it returns [/heroes/15](localhost:8080/#/heroes/15) when `id` is 15.

<i class="material-icons">open_in_browser</i>
**Refresh the browser** and select a hero from the dashboard; the app navigates to that hero’s details.

## Select a hero in the *HeroListComponent*

In the `HeroListComponent`,
the current template exhibits a "master/detail" style with the list of heroes
at the top and details of the selected hero below.

<?code-excerpt "lib/src/hero_list_component_1.html" title?>
```
  <h2>Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes"
        [class.selected]="hero === selected"
        (click)="onSelect(hero)">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
  <my-hero [hero]="selected"></my-hero>
```

You'll no longer show the full `HeroComponent` here.
Instead, you'll display the hero detail on its own page and route to it as you did in the dashboard.
Make these changes:

- Remove the `<my-hero>` element from the last line of the template.
- Remove `HeroComponent` from list of `directives`.
- Remove the hero detail import.

When users select a hero from the list, they won't go to the detail page.
Instead, they'll see a mini detail on *this* page and have to click a button to navigate to the *full detail* page.

### Add the *mini detail*

Add the following HTML fragment at the bottom of the template where the `<my-hero>` used to be:

<?code-excerpt "lib/src/hero_list_component.html (mini detail)" title?>
```
  <div *ngIf="selected != null">
    <h2>
      {!{selected.name | uppercase}!} is my hero
    </h2>
    <button (click)="gotoDetail()">View Details</button>
  </div>
```

Add the following import and method stub to `HeroListComponent`:

<?code-excerpt "lib/src/hero_list_component.dart (gotoDetail stub)" title retain="/^\s*($|[^_\s])/" replace="/(.*?=\x3E).*/$1 null;/g"?>
```
  import 'package:angular_router/angular_router.dart';
  // ···
  class HeroListComponent implements OnInit {
    // ···
    Future<NavigationResult> gotoDetail() => null;
  }
```

After clicking a hero (but don't try now since it won't work yet), users should see something like this below the hero list:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/mini-hero-detail.png' %}" alt="Mini Hero Detail" width="250">

The hero's name is displayed in capital letters because of the `uppercase` pipe
that's included in the interpolation binding, right after the pipe operator ( | ).

<?code-excerpt "lib/src/hero_list_component.html (pipe)"?>
```
  {!{selected.name | uppercase}!} is my hero
```

Pipes are a good way to format strings, currency amounts, dates and other display data.
Angular ships with several pipes and you can write your own.

<i class="material-icons">warning</i> Before you can use an Angular pipe in a
template, you need to list it in the `pipes` argument of your component's
`@Component` annotation. You can add pipes
individually, or for convenience you can use groups like [commonPipes][].

<?code-excerpt "lib/src/hero_list_component.dart (pipes)" title?>
```
  @Component(
    selector: 'my-heroes',
    // ···
    pipes: [commonPipes],
  )
```

<div class="l-sub-section" markdown="1">
  Read more about pipes on the [Pipes](/angular/guide/pipes) page.
</div>

<i class="material-icons">open_in_browser</i>
**Refresh the browser.** Selecting a hero from the heroes list will activate the mini
detail view. The view details button doesn't work yet.

### Update the _HeroListComponent_ class

The `HeroListComponent` navigates to the `HeroesDetailComponent` in response to a button click.
The button's click event is bound to a `gotoDetail()` method that should navigate _imperatively_
by telling the router where to go.

This approach requires the following changes to the component class:

- Import `route_paths.dart` as `paths`.
- Inject the `Router` in the constructor, along with the `HeroService`.
- Implement `gotoDetail()` by calling the router `navigate()` method.

Here's the revised `HeroListComponent` class:

<?code-excerpt "lib/src/hero_list_component.dart (class)" title?>
```
  class HeroListComponent implements OnInit {
    final HeroService _heroService;
    final Router _router;
    List<Hero> heroes;
    Hero selected;

    HeroListComponent(this._heroService, this._router);

    Future<void> _getHeroes() async {
      heroes = await _heroService.getAll();
    }

    void ngOnInit() => _getHeroes();

    void onSelect(Hero hero) => selected = hero;

    String _heroUrl(int id) =>
        paths.hero.toUrl(parameters: {paths.idParam: id.toString()});

    Future<NavigationResult> gotoDetail() =>
        _router.navigate(_heroUrl(selected.id));
  }
```

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

Create a `hero_component.css` file in the `lib/src`
folder and reference that file in the component metadata’s `styleUrls` list:

<code-tabs>
  <?code-pane "lib/src/hero_component.dart (styleUrls)" region="metadata" linenums?>
  <?code-pane "lib/src/hero_component.css" linenums?>
</code-tabs>

### Style the navigation links

Create an `app_component.css` file in the `lib` folder
and reference that file in the component metadata’s `styleUrls` list:

<code-tabs>
  <?code-pane "lib/app_component.dart (styleUrls)" linenums?>
  <?code-pane "lib/app_component.css" linenums?>
</code-tabs>

The provided CSS makes the navigation links in the `AppComponent` look more like selectable buttons.
Earlier, you surrounded those links with a `<nav>` element,
and added a `routerLinkActive` directive to each anchor:

<?code-excerpt "lib/app_component.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <nav>
      <a [routerLink]="routes.dashboard.toUrl()"
         routerLinkActive="active">Dashboard</a>
      <a [routerLink]="routes.heroes.toUrl()"
         routerLinkActive="active">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
```

The router adds the class named by the [RouterLinkActive][] directive to
the HTML navigation element whose route matches the active route.

### Global app styles

When you add styles to a component, you keep everything a component needs&mdash;HTML,
the CSS, the code&mdash;together in one convenient place.
It's easy to package it all up and reuse the component somewhere else.

You can also create styles at the *app level* outside of any component.

The designers provided some basic styles to apply to elements across the entire app.
These correspond to the full set of master styles that you installed earlier during [setup](/angular/guide/setup).
Here's an excerpt:

<?code-excerpt path-base="examples/ng/doc/_boilerplate"?>

<?code-excerpt "web/styles.css (excerpt)" region="toh" title?>
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

<?code-excerpt path-base="examples/ng/doc/toh-5"?>

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
      - hero_component.{css,dart,html}
      - hero_list_component.{css,dart,html}
      - hero_service.dart
      - mock_heroes.dart
      - route_paths.dart
      - routes.dart
  - test
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
[commonPipes]: /api/angular/angular/commonPipes-constant
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[master styles]: https://raw.githubusercontent.com/angular/angular.io/master/public/docs/_examples/_boilerplate/src/styles.css
[HashLocationStrategy]: /api/angular_router/angular_router/HashLocationStrategy-class
[Location]: /api/angular_router/angular_router/Location-class
[OnActivate]: /api/angular_router/angular_router/OnActivate-class
[onActivate()]: /angular/guide/router/5#on-activate
[property binding]: /angular/guide/template-syntax#property-binding
[PathLocationStrategy]: /api/angular_router/angular_router/PathLocationStrategy-class
[router lifecycle hook]: /angular/guide/router/5
[RouteDefinition]: /api/angular_router/angular_router/RouteDefinition-class
[routerDirectives]: /api/angular_router/angular_router/routerDirectives-constant
[RouterLink]: /api/angular_router/angular_router/RouterLink-class
[RouterLinkActive]: /api/angular_router/angular_router/RouterLinkActive-class
[RouterOutlet]: /api/angular_router/angular_router/RouterOutlet-class
[routerProviders]: /api/angular_router/angular_router/routerProviders-constant
[routerProvidersHash]: /api/angular_router/angular_router/routerProvidersHash-constant
[RouterState]: /api/angular_router/angular_router/RouterState-class
[RouterState.parameters]: /api/angular_router/angular_router/RouterState/parameters
