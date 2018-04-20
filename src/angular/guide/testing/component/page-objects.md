---
layout: angular
title: "Component Testing: Page Objects"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Basics"
  url: /angular/guide/testing/component/basics
nextpage:
  title: "Component Testing: Simulating user action"
  url: /angular/guide/testing/component/simulating-user-action
pageloaderObjectsApi: https://www.dartdocs.org/documentation/pageloader/latest/pageloader.objects
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

As components and their templates become more complex, you'll want to
[separate concerns][] and isolate testing code from the detailed HTML
encoding of page elements in templates.

You can achieve this separation by creating **[page object][]** (PO) classes
having APIs written in terms of _application-specific concepts_, such as
"title", "hero id", and "hero name". A PO class encapsulates details about:

- HTML element access, for example, whether a hero name is contained in a
  heading element or a `<div>`
- Type conversions, for example, from `String` to `int`, as you'd need to
  do for a hero id

## Pubspec configuration

The [angular_test][] package recognizes page objects implemented using annotations
from the [pageloader][] package.

{% include_relative _pageloader-mock-warning.md %}

Add the package to the pubspec dependencies:

<?code-excerpt "toh-0/pubspec.yaml" diff-with="toh-1/pubspec.yaml" from="dev_dependencies" to=" test:"?>
```diff
--- toh-0/pubspec.yaml
+++ toh-1/pubspec.yaml
@@ -1,4 +1,3 @@
 name: angular_tour_of_heroes
 description: Tour of Heroes
 version: 0.0.1
@@ -8,15 +7,19 @@

 dependencies:
   angular: ^5.0.0-alpha
+  angular_forms: ^2.0.0-alpha

 dev_dependencies:
   angular_test: ^2.0.0-alpha
   build_runner: ^0.8.2
   build_test: ^0.10.0
   build_web_compilers: ^0.3.6
   test: ^0.12.30
```

## Imports

Include these imports at the top of your page object class:

<?code-excerpt "toh-2/test/app_po.dart (imports)" title?>
```
  import 'dart:async';

  import 'package:pageloader/objects.dart';
```

## Running example

As running examples, this page uses the [Hero Editor][toh-pt1] and [Heroes List][toh-pt2] apps from parts 1 and 2 of the [tutorial][], respectively.

You'll first see POs and tests for the [tutorial][]'s simple [Hero Editor][toh-pt1]. Before proceeding, review the [final code][] of the [tutorial part 1][toh-pt1]
and take note of the app component template:

[final code]: /angular/tutorial/toh-pt1#the-road-youve-travelled

<?code-excerpt "toh-1/lib/app_component.dart (template)" title?>
```
  template: '''
    <h1>{!{title}!}</h1>
    <h2>{!{hero.name}!}</h2>
    <div><label>id: </label>{!{hero.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="hero.name" placeholder="name">
    </div>
  ''',
```

You can use a single page object for an entire app when it is as simple
as the Hero Editor. You might use such a page object to test the title like this:

<?code-excerpt "toh-1/test/app_test.dart (title)" title?>
```
  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });
```

## PO field annotation basics {#po-annotations}

You can declaratively identify HTML elements that occur in a component's
template by adorning PO class fields with [pageloader][] annotations like `@ByTagName('h1')`.
During test execution, the package binds such fields to the
DOM element(s) specified by the annotation. For example,
an initial version of `AppPO` might look like this:

<?code-excerpt "toh-1/test/app_test.dart (AppPO initial)" title?>
```
  class AppPO extends PageObjectBase {
    @ByTagName('h1')
    PageLoaderElement get _title => q('h1');
    // ···
    Future<String> get title => _title.visibleText;
    // ···
  }
```

<div class="alert alert-warning" markdown="1">
  **Warning:**
  Use of the mock pageloader [temporarily][issue 1351] requires that all
  annotated page object fields be **getters** bound to a query function.
  The CSS selector used in the annotation is passed as an argument to the
  query function.
</div>

