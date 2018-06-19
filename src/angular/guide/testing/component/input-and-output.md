---
title: "Component Testing: @Input() and @Output()"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Services"
  url: /angular/guide/testing/component/services
nextpage:
  title: "Component Testing: Routing Components"
  url: /angular/guide/testing/component/routing-components
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

This section describes how to test components with [@Input(), and @Output()
properties](/angular/guide/template-syntax#inputs-outputs).

## Running example

The app from [part 3][] of the [tutorial][] will be used as a running example
to illustrate how to test a component with `@Input()` properties, specifically
the `HeroDetailComponent`:

<?code-excerpt "toh-3/lib/src/hero_component.dart" title?>
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
          <input [(ngModel)]="hero.name" placeholder="name">
        </div>
      </div>''',
    directives: [coreDirectives, formDirectives],
  )
  class HeroComponent {
    @Input()
    Hero hero;
  }
```

Here is the [page object][] for this component:

<?code-excerpt "toh-3/test/hero_detail_po.dart" title?>
```
  import 'dart:async';

  import 'package:pageloader/pageloader.dart';

  part 'hero_detail_po.g.dart';

  @PageObject()
  abstract class HeroDetailPO {
    HeroDetailPO();
    factory HeroDetailPO.create(PageLoaderElement context) = $HeroDetailPO.create;

    @First(ByCss('div h2'))
    PageLoaderElement get _title;

    @First(ByCss('div div'))
    PageLoaderElement get _id;

    @ByTagName('input')
    PageLoaderElement get _input;

    Map get heroFromDetails {
      if (!_id.exists) return null;
      final idAsString = _id.visibleText.split(':')[1];
      return _heroData(idAsString, _title.visibleText);
    }

    Future<void> clear() => _input.clear();
    Future<void> type(String s) => _input.type(s);

    Map<String, dynamic> _heroData(String idAsString, String name) =>
        {'id': int.tryParse(idAsString) ?? -1, 'name': name};
  }
```

The app component template contains a `<my-hero>` element that binds the
`hero` property to the app component's `selectedHero`:

<?code-excerpt "toh-3/lib/app_component.html (my-hero)" title?>
```
  <my-hero [hero]="selected"></my-hero>
```

The tests shown below use the following target hero data:

<?code-excerpt "toh-3/test/hero_detail_test.dart (targetHero)" title?>
```
  const targetHero = {'id': 1, 'name': 'Alice'};
```

## @Input(): No initial value {#input-uninitialized}

This case occurs when either of the following is true:

- The input is bound to an initial null value,
  such as when app component's `selectedHero` is null above.
- A component uses a `<my-hero>` element without a `hero` property:
  ```html
  <my-hero></my-hero>
    ```

When a component is created, its inputs are left uninitialized, so
basic [page object][] setup is sufficient to test for this case:

<?code-excerpt "toh-3/test/hero_detail_test.dart (no initial hero)" title?>
```
  group('No initial @Input() hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });

    test('has empty view', () {
      expect(fixture.rootElement.text.trim(), '');
      expect(po.heroFromDetails, isNull);
    });
    // ···
  });
```

## @Input(): Non-null initial value {#input-initialized}

Initialization of an input property with a non-null value must be done when
the test fixture is created. Provide an initialization callback as the
named parameter `beforeChangeDetection` of the `NgTestBed.create()` method:

<?code-excerpt "toh-3/test/hero_detail_test.dart (initial hero)" title?>
```
  group('${targetHero['name']} initial @Input() hero:', () {
    // ···
    setUp(() async {
      fixture = await testBed.create(
          beforeChangeDetection: (c) =>
              c.hero = Hero(targetHero['id'], targetHero['name']));
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });

    test('show hero details', () {
      expect(po.heroFromDetails, targetHero);
    });
    // ···
  });
```

## @Input(): Change value

To emulate an input binding's change in value, use the
`NgTestFixture.update()` method. This applies whether or not the input
property was [explicitly initialized](#input-initialized):

<?code-excerpt "toh-3/test/hero_detail_test.dart (transition to hero)" title?>
```
  group('No initial @Input() hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });
    // ···

    test('transition to ${targetHero['name']} hero', () async {
      await fixture.update((comp) {
        comp.hero = Hero(targetHero['id'], targetHero['name']);
      });
      expect(po.heroFromDetails, targetHero);
    });
  });
```

## @Output() properties

An `@Output()` property allows a component to raise [custom events][]
in response to a timeout or input event. Output properties are
visible from a component's API as public [Stream][] fields.

You can test an output property by first triggering a change. Then
wait for an expected update on the output property's stream, from
inside the callback passed as argument to the `NgTestFixture.update()` method.

For example, you might test the font [sizer component][], from the
[Two-way binding][] section of the [Template Syntax][] page, as follows:

<?code-excerpt "template-syntax/test/sizer_test.dart (Output after inc)" title?>
```
  group('inc:', () {
    const expectedSize = initSize + 1;

    setUp(() => po.inc());

    test('font size is $expectedSize', () async {
      // ···
    });

    test(
        '@Output $expectedSize size event',
        () => fixture.update((c) async {
              expect(await c.sizeChange.first, expectedSize);
            }));
  });
```

In this test group, the `setUp()` method initiates a font increment event,
and the output test awaits for the updated font size to appear on the
`sizeChange` stream.

Here is the full test file along with other relevant files and excerpts:

<?code-excerpt path-base="examples/ng/doc/template-syntax"?>

<code-tabs>
  <?code-pane "test/sizer_test.dart (full)" region="" linenums?>
  <?code-pane "test/sizer_po.dart" linenums?>
  <?code-pane "lib/src/sizer_component.dart" linenums?>
  <?code-pane "lib/app_component.html (template excerpt)" region="two-way-1" linenums?>
</code-tabs>

[custom events]: /angular/guide/template-syntax#custom-events
[page object]: page-objects
[part 3]: /angular/tutorial/toh-pt3
[Stream]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[sizer component]: /angular/guide/template-syntax#two-way
[Two-way binding]: /angular/guide/template-syntax#two-way
[Template Syntax]: /angular/guide/template-syntax
[tutorial]: /angular/tutorial
