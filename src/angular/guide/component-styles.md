---
title: Component Styles
description: Learn how to apply CSS styles to components.
sideNavGroup: advanced
prevpage:
  title: Attribute Directives
  url: /angular/guide/attribute-directives
nextpage:
  title: Deployment
  url: /angular/guide/deployment
---
<?code-excerpt path-base="examples/ng/doc/component-styles"?>
{%comment%}TODO: consider adding material equivalent to TS Appendices 1 & 2 if relevant.{%endcomment%}

Angular apps are styled with standard CSS. That means you can apply
everything you know about CSS stylesheets, selectors, rules, and media queries
directly to Angular apps.

Additionally, Angular can bundle *component styles*
with components, enabling a more modular design than regular stylesheets.

This page describes how to load and apply these component styles.

Run the {% example_ref %} of the code shown in this page.

## Using component styles

For every Angular component you write, you may define not only an HTML template,
but also the CSS styles that go with that template,
specifying any selectors, rules, and media queries that you need.

One way to do this is to set the `styles` property in the component metadata.
The `styles` property takes a list of strings that contain CSS code.
Usually you give it one string, as in the following example:

<?code-excerpt "lib/app_component.dart (class)" replace="/styles/[!$&!]/g" title?>
```
  @Component(
    selector: 'hero-app',
    template: '''
      <h1>Tour of Heroes</h1>
      <hero-app-main [hero]="hero"></hero-app-main>
    ''',
    [!styles!]: ['h1 { font-weight: normal; }'],
    directives: [HeroAppMainComponent],
  )
  class AppComponent {
    // ···
  }
```

The selectors you put into a component's styles apply only within the template
of that component. The `h1` selector in the preceding example applies only to the `<h1>` tag
in the template of `HeroAppComponent`. Any `<h1>` elements elsewhere in
the app are unaffected.

This is a big improvement in modularity compared to how CSS traditionally works.

* You can use the CSS class names and selectors that make the most sense in the context of each component.
* Class names and selectors are local to the component and don't collide with
  classes and selectors used elsewhere in the app.
* Changes to styles elsewhere in the app don't affect the component's styles.
* You can co-locate the CSS code of each component with the Dart and HTML code of the component,
  which leads to a neat and tidy project structure.
* You can change or remove component CSS code without searching through the
  whole app to find where else the code is used.

## Special selectors

Angular supports a few special selectors from the world of shadow DOM style scoping
(described in [CSS Scoping Module Level 1][] on the [W3C][] site).
The following sections describe these selectors.

