---
layout: angular
title: HTTP Client
description: Use an HTTP Client to talk to a remote server.
sideNavGroup: advanced
prevpage:
  title: Hierarchical Dependency Injectors
  url: /angular/guide/hierarchical-dependency-injection
nextpage:
  title: Lifecycle Hooks
  url: /angular/guide/lifecycle-hooks
---
<!-- FilePath: src/angular/guide/server-communication.md -->
<?code-excerpt path-base="server-communication"?>

[HTTP](https://tools.ietf.org/html/rfc2616) is the primary protocol for browser/server communication.

<div class="l-sub-section" markdown="1">
  The [`WebSocket`](https://tools.ietf.org/html/rfc6455) protocol is another important communication technology;
  it isn't covered in this page.
</div>

Modern browsers support two HTTP-based APIs:
[XMLHttpRequest (XHR)](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) and
[JSONP](https://en.wikipedia.org/wiki/JSONP). A few browsers also support
[Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API).

The Dart [http][] library simplifies application programming with the **XHR** and **JSONP** APIs.

A <live-example>live example</live-example> illustrates these topics.

## Demos

This page describes server communication with the help of the following demos:

- [The Tour of Heroes *HTTP* client demo](#http-client).
- [Cross-Origin Requests: Wikipedia example](#cors).

The root `AppComponent` orchestrates these demos:

<?code-excerpt "lib/app_component.dart" title?>
```
  import 'package:angular2/angular2.dart';

  import 'src/toh/hero_list_component.dart';
  import 'src/wiki/wiki_component.dart';
  import 'src/wiki/wiki_smart_component.dart';

  @Component(
      selector: 'my-app',
      template: '''
        <hero-list></hero-list>
        <my-wiki></my-wiki>
        <my-wiki-smart></my-wiki-smart>
      ''',
      directives: const [
        HeroListComponent,
        WikiComponent,
        WikiSmartComponent
      ])
  class AppComponent {}
```

<div class="l-main-section"></div>
# Providing HTTP services  {#http-providers}

First, configure the application to use server communication facilities.

The Dart `BrowserClient` client communicates with the server using a familiar HTTP request/response protocol.
The `BrowserClient` client is one of a family of services in the Dart [http][] library.

Before you can use the `BrowserClient` client, you need to register it as a service provider with the dependency injection system.

<div class="l-sub-section" markdown="1">
  Read about providers in the [Dependency Injection](dependency-injection.html) page.
</div>

Register providers using the `bootstrap()` method:

<?code-excerpt "web/main.dart (v1)" title?>
```
  import 'package:angular2/angular2.dart';
  import 'package:angular2/platform/browser.dart';

  import 'package:server_communication/app_component.dart';

  void main() {
    bootstrap(AppComponent, [
      provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])
    ]);
  }
```

Actually, it is unnecessary to include `BrowserClient` in the list of providers.
***But*** as is mentioned in the *Angular Dart Transformer* [wiki page][ng2dtri],
the template compiler _generates_ dependency injection code, hence all the
identifiers used in DI have to be collected by the Angular transformer
so that the libraries containing these identifiers can be transformed.

Unless special steps are taken, Dart libraries like `http`
are not transformed. To ensure that the `BrowserClient` identifier is available
for DI, you must add a `resolved_identifiers` parameter to the `angular2`
transformer in `pubspec.yaml`:

[ng2dtri]: https://github.com/dart-lang/angular2/wiki/Transformer#resolved_identifiers

<!--stylePattern = { pnk: /(resolved_identifiers:|Browser.*)/gm, otl: /(- angular2:)|(transformers:)/g };-->
<?code-excerpt "pubspec.yaml (transformers)" title?>
```
  transformers:
  - angular2:
      entry_points: web/main.dart
      resolved_identifiers:
          BrowserClient: 'package:http/browser_client.dart'
          Client: 'package:http/http.dart'
  - dart_to_js_script_rewriter
```

<div id="http-client"></div>
## The Tour of Heroes HTTP client demo

The first demo is a mini-version of the [tutorial](/angular/tutorial)'s "Tour of Heroes" (ToH) application.
This version gets some heroes from the server, displays them in a list, lets the user add new heroes, and saves them to the server.
The app uses the Dart `BrowserClient` client to communicate via **XMLHttpRequest (XHR)**.

It works like this:

<img class="image-display" src="{% asset_path 'ng/devguide/server-communication/http-toh.gif' %}" alt="ToH mini app" width="282">

This demo has a single component, the `HeroListComponent`.  Here's its template:

<?code-excerpt "lib/src/toh/hero_list_component.html" title?>
```
  <h1>Tour of Heroes</h1>
  <h3>Heroes:</h3>
  <ul>
    <li *ngFor="let hero of heroes">{!{hero.name}!}</li>
  </ul>

  <label>New hero name: <input #newHeroName /></label>
  <button (click)="addHero(newHeroName.value); newHeroName.value=''">Add Hero</button>

  <p class="error" *ngIf="errorMessage != null">{!{errorMessage}!}</p>
```

It presents the list of heroes with an `ngFor`.
Below the list is an input box and an *Add Hero* button where you can enter the names of new heroes
and add them to the database.
A [template reference variable](template-syntax.html#ref-vars), `newHeroName`, accesses the
value of the input box in the `(click)` event binding.
When the user clicks the button, that value is passed to the component's `addHero` method and then
the event binding clears it to make it ready for a new hero name.

Below the button is an area for an error message.

<div id="oninit"></div>
<div id="HeroListComponent"></div>
### The *HeroListComponent* class

Here's the component class:

<?code-excerpt "lib/src/toh/hero_list_component.dart (class)" region="component" title?>
```
  class HeroListComponent implements OnInit {
    final HeroService _heroService;
    String errorMessage;
    List<Hero> heroes = [];

    HeroListComponent(this._heroService);

    Future<Null> ngOnInit() => getHeroes();

    Future<Null> getHeroes() async {
      try {
        heroes = await _heroService.getHeroes();
      } catch (e) {
        errorMessage = e.toString();
      }
    }

    Future<Null> addHero(String name) async {
      name = name.trim();
      if (name.isEmpty) return;
      try {
        heroes.add(await _heroService.create(name));
      } catch (e) {
        errorMessage = e.toString();
      }
    }
  }
```

Angular [injects](dependency-injection.html) a `HeroService` into the constructor
and the component calls that service to fetch and save data.

The component **does not talk directly to the Dart `BrowserClient` client**.
The component doesn't know or care how it gets the data.
It delegates to the `HeroService`.

This is a golden rule: **always delegate data access to a supporting service class**.

Although _at runtime_ the component requests heroes immediately after creation,
you **don't** call the service's `get` method in the component's constructor.
Instead, call it inside the `ngOnInit` [lifecycle hook](lifecycle-hooks.html)
and rely on Angular to call `ngOnInit` when it instantiates this component.

<div class="l-sub-section" markdown="1">
  This is a *best practice*.
  Components are easier to test and debug when their constructors are simple, and all real work
  (especially calling a remote server) is handled in a separate method.
</div>

The hero service `getHeroes()` and `create()` asynchronous methods return the
[`Future`](https://api.dartlang.org/stable/dart-async/Future-class.html)
values of the current hero list and the newly added hero,
respectively. The hero list component `getHeroes()` and `addHero()` methods specify
the actions to be taken when the asynchronous method calls succeed or fail.

For more information about `Future`s, consult any one
of the [articles]({{site.dartlang}}/articles) on asynchronous
programming in Dart, or the tutorial on
[_Asynchronous Programming: Futures_]({{site.dartlang}}/tutorials/language/futures).

With a basic understanding of the component, you're ready to look inside the `HeroService`.

<div id="HeroService"></div>
## Fetch data with _http.get()_  {#fetch-data}

In many of the previous samples the app faked the interaction with the server by
returning mock heroes in a service like this one:

<?code-excerpt "../toh-4/lib/src/hero_service.dart"?>
```
  import 'dart:async';

  import 'package:angular2/angular2.dart';

  import 'hero.dart';
  import 'mock_heroes.dart';

  @Injectable()
  class HeroService {
    Future<List<Hero>> getHeroes() async => mockHeroes;
  }
```

You can revise that `HeroService` to get the heroes from the server using the Dart `BrowserClient` client service:

<?code-excerpt "lib/src/toh/hero_service.dart (revised)" region="v1" title?>
```
  import 'dart:async';
  import 'dart:convert';

  import 'package:angular2/angular2.dart';
  import 'package:http/http.dart';

  import 'hero.dart';

  @Injectable()
  class HeroService {
    static final _headers = {'Content-Type': 'application/json'};
    static const _heroesUrl = 'api/heroes'; // URL to web API
    final Client _http;

    HeroService(this._http);

    Future<List<Hero>> getHeroes() async {
      try {
        final response = await _http.get(_heroesUrl);
        final heroes = _extractData(response)
            .map((value) => new Hero.fromJson(value))
            .toList();
        return heroes;
      } catch (e) {
        throw _handleError(e);
      }
    }

    Future<Hero> create(String name) async {
      try {
        final response = await _http.post(_heroesUrl,
            headers: _headers, body: JSON.encode({'name': name}));
        return new Hero.fromJson(_extractData(response));
      } catch (e) {
        throw _handleError(e);
      }
    }
```

Notice that the Dart `BrowserClient` client service is
[injected](dependency-injection.html) into the `HeroService` constructor.

<?code-excerpt "lib/src/toh/hero_service.dart (ctor)"?>
```
  HeroService(this._http);
```

Look closely at how to call `_http.get`:

<?code-excerpt "lib/src/toh/hero_service.dart (getHeroes)" region="http-get" title?>
```
  static const _heroesUrl = 'api/heroes'; // URL to web API
  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response)
          .map((value) => new Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }
```

You pass the resource URL to `get` and it calls the server which returns heroes.

<div class="l-sub-section" markdown="1">
  The server returns heroes once you've set up the
  [in-memory web api](/angular/tutorial/toh-pt6#simulate-the-web-api)
  described in the [tutorial](/angular/tutorial).
  Alternatively, you can temporarily target a JSON file by changing the endpoint URL:

<?code-excerpt "lib/src/toh/hero_service.dart (endpoint-json)"?>
```
  static const _heroesUrl = 'heroes.json'; // URL to JSON file
```
</div>

<div id="extract-data"></div>
## Process the response object

Remember that the `getHeroes()` method used an `_extractData()` helper method to map the `_http.get` response object to heroes:

<?code-excerpt "lib/src/toh/hero_service.dart (excerpt)" region="extract-data" title?>
```
  dynamic _extractData(Response resp) => JSON.decode(resp.body)['data'];
```

The `response` object doesn't hold the data in a form the app can use directly.
You must parse the response data into a JSON object.

### Parse to JSON

The response data are in JSON string form.
You must parse that string into objects, which you do by calling
the `JSON.decode()` method from the `dart:convert` library.

<div class="l-sub-section" markdown="1">
  Don't expect the decoded JSON to be the heroes list directly.
  This server always wraps JSON results in an object with a `data`
  property. You have to unwrap it to get the heroes.
  This is conventional web API behavior, driven by
  [security concerns](https://www.owasp.org/index.php/OWASP_AJAX_Security_Guidelines#Always_return_JSON_with_an_Object_on_the_outside).
</div>

<div class="alert is-important" markdown="1">
   Make no assumptions about the server API.
   Not all servers return an object with a `data` property.
</div>

<div id="no-return-response-object"></div>
### Do not return the response object

The `getHeroes()` method _could_ have returned the HTTP response but this wouldn't
follow best practices.
The point of a data service is to hide the server interaction details from consumers.
The component that calls the `HeroService` only wants heroes and is kept separate
from getting them, the code dealing with where they come from, and the response object.

<div id="error-handling"></div>
### Always handle errors

An important part of dealing with I/O is anticipating errors by preparing to catch them
and do something with them. One way to handle errors is to pass an error message
back to the component for presentation to the user,
but only if it says something that the user can understand and act upon.

This simple app conveys that idea, albeit imperfectly, in the way it handles a `getHeroes` error.

<?code-excerpt "lib/src/toh/hero_service.dart (excerpt)" region="error-handling" title?>
```
  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response)
          .map((value) => new Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return new Exception('Server error; cause: $e');
  }
```
{%comment%} block error-handling - TODO: describe `_handleError`?
  The `catch()` operator passes the error object from `http` to the `handleError()` method.
  The `handleError` method transforms the error into a developer-friendly message,
  logs it to the console, and returns the message in a new, failed Observable via `Observable.throw`.
{%endcomment%}

<div id="subscribe"></div>
### _HeroListComponent_ error handling  {#hero-list-component}

Back in the `HeroListComponent`, you wrapped the call to
`_heroService.getHeroes()` in a `try` clause. When an exception is
caught, the `errorMessage` variable &mdash; which you've bound conditionally in the
template &mdash; gets assigned to.

<?code-excerpt "lib/src/toh/hero_list_component.dart (getHeroes)" title?>
```
  Future<Null> getHeroes() async {
    try {
      heroes = await _heroService.getHeroes();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
```

<div class="l-sub-section" markdown="1">
  Want to see it fail? In the `HeroService`, reset the api endpoint to a bad value. Afterward, remember to restore it.

</div>

<div id="create"></div><div id="update"></div>
## Send data to the server  {#post}

So far you've seen how to retrieve data from a remote location using an HTTP service.
Now you'll add the ability to create new heroes and save them in the backend.

You'll write a method for the `HeroListComponent` to call, a `create()` method, that takes
just the name of a new hero. It begins like this:

<?code-excerpt "lib/src/toh/hero_service.dart (create-sig)"?>
```
  Future<Hero> create(String name) async {
```

To implement it, you must know the server's API for creating heroes.
[This sample's data server](/angular/tutorial/toh-pt6#simulate-the-web-api) follows typical REST guidelines.
It expects a [`POST`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.5) request
at the same endpoint as `GET` heroes.
It expects the new hero data to arrive in the body of the request,
structured like a `Hero` entity but without the `id` property.
The body of the request should look like this:

<?code-excerpt?>
```javascript
  { "name": "Windstorm" }
```

The server generates the `id` and returns the entire `JSON` representation
of the new hero including its generated id. The hero arrives tucked inside a response object
with its own `data` property.

Now that you know how the API works, implement `create()` as follows:

<?code-excerpt "lib/src/toh/hero_service.dart (create)" title?>
```
  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: JSON.encode({'name': name}));
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
```

### Headers

In the `headers` object, the `Content-Type` specifies that the body represents JSON.

### JSON results

As with `getHeroes()`, use the `_extractData()` helper to [extract the data](#extract-data)
from the response.

Back in the `HeroListComponent`, the `addHero()` method waits for the service's
asynchronous `create()` method to create a hero. When `create()` is finished,
`addHero()` puts the new hero in the `heroes` list for presentation to the user.

<?code-excerpt "lib/src/toh/hero_list_component.dart (addHero)" title?>
```
  Future<Null> addHero(String name) async {
    name = name.trim();
    if (name.isEmpty) return;
    try {
      heroes.add(await _heroService.create(name));
    } catch (e) {
      errorMessage = e.toString();
    }
  }
```

## Cross-Origin Requests: Wikipedia example  {#cors}

You just learned how to make `XMLHttpRequests` using the Dart `BrowserClient` service.
This is the most common approach to server communication, but it doesn't work in all scenarios.

For security reasons, web browsers block `XHR` calls to a remote server whose origin is different from the origin of the web page.
The *origin* is the combination of URI scheme, hostname, and port number.
This is called the [same-origin policy](https://en.wikipedia.org/wiki/Same-origin_policy).

<div class="l-sub-section" markdown="1">
  Modern browsers do allow `XHR` requests to servers from a different origin if the server supports the
  [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) protocol.
  If the server requires user credentials, enable them in the [request headers](#headers).
</div>

Some servers do not support CORS but do support an older, read-only alternative called [JSONP](https://en.wikipedia.org/wiki/JSONP).
Wikipedia is one such server.

<div class="l-sub-section" markdown="1">
  This [Stack Overflow answer](http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about/2067584#2067584) covers many details of JSONP.
</div>

### Search Wikipedia

Here is a simple search that shows suggestions from Wikipedia as the user
types in a text box:

<img class="image-display" src="{% asset_path 'ng/devguide/server-communication/wiki-1.gif' %}" alt="Wikipedia search app (v.1)" width="282">

Wikipedia offers a modern `CORS` API and a legacy `JSONP` search API.

<div class="alert is-important" markdown="1">
  The remaining content of this section is coming soon.
  In the meantime, consult the
  [example sources](https://github.com/angular-examples/server-communication)
  to see how to access Wikipedia via its `JSONP` API.
</div>

{%comment%}
==============================================================================
==============================================================================
==============================================================================

//- block wikipedia-jsonp+ unused portion from TS
Wikipedia offers a modern `CORS` API and a legacy `JSONP` search API. This example uses the latter.
The Angular `Jsonp` service both extends the `BrowserClient` service for JSONP and restricts you to `GET` requests.
All other HTTP methods throw an error because `JSONP` is a read-only facility.

As always, wrap the interaction with an Angular data access client service inside a dedicated service, here called `WikipediaService`.

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart" title linenums?>

The constructor expects Angular to inject its `Jsonp` service, which
is available because `JsonpModule` is in the root `@NgModule` `imports` array
in `app.module.ts`.

### Search parameters  {#query-parameters}

The [Wikipedia "opensearch" API](https://www.mediawiki.org/wiki/API:Opensearch)
expects four parameters (key/value pairs) to arrive in the request URL's query string.
The keys are `search`, `action`, `format`, and `callback`.
The value of the `search` key is the user-supplied search term to find in Wikipedia.
The other three are the fixed values "opensearch", "json", and "JSONP_CALLBACK" respectively.

<div class="l-sub-section" markdown="1">
    The `JSONP` technique requires that you pass a callback function name to the server in the query string: `callback=JSONP_CALLBACK`.
    The server uses that name to build a JavaScript wrapper function in its response, which Angular ultimately calls to extract the data.
    All of this happens under the hood.
</div>

If you're looking for articles with the word "Angular", you could construct the query string by hand and call `jsonp` like this:

<?xcode-excerpt "lib/src/wiki/wikipedia_service_1.dart (query-string)"?>

In more parameterized examples you could build the query string with the Angular `URLSearchParams` helper:

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart (search parameters)" region="search-parameters" title?>

This time you call `jsonp` with *two* arguments: the `wikiUrl` and an options object whose `search` property is the `params` object.

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart (call jsonp)" region="call-jsonp" title?>

`Jsonp` flattens the `params` object into the same query string you saw earlier, sending the request to the server.

### The WikiComponent  {#wikicomponent}

Now that you have a service that can query the Wikipedia API,
turn your attention to the component (template and class) that takes user input and displays search results.

<?xcode-excerpt "lib/src/wiki/wiki_component.dart" title linenums?>

The template presents an `<input>` element *search box* to gather search terms from the user,
and calls a `search(term)` method after each `keyup` event.

The component's `search(term)` method delegates to the `WikipediaService`, which returns an
Observable list of string results (`Observable<string[]>`).
Instead of subscribing to the Observable inside the component, as in the `HeroListComponent`,
the app forwards the Observable result to the template (via `items`) where the `async` pipe
in the `ngFor` handles the subscription. Read more about [async pipes](pipes.html#async-pipe)
in the [Pipes](pipes.html) page.

<div class="l-sub-section" markdown="1">
  The [async pipe](pipes.html#async-pipe) is a good choice in read-only components
  where the component has no need to interact with the data.

  `HeroListComponent` can't use the pipe because `addHero()` pushes newly created heroes into the list.
</div>

## A wasteful app  {#wasteful-app}

The Wikipedia search makes too many calls to the server.
It is inefficient and potentially expensive on mobile devices with limited data plans.

### 1. Wait for the user to stop typing

Presently, the code calls the server after every keystroke.
It should only make requests when the user *stops typing*.
Here's how it will work after refactoring:

<img class="image-display" src="{% asset_path 'ng/devguide/server-communication/wiki-2.gif' %}" alt="Wikipedia search app (v.2)" width="250">

### 2. Search when the search term changes

Suppose a user enters the word *angular* in the search box and pauses for a while.
The application issues a search request for *angular*.

Then the user backspaces over the last three letters, *lar*, and immediately re-types *lar* before pausing once more.
The search term is still _angular_. The app shouldn't make another request.

### 3. Cope with out-of-order responses

The user enters *angular*, pauses, clears the search box, and enters *http*.
The application issues two search requests, one for *angular* and one for *http*.

Which response arrives first? It's unpredictable.
When there are multiple requests in-flight, the app should present the responses
in the original request order.
In this example, the app must always display the results for the *http* search
no matter which response arrives first.

<div id="more-observables"></div>
## More fun with Observables

You could make changes to the `WikipediaService`, but for a better
user experience, create a copy of the `WikiComponent` instead and make it smarter,
with the help of some nifty Observable operators.

Here's the `WikiSmartComponent`, shown next to the original `WikiComponent`:

<code-tabs>
  <?code-pane "lib/src/wiki/wiki_smart_component.dart"?>
  <?code-pane "lib/src/wiki_component.dart"?>
</code-tabs>

While the templates are virtually identical,
there's a lot more RxJS in the "smart" version,
starting with `debounceTime`, `distinctUntilChanged`, and `switchMap` operators,
imported as [described above](#rxjs-library).

<div id="create-stream"></div>
### Create a stream of search terms

The `WikiComponent` passes a new search term directly to the `WikipediaService` after every keystroke.

The `WikiSmartComponent` class turns the user's keystrokes into an Observable _stream of search terms_
with the help of a `Subject`, which you import from RxJS:

<?xcode-excerpt "lib/src/wiki/wiki_smart_component.dart (import-subject)"?>

The component creates a `searchTermStream` as a `Subject` of type `string`.
The `search()` method adds each new search box value to that stream via the subject's `next()` method.

<?xcode-excerpt "lib/src/wiki/wiki_smart_component.dart (subject)"?>

### Listen for search terms

The `WikiSmartComponent` listens to the *stream of search terms* and
processes that stream _before_ calling the service.

<?xcode-excerpt "lib/src/wiki/wiki_smart_component.dart (observable-operators)"?>

* <a href="https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/core/operators/debounce.md" target="_blank" rel="noopener" title="debounce operator"><i>debounceTime</i></a>
waits for the user to stop typing for at least 300 milliseconds.

* <a href="https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/core/operators/distinctuntilchanged.md" target="_blank" rel="noopener" title="distinctUntilChanged operator"><i>distinctUntilChanged</i></a>
ensures that the service is called only when the new search term is different from the previous search term.

* The <a href="https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/core/operators/flatmaplatest.md" target="_blank" rel="noopener" title="switchMap operator"><i>switchMap</i></a>
calls the `WikipediaService` with a fresh, debounced search term and coordinates the stream(s) of service response.

The role of `switchMap` is particularly important.
The `WikipediaService` returns a separate Observable of string arrays (`Observable<string[]>`) for each search request.
The user could issue multiple requests before a slow server has had time to reply,
which means a backlog of response Observables could arrive at the client, at any moment, in any order.

The `switchMap` returns its own Observable that _combines_ all `WikipediaService` response Observables,
re-arranges them in their original request order,
and delivers to subscribers only the most recent search results.

//- Skip Cross-Site Request Forgery section for now.
//- Drop "in-memory web api" appendix since we refer readers to the tutorial.
==============================================================================
==============================================================================
==============================================================================
{%endcomment%}

See the full source code in the <live-example></live-example>.

[http]: https://pub.dartlang.org/packages/http
