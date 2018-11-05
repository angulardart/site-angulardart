---
title: "Component Testing: Page Objects"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Basics"
  url: /angular/guide/testing/component/basics
nextpage:
  title: "Component Testing: Simulating user action"
  url: /angular/guide/testing/component/simulating-user-action
---
<?code-excerpt path-base="examples/ng/doc"?>
{% capture pageloaderObjectsApi %}{{site.api}}/pageloader/latest/pageloader.objects{% endcapture %}

{% include_relative _page-top-toc.md %}

As components and their templates become more complex, you'll want to
[separate concerns][] and isolate testing code from the detailed HTML
encoding of page elements in templates.

You can achieve this separation by creating **[page object][]** (PO) classes
having APIs written in terms of _application-specific concepts_, such as
"title", "hero ID", and "hero name". A PO class encapsulates details about:

- HTML element access, for example, whether a hero name is contained in a
  heading element or a `<div>`
- Type conversions, for example, from `String` to `int`, as you'd need to
  do for a hero ID

## Pubspec configuration

The [angular_test][] package recognizes page objects implemented using annotations
from the [pageloader][] package.

Add the package to the pubspec dependencies:

<?code-excerpt "toh-0/pubspec.yaml" diff-with="toh-1/pubspec.yaml" from="dev_dependencies" to=" test:"?>
```diff
--- toh-0/pubspec.yaml
+++ toh-1/pubspec.yaml
@@ -7,15 +7,12 @@

 dependencies:
   angular: ^5.0.0
+  angular_forms: ^2.0.0

 dev_dependencies:
   angular_test: ^2.0.0
   build_runner: ^1.0.0
   build_test: ^0.10.2
   build_web_compilers: ^0.4.0
+  pageloader: ^3.0.0
   test: ^1.0.0
```

## Imports

Include these imports at the top of your page object file:

<?code-excerpt "toh-1/test/app_po.dart (imports)" title?>
```
  import 'dart:async';

  import 'package:pageloader/pageloader.dart';
```

Update the imports at the top of your test file:

<?code-excerpt "toh-0/test/app_test.dart" diff-with="toh-1/test/app_test.dart" to="void main"?>
```diff
--- toh-0/test/app_test.dart
+++ toh-1/test/app_test.dart
@@ -1,42 +1,52 @@
 @TestOn('browser')

 import 'package:angular_test/angular_test.dart';
 import 'package:angular_tour_of_heroes/app_component.dart';
 import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
+import 'package:pageloader/html.dart';
 import 'package:test/test.dart';

+import 'app_po.dart';
+
 void main() {
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
  test('title', () {
    expect(appPO.title, 'Tour of Heroes');
  });
```

## PO class

Pageloader recognizes POs that satisfy the following conditions.

