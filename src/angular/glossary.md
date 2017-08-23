---
layout: angular
title: Glossary
description: Brief definitions of the most important words in the Angular vocabulary
---
Angular has its own vocabulary.
Most Angular terms are common English words
with a specific meaning within the Angular system.

This glossary lists the most prominent terms
and a few less familiar ones that have unusual or
unexpected definitions.

[A](#A) [B](#B) [C](#C) [D](#D) [E](#E) [F](#F) [G](#G) [H](#H) [I](#I)
[J](#J) [K](#K) [L](#L) [M](#M) [N](#N) [O](#O) [P](#P) [Q](#Q) [R](#R)
[S](#S) [T](#T) [U](#U) [V](#V) [W](#W) [X](#X) [Y](#Y) [Z](#Z)

<div class="l-main-section"><a id="A"></a></div>

<div id="aot"></div>
## Ahead-of-time (AOT) compilation
<div class="l-sub-section" markdown="1">
  You can compile Angular applications at build time.
  By compiling your application, you can bootstrap directly
  to a factory, meaning you don't need to include the Angular compiler in your JavaScript bundle.
  Ahead-of-time compiled applications also benefit from decreased load time and increased performance.
</div>

## Annotation
<div class="l-sub-section" markdown="1">
  When unqualified, _annotation_ refers to a Dart metadata
  annotation (as opposed to, say, a type annotation).  A metadata
  annotation begins with the character `@`, followed by either a reference
  to a compile-time constant (such as [`Component`](#component)) or a call
  to a constant constructor. See the [metadata section][metadata]
  of the Dart language tour for details.

  The corresponding term in TypeScript and JavaScript is
  _decorator_.

  [metadata]: {{site.dartlang}}/guides/language/language-tour#metadata
</div>

## Attribute directive
<div class="l-sub-section" markdown="1">
  A category of [directive](#directive) that can listen to and modify the behavior of
  other HTML elements, attributes, properties, and components. They are usually represented
  as HTML attributes, hence the name.

  For example, you can use the `ngClass` directive to add and remove CSS class names.

  Learn about them in the [_Attribute Directives_](/angular/guide/attribute-directives) guide.
</div>

<div class="l-main-section"><a id="B"></a></div>

## Binding
<div class="l-sub-section" markdown="1">
  Usually refers to [data binding](#data-binding) and the act of
  binding an HTML object property to a data object property.

  Sometimes refers to a [dependency-injection](#dependency-injection) binding
  between a "token"&mdash;also referred to as a "key"&mdash;and a dependency [provider](#provider).
</div>

## Bootstrap
<div class="l-sub-section" markdown="1">
  You launch an Angular application by "bootstrapping" it using the [bootstrap][bootstrap] method.
  Bootstrapping identifies an application's top level "root" [component](#component),
  which is the first component that is loaded for the application.
  Bootstrapping optionally registers service [providers](#provider) with the
  [dependency injection system](#dependency-injection).
  For more information, see the [Setup](/angular/guide/setup) page.

  You can bootstrap multiple apps in the same `index.html`, each app with its own top-level root.

  [bootstrap]: /api/angular2/angular2.platform.browser/bootstrap.html
</div>

<div class="l-main-section"><a id="C"></a></div>

## camelCase
<div class="l-sub-section" markdown="1">
  The practice of writing compound words or phrases such that each word or abbreviation begins with a capital letter
  _except the first letter, which is lowercase_.

  Function, property, and method names are typically spelled in camelCase. For example, `square`, `firstName`, and `getHeroes`. Notice that `square` is an example of how you write a single word in camelCase.

  camelCase is also known as *lower camel case* to distinguish it from *upper camel case*, or [PascalCase](#pascalcase).
  In Angular documentation, "camelCase" always means *lower camel case*.
</div>

## Component
<div class="l-sub-section" markdown="1">
  An Angular class responsible for exposing data to a [view](#view) and handling most of the view’s display and user-interaction logic.

  The *component* is one of the most important building blocks in the Angular system.
  It is, in fact, an Angular [directive](#directive) with a companion [template](#template).

  Apply the `@Component` [annotation](#annotation) to
  the component class, thereby attaching to the class the essential component metadata
  that Angular needs to create a component instance and render the component with its template
  as a view.

  Those familiar with "MVC" and "MVVM" patterns will recognize
  the component in the role of "controller" or "view model".
</div>

<div class="l-main-section"><a id="D"></a></div>

## dash-case
<div class="l-sub-section" markdown="1">
  The practice of writing compound words or phrases such that each word is separated by a dash or hyphen (`-`).
  This form is also known as kebab-case.

  [Directive](#directive) selectors (like `my-app`) are often
  spelled in dash-case.
</div>

## Data binding
<div class="l-sub-section" markdown="1">
  Applications display data values to a user and respond to user
  actions (such as clicks, touches, and keystrokes).

  In data binding, you declare the relationship between an HTML widget and data source
  and let the framework handle the details.
  Data binding is an alternative to manually pushing application data values into HTML, attaching
  event listeners, pulling changed values from the screen, and
  updating application data values.

  Angular has a rich data-binding framework with a variety of data-binding
  operations and supporting declaration syntax.

   Read about the following forms of binding in the [Template Syntax](/angular/guide/template-syntax) page:
   * [Interpolation](/angular/guide/template-syntax#interpolation).
   * [Property binding](/angular/guide/template-syntax#property-binding).
   * [Event binding](/angular/guide/template-syntax#event-binding).
   * [Attribute binding](/angular/guide/template-syntax#attribute-binding).
   * [Class binding](/angular/guide/template-syntax#class-binding).
   * [Style binding](/angular/guide/template-syntax#style-binding).
   * [Two-way data binding with ngModel](/angular/guide/template-syntax#ngModel).
</div>

<div id="decorator"></div>
<div id="decoration"></div>
## Decorator | decoration
<div class="l-sub-section" markdown="1">
  JavaScript terms that, in this documentation, refer to an
  [annotation](#annotation).
</div>

## Dependency injection
<div class="l-sub-section" markdown="1">
  A design pattern and mechanism
  for creating and delivering parts of an application to other
  parts of an application that request them.

  Angular developers prefer to build applications by defining many simple parts
  that each do one thing well and then wiring them together at runtime.

  These parts often rely on other parts. An Angular [component](#component)
  part might rely on a service part to get data or perform a calculation. When
  part "A" relies on another part "B", you say that "A" depends on "B" and
  that "B" is a dependency of "A".

  You can ask a "dependency injection system" to create "A"
  for us and handle all the dependencies.
  If "A" needs "B" and "B" needs "C", the system resolves that chain of dependencies
  and returns a fully prepared instance of "A".

  Angular provides and relies upon its own sophisticated
  dependency-injection system
  to assemble and run applications by "injecting" application parts
  into other application parts where and when needed.

  At the core, an [`injector`](#injector) returns dependency values on request.
  The expression `injector.get(token)` returns the value associated with the given token.

  A token is an Angular type (`OpaqueToken`). You rarely need to work with tokens directly; most
  methods accept a class name (`Foo`) or a string ("foo") and Angular converts it
  to a token. When you write `injector.get(Foo)`, the injector returns
  the value associated with the token for the `Foo` class, typically an instance of `Foo` itself.

  During many of its operations, Angular makes similar requests internally, such as when it creates a [`component`](#component) for display.

  The `Injector` maintains an internal map of tokens to dependency values.
  If the `Injector` can't find a value for a given token, it creates
  a new value using a `Provider` for that token.

  A [provider](#provider) is a recipe for
  creating new instances of a dependency value associated with a particular token.

  An injector can only create a value for a given token if it has
  a `provider` for that token in its internal provider registry.
  Registering providers is a critical preparatory step.

  Angular registers some of its own providers with every injector.
  You can register your own providers.

  Read more in the [Dependency Injection](/angular/guide/dependency-injection) page.
</div>

## Directive
<div class="l-sub-section" markdown="1">
  An Angular class responsible for creating, reshaping, and interacting with HTML elements
  in the browser DOM. The directive is Angular's most fundamental feature.

  A directive is usually associated with an HTML element or attribute.
  This element or attribute is often referred to as the directive itself.

  When Angular finds a directive in an HTML template,
  it creates the matching directive class instance
  and gives the instance control over that portion of the browser DOM.

  You can invent custom HTML markup (for example, `<my-directive>`) to
  associate with your custom directives. You add this custom markup to HTML templates
  as if you were writing native HTML. In this way, directives become extensions of
  HTML itself.

  Directives fall into one of the following categories:

  * [Components](#component) combine application logic with an HTML template to
  render application [views](#view). Components are usually represented as HTML elements.
  They are the building blocks of an Angular application.

  * [Attribute directives](#attribute-directive) can listen to and modify the behavior of
  other HTML elements, attributes, properties, and components. They are usually represented
  as HTML attributes, hence the name.

  * [Structural directives](#structural-directive) are responsible for
  shaping or reshaping HTML layout, typically by adding, removing, or manipulating
  elements and their children.
</div>

<div class="l-main-section"><a id="E"></a></div>

## ECMAScript
<div class="l-sub-section" markdown="1">
  The [official JavaScript language specification](https://en.wikipedia.org/wiki/ECMAScript).
</div>

## ES2015
<div class="l-sub-section" markdown="1">
  Short hand for [ECMAScript](#ecmascript) 2015.
</div>

## ES5
<div class="l-sub-section" markdown="1">
  Short hand for [ECMAScript](#ecmascript) 5, the version of JavaScript run by most modern browsers.
</div>

## ES6
<div class="l-sub-section" markdown="1">
  Short hand for [ECMAScript](#ecmascript) 2015.
</div>

<div class="l-main-section">
  <a id="F"></a>
  <a id="G"></a>
  <a id="H"></a>
  <a id="I"></a>
</div>

## Injector
<div class="l-sub-section" markdown="1">
  An object in the Angular [dependency-injection system](#dependency-injection)
  that can find a named dependency in its cache or create a dependency
  with a registered [provider](#provider).
</div>

## Input
<div class="l-sub-section" markdown="1">
  A directive property that can be the *target* of a
  [property binding](/angular/guide/template-syntax#property-binding) (explained in detail in the [Template Syntax](/angular/guide/template-syntax) page).
  Data values flow *into* this property from the data source identified
  in the template expression to the right of the equal sign.

  See the [Input and output properties](/angular/guide/template-syntax#inputs-outputs) section of the [Template Syntax](/angular/guide/template-syntax) page.
</div>

## Interpolation
<div class="l-sub-section" markdown="1">
  A form of [property data binding](#data-binding) in which a
  [template expression](#template-expression) between double-curly braces
  renders as text.  That text may be concatenated with neighboring text
  before it is assigned to an element property
  or displayed between element tags, as in this example.

  <code-example language="html">&lt;label>My current hero is {!{hero.name}}&lt;/label></code-example>

  Read more about [interpolation](/angular/guide/template-syntax#interpolation) in the
  [Template Syntax](/angular/guide/template-syntax) page.
</div>

<div class="l-main-section"><a id="J"></a></div>

<div id="jit"></div>

## Just-in-time (JIT) compilation
<div class="l-sub-section" markdown="1">
  A bootstrapping method of compiling components in the browser
  and launching the application dynamically. Just-in-time mode is a good choice during development.
  Consider using the [ahead-of-time](#aot) mode for production apps.
</div>

<div class="l-main-section"><a id="K"></a></div>

## kebab-case
<div class="l-sub-section" markdown="1">
  See [dash-case](#dash-case).
</div>

<div class="l-main-section"><a id="L"></a></div>

## Lifecycle hooks
<div class="l-sub-section" markdown="1">
  [Directives](#directive) and [components](#component) have a lifecycle
  managed by Angular as it creates, updates, and destroys them.

  You can tap into key moments in that lifecycle by implementing
  one or more of the lifecycle hook interfaces.

  Each interface has a single hook method whose name is the interface name prefixed with `ng`.
  For example, the `OnInit` interface has a hook method named `ngOnInit`.

  Angular calls these hook methods in the following order:
  * `ngOnChanges`: when an [input](#input)/[output](#output) binding value changes.
  * `ngOnInit`: after the first `ngOnChanges`.
  * `ngDoCheck`: developer's custom change detection.
  * `ngAfterContentInit`: after component content initialized.
  * `ngAfterContentChecked`: after every check of component content.
  * `ngAfterViewInit`: after a component's views are initialized.
  * `ngAfterViewChecked`: after every check of a component's views.
  * `ngOnDestroy`: just before the directive is destroyed.

  Read more in the [Lifecycle Hooks](/angular/guide/lifecycle-hooks) page.
</div>

<div class="l-main-section"><a id="M"></a></div>

## Module
<div class="l-sub-section" markdown="1">
  In this documentation, the term _module_ refers to a Dart compilation unit, such
  as a library or package. If a Dart file has no `library` or `part`
  directive, then that file itself is a library and thus a compilation
  unit. For more information about compilation units, see
  the Libraries and Scripts chapter in the
  [Dart Language Specification.]({{site.dartlang}}/guides/language/spec)
</div>


<div class="l-main-section">
  <a id="N"></a>
  <a id="O"></a>
</div>

## Output
<div class="l-sub-section" markdown="1">
  A directive property that can be the *target* of event binding
  (read more in the [event binding](/angular/guide/template-syntax#event-binding)
  section of the [Template Syntax](/angular/guide/template-syntax) page).
  Events stream *out* of this property to the receiver identified
  in the template expression to the right of the equal sign.

  See the [Input and output properties](/angular/guide/template-syntax#inputs-outputs) section of the [Template Syntax](/angular/guide/template-syntax) page.
</div>

<div class="l-main-section"><a id="P"></a></div>

## PascalCase
<div class="l-sub-section" markdown="1">
  The practice of writing individual words, compound words, or phrases such that each word or abbreviation begins with a capital letter.
  Class names are typically spelled in PascalCase. For example, `Person` and `HeroDetailComponent`.

  This form is also known as *upper camel case* to distinguish it from *lower camel case* or simply [camelCase](#camelcase).
  In this documentation, "PascalCase" means *upper camel case* and  "camelCase" means *lower camel case*.
</div>

## Pipe
<div class="l-sub-section" markdown="1">
  An Angular pipe is a function that transforms input values to output values for
  display in a [view](#view).
  Here's an example that uses the built-in `currency` pipe to display
  a numeric value in the local currency.

  <code-example language="html">&lt;label>Price: &lt;/label>{!{product.price | currency}}</code-example>

  You can also write your own custom pipes.
  Read more in the page on [pipes](/angular/guide/pipes).
</div>

## Provider
<div class="l-sub-section" markdown="1">
  A _provider_ creates a new instance of a dependency for the
  [dependency injection](#dependency-injection) system.
  It relates a lookup token to code&mdash;sometimes called a "recipe"&mdash;that can create a dependency value.
</div>

<div class="l-main-section">
  <a id="Q"></a>
  <a id="R"></a>
</div>

## Router
<div class="l-sub-section" markdown="1">
  Most applications consist of many screens or [views](#view).
  The user navigates among them by clicking links and buttons,
  and performing other similar actions that cause the application to
  replace one view with another.

  The Angular component router is a richly featured mechanism for configuring and managing the entire view navigation process, including the creation and destruction
  of views.
</div>

## Routing component
<div class="l-sub-section" markdown="1">
  An Angular [component](#component) with a `RouterOutlet` that displays views based on router navigations.

  For more information, see the [Routing & Navigation](/angular/guide/router) page.
</div>

<div class="l-main-section"><a id="S"></a></div>

## Service
<div class="l-sub-section" markdown="1">
  For data or logic that is not associated
  with a specific view or that you want to share across components, build services.

  Applications often require services such as a hero data service or a logging service.

  A service is a class with a focused purpose.
  You often create a service to implement features that are
  independent from any specific view,
  provide shared data or logic across components, or encapsulate external interactions.

  Applications often require services such as a data service or a logging service.

  For more information, see the [Services](/angular/tutorial/toh-pt4) page of the [Tour of Heroes](/angular/tutorial) tutorial.
</div>

<div id="snake-case"></div>

## snake_case
<div class="l-sub-section" markdown="1">
  The practice of writing compound words or phrases such that an
  underscore (`_`) separates one word from the next. This form is also known as *underscore case*.

  Dart package names and filenames are spelled in snake_case, [by
  convention.]({{site.dartlang}}/guides/language/effective-dart/style#do-name-libraries-and-source-files-using-lowercasewithunderscores)
  For example, `angular_tour_of_heroes` and `app_component.dart`.
</div>

## Structural directive
<div class="l-sub-section" markdown="1">
  A category of [directive](#directive) that can
  shape or reshape HTML layout, typically by adding and removing elements in the DOM.
  The `ngIf` "conditional element" directive and the `ngFor` "repeater" directive are well-known examples.

  Read more in the [Structural Directives](/angular/guide/structural-directives) page.
</div>

<div class="l-main-section"><a id="T"></a></div>

## Template
<div class="l-sub-section" markdown="1">
  A chunk of HTML that Angular uses to render a [view](#view) with
  the support and guidance of an Angular [directive](#directive),
  most notably a [component](#component).
</div>

## Template expression
<div class="l-sub-section" markdown="1">
  A Dart-like syntax that Angular evaluates within
  a [data binding](#data-binding).

  Read about how to write template expressions
  in the [Template expressions](/angular/guide/template-syntax#template-expressions) section
  of the [Template Syntax](/angular/guide/template-syntax#) page.
</div>

## Transpile
<div class="l-sub-section" markdown="1">
  The process of transforming code written in one language
  (for example, Dart or TypeScript) into another (such as [ES5](#es5)).
</div>

## TypeScript
<div class="l-sub-section" markdown="1">
  A version of JavaScript that supports most [ECMAScript 2015](#es2015)
  language features such as [decorators](#decorator).
  Read more about TypeScript at [typescriptlang.org](https://www.typescriptlang.org/).
</div>

<div class="l-main-section">
  <a id="U"></a>
  <a id="V"></a>
</div>

## View
<div class="l-sub-section" markdown="1">
  A portion of the screen that displays information and responds
  to user actions such as clicks, mouse moves, and keystrokes.

  Angular renders a view under the control of one or more [directives](#directive),
  especially [component](#component) directives and their companion [templates](#template).
  The component plays such a prominent role that it's often
  convenient to refer to a component as a view.

  Views often contain other views. Any view might be loaded and unloaded
  dynamically as the user navigates through the application, typically
  under the control of a [router](#router).
</div>

<div class="l-main-section">
  <a id="W"></a>
  <a id="X"></a>
  <a id="Y"></a>
  <a id="Z"></a>
</div>

## Zone
<div class="l-sub-section" markdown="1">
  Zones are a mechanism for encapsulating and intercepting
  a Dart application's asynchronous activity.

  Read more about zones in [this article][zones].

  [zones]: {{site.dartlang}}/articles/libraries/zones
</div>
