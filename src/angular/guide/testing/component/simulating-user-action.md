---
layout: angular
title: "Component Testing: Simulating user action"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Page Objects"
  url: /angular/guide/testing/component/page-objects
nextpage:
  title: "Component Testing: Services"
  url: /angular/guide/testing/component/services
---
{% include_relative _page-top-toc.md %}

## Click
{%comment%}Previous title: Simulated click: button and hero selection {#click}{%endcomment%}

Use the [PageLoaderElement.click()][] method to simulate a user
click on a given PO element. Here is an example for a _back_ button:

<?code-excerpt "toh-5/test/hero_detail_po.dart (back button)" title?>
```
  @ByTagName('button')
  PageLoaderElement _button;
  /* . . . */
  Future back() => _button.click();
```

Similarly, you might define a PO method for selecting a hero from
a list as follows:

<?code-excerpt "toh-2/test/app_po.dart (selectHero)" title?>
```
  @ByTagName('li')
  List<PageLoaderElement> _heroes;
  /* . . . */
  Future selectHero(int index) => _heroes[index].click();
```

{%comment%}Note how both methods avoid exposing the `PageLoaderElement` type.{%endcomment%}

## Input: add text
{%comment%}Previous title: Simulated typing: hero name update{%endcomment%}

The [Hero Editor][toh-pt1] allows a user to edit a hero's name by means of
an `<input>` element. Use the [PageLoaderElement.type()][] method to
simulate adding text to the input element:

<?code-excerpt "toh-1/test/app_test.dart (AppPO input)" title?>
```
  class AppPO {
  /* . . . */
    @ByTagName('input')
    PageLoaderElement _input;
    /* . . . */
    Future type(String s) => _input.type(s);
  }
```

Here is an example of how the `type()` method might be used to update a hero's name:

<?code-excerpt "toh-1/test/app_test.dart (update name)" title?>
```
  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
```

## Input: clear

You can clear an input using the [PageLoaderElement.clear()][] method:

<?code-excerpt "toh-2/test/app_po.dart (clear)" title?>
```
  Future clear() => _input.clear();
```

Here is an example of a PO method for adding a new hero. It makes use of both
`clear()` and `type()`:

<?code-excerpt "toh-6/test/heroes_po.dart (addHero)" title?>
```
  Future<Null> addHero(String name) async {
    await _input.clear();
    await _input.type(name);
    return _add.click();
  }
```

[PageLoaderElement.clear()]: {{site.api}}/pageloader/latest/pageloader.html/PageLoaderElement/clear.html
[PageLoaderElement.click()]: {{site.api}}/pageloader/latest/pageloader.html/PageLoaderElement/click.html
[PageLoaderElement]: {{site.api}}/pageloader/latest/pageloader.html/PageLoaderElement-class.html
[PageLoaderElement.type()]: {{site.api}}/pageloader/latest/pageloader.html/PageLoaderElement/type.html
[toh-pt1]: /angular/tutorial/toh-pt1