- Source file:
  - The file contains a `part` statement referring to the filename but with a `.g.dart` suffix.
  - The file doesn't contain any Angular annotations (like `@Component` or
    `@GenerateInjector`) that would trigger the Angular builder. This is a
    temporary limitation; for details, see
    [pageloader issue #134](https://github.com/google/pageloader/issues/134).
- PO class (declared in the source file):
  - `@PageObject()` annotates the class.
  - The class is `abstract`.
  - The class has these constructors:
    - A default constructor.
    - A factory constructor defined as shown below.

Here's an example of a valid page object implementation:

<?code-excerpt "toh-1/test/app_po.dart (excerpt)" region="boilerplate" title?>
```
  part 'app_po.g.dart';

  @PageObject()
  abstract class AppPO {

    AppPO();
    factory AppPO.create(PageLoaderElement context) = $AppPO.create;
    // ···
  }
```

During the build process, pageloader generates an implementation for your
abstract PO class based on the fields you declare, and saves the implementation
to the `*.g.dart` file. The generated code contains factory methods like
`$AppPO.create`.

## PO field annotation basics {#po-annotations}

You can declaratively identify HTML elements that occur in a component's
template by adorning PO class getters with [pageloader][] annotations like
`@ByTagName('h1')`. For example, an initial version of `AppPO` might look like
this:

<?code-excerpt "toh-1/test/app_po.dart (AppPO initial)" title replace="/(@By|PageLoaderElement get).*/[!$&!]/g"?>
```
  @PageObject()
  abstract class AppPO {

    AppPO();
    factory AppPO.create(PageLoaderElement context) = $AppPO.create;

    [!@ByTagName('h1')!]
    [!PageLoaderElement get _title;!]
    // ···
    String get title => _title.visibleText;
    // ···
  }
```

Because of its [@ByTagName()]({{pageloaderObjectsApi}}/ByTagName-class.html)
annotation, the `_h1` field will get bound to the app component
[template's `<h1>` element](#toh-1libapp_componentdart-template).

Other basic tags, which you'll soon see examples of, include:
- [@ByClass()]({{pageloaderObjectsApi}}/ByClass-class.html)
- [@ByCss()]({{pageloaderObjectsApi}}/ByCss-class.html)
- [@ById()]({{pageloaderObjectsApi}}/ById-class.html)
- [@First()]({{pageloaderObjectsApi}}/First-class.html)
- [@WithVisibleText()]({{pageloaderObjectsApi}}/WithVisibleText-class.html)

The PO `title` field returns the heading element's text.

## PO instantiation

Create PO instances using the PO factory constructor. PO fields are **lazily
initialized** from a _context_ passed as an argument to the constructor. Create a
context from the fixture's [rootElement][] as shown below. Since most page
objects are shared across tests, they are generally initialized during setup:

<?code-excerpt "toh-1/test/app_test.dart (appPO setup)" title replace="/(final context |appPO |HtmlPageLoaderElement\.).*/[!$&!]/g"?>
```
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    [!final context =!]
        [!HtmlPageLoaderElement.createFromElement(fixture.rootElement);!]
    [!appPO = AppPO.create(context);!]
  });
```

## Using POs in tests

When the [Hero Editor][toh-pt1] app loads, it displays
data for a hero named _Windstorm_ having id 1. Here's how you might test
for this:

<?code-excerpt "toh-1/test/app_test.dart (hero)" title?>
```
  const windstormData = <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () {
    expect(appPO.heroId, windstormData['id']);
    expect(appPO.heroName, windstormData['name']);
  });
```

After looking at the app component's [template](#toh-1libapp_componentdart-template),
you might define the PO `heroId` and `heroName` fields like this:

<?code-excerpt "toh-1/test/app_po.dart (AppPO hero)" title?>
```
  abstract class AppPO {
    // ···
    @First(ByCss('div'))
    PageLoaderElement get _id; // e.g. 'id: 1'

    @ByTagName('h2')
    PageLoaderElement get _heroName;
    // ···
    int get heroId {
      final idAsString = _id.visibleText.split(':')[1];
      return int.tryParse(idAsString) ?? -1;
    }

    String get heroName => _heroName.visibleText;
    // ···
  }
```

The page object extracts the id from text that follows the "id:" label in
the first `<div>`, and the hero name from the `<h2>` text.

<div class="alert alert-warning" markdown="1">
  <h4>PO field bindings are lazily initialized and final</h4>

  PO fields are bound when the field is first accessed, based on the state of the
  fixture's root element. Once bound, they do not change.
</div>

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
  List<PageLoaderElement> get _heroes;
```

When bound, the `_heroes` list will contain an element for each `<li>` in the view. If the displayed heroes list is empty, then `_heroes` will be an empty list
&mdash; `List<PageLoaderElement>` PO fields are never `null`.

You might render hero data (as a map) from the text of the `<li>` elements like this:

<?code-excerpt "toh-2/test/app_po.dart (heroes)" title?>
```
  Iterable<Map> get heroes =>
      _heroes.map((el) => _heroDataFromLi(el.visibleText));

  // ···
  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
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

Declare an optional field like any other field:

<?code-excerpt "toh-2/test/app_po.dart (hero detail ID)" title?>
```
  @First(ByCss('div div'))
  PageLoaderElement get _heroDetailId;
```

To determine whether an optionally displayed page element is present, test its
`exists` property:

<?code-excerpt "toh-2/test/app_po.dart (heroFromDetails)" title replace="/\w+\.exists/[!$&!]/g"?>
```
  Map get heroFromDetails {
    if (![!_heroDetailId.exists!]) return null;
    // ···
  }
```

{% comment %}
NOTE: Because fields are lazily initialized, and because we don't test the fields both
before and after the call to `selectHero()`, we don't require a new PO instance. We might
new a new instance in later tests, so I'm keeping this prose for now.

## Getting optional POs after view updates

Initially, there is no selected hero in the [Heroes List][toh-pt2].
After selecting a hero by [simulating a user click][], you'll want to check
that the proper hero details are shown in the updated view.
You'll need to fetch a new PO (since the old PO has null optional fields):

<?code-excerpt "toh-2/test/app_test.dart (new PO after view update)"?>
```
  await appPO.selectHero(5);
  // ···
  expect(appPO.selected, targetHero);
```

You'll most likely have more than one test over the selected hero.
One way to address this is to create a test group with its own
setup method, which selects the hero and gets a new PO.

<?code-excerpt "toh-2/test/app_test.dart (show hero details)" title?>
```
  const targetHero = {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    await appPO.selectHero(5);
  });

  test('is selected', () {
    expect(appPO.selected, targetHero);
  });

  test('show hero details', () {
    expect(appPO.heroFromDetails, targetHero);
  });
```
{% endcomment %}

[angular_test]: https://pub.dartlang.org/packages/angular_test
[@optional]: {{pageloaderObjectsApi}}/optional-constant.html
[issue 1351]: https://github.com/dart-lang/site-webdev/issues/1351
[page object]: https://martinfowler.com/bliki/PageObject.html
[pageloader]: https://pub.dartlang.org/packages/pageloader
[rootElement]: {{site.api}}/angular_test/latest/angular_test/NgTestFixture/rootElement.html
[separate concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[toh-pt1]: /angular/tutorial/toh-pt1
[toh-pt2]: /angular/tutorial/toh-pt2
[tutorial]: /angular/tutorial
[simulating a user click]: ./simulating-user-action#click