<div class="alert alert-warning" markdown="1">
  **Note:** These special selectors have no effect when view encapsulation is disabled.
  For details, see [Controlling view encapsulation](#view-encapsulation).
</div>

### :host and :host()

Use the [:host][] pseudo-class selector to target styles in the element that *hosts* the component (as opposed to
targeting elements *inside* the component's template).

<?code-excerpt "lib/src/hero_details_component.css (host)" title?>
```
  :host {
    display: block;
    border: 1px solid black;
  }
```

The `:host` selector is the only way to target the host element. You can't reach
the host element from inside the component with other selectors because it's not part of the
component's own template. The host element is in a parent component's template.

Use the *function form* [:host()][] to apply host styles conditionally by
including another selector inside parentheses after `:host`.

The next example targets the host element again, but only when it also has the `active` CSS class.

<?code-excerpt "lib/src/hero_details_component.css (host function)" title?>
```
  :host(.active) {
    border-width: 3px;
  }
```

### :host-context()

Sometimes it's useful to apply styles based on some condition *outside* of a component's view.
For example, a CSS theme class could be applied to the document `<body>` element, and
you want to change how your component looks based on that.

Use the [:host-context()][] pseudo-class selector, which works just like the function
form of `:host()`. The `:host-context()` selector looks for a CSS class in any ancestor of the component host element,
up to the document root. The `:host-context()` selector is useful when combined with another selector.

The following example applies a `background-color` style to all `<h2>` elements *inside* the component, only
if some ancestor element has the CSS class `theme-light`.

<?code-excerpt "lib/src/hero_details_component.css (host-context)" title?>
```
  :host-context(.theme-light) h2 {
    background-color: #eef;
  }
```

### ::ng-deep

Component styles normally apply only to the HTML in the component's own template.

Use the `::ng-deep` selector to force a style down through the child component tree into all the child component views.
The `::ng-deep` selector works to any depth of nested components, and it applies to both the view
children and content children of the component.

The following example targets all `<h3>` elements, from the host element down
through this component to all of its child elements in the DOM.

<?code-excerpt "lib/src/hero_details_component.css (deep)" title?>
```
  :host ::ng-deep h3 {
    font-style: italic;
  }
```

<a id="loading-styles"></a>
## Loading styles into components

There are several ways to add styles to a component:

* By setting `styles` or `styleUrls` metadata.
* Inline in the template HTML.
* With CSS imports.

The scoping rules outlined earlier apply to each of these loading patterns.

### Styles in metadata

You can add a `styles` list property to the `@Component` annotation.
Each string in the list (usually just one string) defines the CSS.

<?code-excerpt "lib/app_component.dart (class)" replace="/styles/[!$&!]/g" title?>
```
  @Component(
    selector: 'hero-app',
    template: '''
      <h1>Tour of Heroes</h1>
      <hero-app-main [hero]="hero"></hero-app-main>
    ''',
    [!styles!]: ['h1 { font-weight: normal; }'],
    directives: [HeroAppMainComponent],
  )
  class AppComponent {
    // ···
  }
```

### Style URLs in metadata

You can load styles from external CSS files by adding a `styleUrls` attribute
into a component's `@Component` annotation:

<?code-excerpt "lib/src/hero_details_component.dart (styleUrls)" title?>
```
  @Component(
      selector: 'hero-details',
      template: '''
        <h2>{!{hero.name}!}</h2>
        <hero-team [hero]="hero"></hero-team>
        <ng-content></ng-content>''',
      styleUrls: ['hero_details_component.css'],
      directives: [HeroTeamComponent])
  class HeroDetailsComponent {
    // ···
  }
```

Note that the URLs in `styleUrls` are relative to the component.

### CSS @imports

You can also import CSS files into the CSS files using the standard CSS `@import` rule.
For details, see [`@import`](https://developer.mozilla.org/en/docs/Web/CSS/@import)
on the [MDN](https://developer.mozilla.org) site.

In *this* case the URL is relative to the CSS file into which we are importing.

<?code-excerpt "lib/src/hero_details_component.css (excerpt)" region="import" title?>
```
  @import 'hero_details_box.css';
```

<a id="view-encapsulation"></a>
## Controlling view encapsulation

By default, component styles are _encapsulated_, affecting only the HTML in the
component's template. You can use the [special selectors](#special-selectors)
to reach outside of the component's view, or you can disable view encapsulation
completely for the component.

Disabling view encapsulation makes the component's styles global.
To do this, set the component's metadata [encapsulation][] parameter to
`ViewEncapsulation.None`:

<?code-excerpt "lib/src/quest_summary_component.dart (ViewEncapsulation)" replace="/Emulated/None/g"?>
```
  @Component(
    // ···
    encapsulation: ViewEncapsulation.None,
  )
```

The [ViewEncapsulation][] enum can have two values:

* `Emulated` (the default): Angular emulates the behavior of shadow DOM by preprocessing
  (and renaming) the CSS to effectively scope the CSS to the component's view.
  For details, see [Appendix 1](#inspect-generated-css).
* `None`: Angular does no view encapsulation. Instead it makes the component's styles global.
  The scoping rules, isolations, and protections discussed earlier don't apply.
  This is essentially the same as pasting the component's styles into the HTML.

<a id="inspect-generated-css"></a>
## Appendix 1: Inspecting view encapsulated styles

When using emulated view encapsulation, Angular preprocesses
all component styles so that they approximate the standard shadow CSS scoping rules.

In the DOM of a running Angular app with emulated view
encapsulation enabled, each DOM element has some extra classes
attached to it:

{% prettify html %}
<hero-details class="_nghost-pmm-5">
  <h2 class="_ngcontent-pmm-5">Mister Fantastic</h2>
  <hero-team class="_ngcontent-pmm-5 _nghost-pmm-6">
    <h3 class="_ngcontent-pmm-6">Team</h3>
  </hero-team>
</hero-detail>
{% endprettify %}

There are two kinds of generated classes:

* An element that would be a shadow DOM host has a
  generated `_nghost` class. This is typically the case for component host elements.
* An element within a component's view has a `_ngcontent` class
  that identifies to which host's emulated shadow DOM this element belongs.

The exact values of these classes aren't important. They are automatically
generated and you never refer to them in app code. But they are targeted
by the generated component styles, which are in the `<head>` section of the DOM:

{% prettify css %}
._nghost-pmm-5 {
  display: block;
  border: 1px solid black;
}

h3._ngcontent-pmm-6 {
  background-color: white;
  border: 1px solid #777;
}
{% endprettify %}

These styles are post-processed so that each selector is augmented
with `_nghost` or `_ngcontent` class selectors.
These extra selectors enable the scoping rules described in this page.

<div id="relative-urls"></div>
## Appendix 2: Loading styles with relative URLs

It's common practice to split a component's code, HTML, and CSS into three separate files in the same directory:

  - `quest_summary_component.dart`
  - `quest_summary_component.html`
  - `quest_summary_component.css`

You include the template and CSS files by setting the `templateUrl` and `styleUrls` metadata properties respectively.
Because these files are co-located with the component,
it would be nice to refer to them by name without also having to specify a path back to the root of the app.

Thankfully, this is the default interpretation of relative URLs in AngularDart:

<?code-excerpt "lib/src/quest_summary_component.dart (urls)"?>
```
  templateUrl: 'quest_summary_component.html',
  styleUrls: ['quest_summary_component.css'],
```

[CSS Scoping Module Level 1]: https://www.w3.org/TR/css-scoping-1
[encapsulation]: /api/angular/angular/Component/encapsulation
[ViewEncapsulation]: /api/angular/angular/ViewEncapsulation-class
[W3C]: https://www.w3.org
[:host]: https://developer.mozilla.org/en-US/docs/Web/CSS/:host
[:host()]: https://developer.mozilla.org/en-US/docs/Web/CSS/:host()
[:host-context()]: https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context()