Because of its **[@ByTagName()]({{page.pageloaderObjectsApi}}/ByTagName-class.html)**
annotation, the `_h1` field will get bound to the app component
[template's `<h1>` element](#toh-1libapp_componentdart-template).

Other basic tags, which you'll soon see examples of, include:
- **[@ByClass()]({{page.pageloaderObjectsApi}}/ByClass-class.html)**
- **[@ByCss()]({{page.pageloaderObjectsApi}}/ByCss-class.html)**
- **[@ById()]({{page.pageloaderObjectsApi}}/ById-class.html)**
- **[@FirstByCss()]({{page.pageloaderObjectsApi}}/FirstByCss-class.html)**
- **[@WithVisibleText()]({{page.pageloaderObjectsApi}}/WithVisibleText-class.html)**

The PO `title` field returns the heading element's text.
Access to page elements is **asynchronous**, which is why `title` is of type
[Future][], and the "title" test shown [earlier](#toh-1testapp_testdart-title)
is marked as `async`.

[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html

## PO instantiation

Get a PO instance from the fixture's `resolvePageObject()` method, passing the
PO type as argument. Since most page objects are shared across tests, they are
generally initialized during setup:

<?code-excerpt "toh-1/test/app_test.dart (appPO setup)" title?>
```
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await new AppPO().resolve(fixture);
  });
```

<div class="alert alert-warning" markdown="1">
  **Warning:**
  Support for `resolvePageObject()` has been [temporarily][issue 1351]
  removed from `angular_test`. In the meantime, initialize page object classes
  built using the mock pageloader as shown above.
</div>

<div class="alert alert-warning" markdown="1">
  <h4>PO field bindings are final</h4>

  PO fields are bound at the time the PO instance is created, based on
  the state of the fixture's component's view. Once bound, they do not
  change.
</div>

## Using POs in tests

When the [Hero Editor][toh-pt1] app loads, it displays
data for a hero named _Windstorm_ having id 1. Here's how you might test
for this:

<?code-excerpt "toh-1/test/app_test.dart (hero)" title?>
```
  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });
```

After looking at the app component's [template](#toh-1libapp_componentdart-template),
you might define the PO `heroId` and `heroName` fields like this:

<?code-excerpt "toh-1/test/app_test.dart (AppPO hero)" title?>
```
  class AppPO extends PageObjectBase {
    // ···
    @FirstByCss('div')
    PageLoaderElement get _id => q('div'); // e.g. 'id: 1'

    @ByTagName('h2')
    PageLoaderElement get _heroName => q('h2');
    // ···
    Future<int> get heroId async {
      final idAsString = (await _id.visibleText).split(':')[1];
      return int.tryParse(idAsString) ?? -1;
    }

    Future<String> get heroName => _heroName.visibleText;
    // ···
  }
```

The page object extracts the id from text that follows the "id:" label in
the first `<div>`, and the hero name from the `<h2>` text.

## PO _List_ fields

The app from [part 2][toh-pt2] of the [tutorial][] displays a list of heros, generated using an `ngFor` applied to an `<li>` element:

<?code-excerpt "toh-2/lib/app_component.html" remove="/h1|div|input|label|selected.name/" title?>
```
  <h2>Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes"
        [class.selected]="hero === selected"
        (click)="onSelect(hero)">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
```

To define a PO field that collects all generated `<li>` elements, use the annotations introduced [earlier](#po-annotations), but declare the field to be of type `List<PageLoaderElement>`:

<?code-excerpt "toh-2/test/app_po.dart (_heroes)" title?>
```
  @ByTagName('li')
  List<PageLoaderElement> get _heroes => qq('li');
```

When bound, the `_heroes` list will contain an element for each `<li>` in the view. If the displayed heroes list is empty, then `_heroes` will be an empty list
&mdash; `List<PageLoaderElement>` PO fields are never `null`.

You might render hero data (as a map) from the text of the `<li>` elements like this:

<?code-excerpt "toh-2/test/app_po.dart (heroes)" title?>
```
  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

  // ···
  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
```

## PO optional fields

Only once a hero is selected from the [Heroes List][toh-pt2], are the selected hero's details displayed using this template fragment:

<?code-excerpt "toh-2/lib/app_component.html" remove="/h1|[Hh]ero|li|ul\x3E/" title?>
```
  <div *ngIf="selected != null">
    <h2>{!{selected.name}!}</h2>
    <div><label>id: </label>{!{selected.id}!}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="selected.name" placeholder="name">
    </div>
  </div>
```

To access optionally displayed page elements like these, use the
**[@optional][]** annotation:

<?code-excerpt "toh-2/test/app_po.dart (hero detail heading)" title?>
```
  @FirstByCss('div h2')
  @optional
  PageLoaderElement get _heroDetailHeading => q('div h2');
```

When no hero details are present in the view, then `_heroDetailHeading` will be `null`.

## Getting optional POs after view updates

Initially, there is no selected hero in the [Heroes List][toh-pt2].
After selecting a hero by [simulating a user click][], you'll want to check
that the proper hero details are shown in the updated view.
You'll need to fetch a new PO (since the old PO has null optional fields):

<?code-excerpt "toh-2/test/app_test.dart (new PO after view update)"?>
```
  await appPO.selectHero(5);
  appPO = await new AppPO().resolve(fixture);
  // ···
  expect(await appPO.selected, targetHero);
```

You'll most likely have more than one test over the selected hero.
One way to address this is to create a test group with its own
setup method, which selects the hero and gets a new PO.

<?code-excerpt "toh-2/test/app_test.dart (show hero details)" title?>
```
  const targetHero = {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    await appPO.selectHero(5);
    appPO = await new AppPO().resolve(fixture);
  });

  test('is selected', () async {
    expect(await appPO.selected, targetHero);
  });

  test('show hero details', () async {
    expect(await appPO.heroFromDetails, targetHero);
  });
```

[angular_test]: https://pub.dartlang.org/packages/angular_test
[@optional]: {{page.pageloaderObjectsApi}}/optional-constant.html
[issue 1351]: https://github.com/dart-lang/site-webdev/issues/1351
[page object]: https://martinfowler.com/bliki/PageObject.html
[pageloader]: https://pub.dartlang.org/packages/pageloader
[separate concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[toh-pt1]: /angular/tutorial/toh-pt1
[toh-pt2]: /angular/tutorial/toh-pt2
[tutorial]: /angular/tutorial
[simulating a user click]: ./simulating-user-action#click
