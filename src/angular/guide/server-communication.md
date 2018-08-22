---
title: HTTP Client
description: Use HTTP to talk to a remote server.
sideNavGroup: advanced
prevpage:
  title: Hierarchical Dependency Injectors
  url: /angular/guide/hierarchical-dependency-injection
nextpage:
  title: Lifecycle Hooks
  url: /angular/guide/lifecycle-hooks
---
<?code-excerpt path-base="examples/ng/doc/server-communication"?>

Most frontend apps communicate with backend services
using the HTTP protocol.
Dart web apps typically do this using the XMLHttpRequest (XHR) API,
using either [HttpRequest][] from the [dart:html][] library
or a higher level API, such as what the [http package][http] provides.

The following demos, which use the http package,
illustrate server communication:

- [HTTP client demo: Tour of Heroes](#http-client).
- [Cross-origin requests: Wikipedia example](#cors).

Try the {% example_ref %}, which hosts both demos.

## Providing HTTP services  {#http-providers}

The demos in this page use the http package's [Client][] interface.
The following code registers a [factory provider][]
(which creates a [BrowserClient][] instance) for `Client`:

<?code-excerpt "web/main_1.dart" replace="/_1//g" title?>
```
  import 'package:angular/angular.dart';
  import 'package:http/browser_client.dart';
  import 'package:http/http.dart';
  import 'package:server_communication/app_component.template.dart' as ng;

  import 'main.template.dart' as self;

  @GenerateInjector([
    ClassProvider(Client, useClass: BrowserClient),
  ])
  final InjectorFactory injector = self.injector$Injector;

  void main() {
    runApp(ng.AppComponentNgFactory, createInjector: injector);
  }
```

<div id="http-client"></div>
## HTTP client demo: Tour of Heroes

This demo is a shorter version of the [Tour of Heroes](/angular/tutorial) app.
It receives heroes from a server and displays them as a list.
The user can add new heroes and save them to the server.

Here's what the app's UI looks like:

<img class="image-display" src="{% asset ng/devguide/server-communication/http-toh.gif @path %}" alt="ToH mini app" width="282">

This demo has a single component, the `HeroListComponent`. Here is its template:

<?code-excerpt "lib/src/toh/hero_list_component.html" title?>
```
  <h1>Tour of Heroes</h1>
  <h3>Heroes:</h3>
  <ul>
    <li *ngFor="let hero of heroes">{!{hero.name}!}</li>
  </ul>

  <label>New hero name: <input #newHeroName /></label>
  <button (click)="add(newHeroName.value); newHeroName.value=''">Add Hero</button>

  <p class="error" *ngIf="errorMessage != null">{!{errorMessage}!}</p>
```

The template's `ngFor` directive displays the list of heroes.
Below the list are an input box and an *Add Hero* button,
which allow the user to add new heroes.

A [template reference variable](template-syntax#ref-vars), `newHeroName`,
gives the `(click)` event binding access to the value of the input box. When the
user clicks the button, the click handler passes the input value to
the `addHero()` method of the component. The click handler also clears the
input box.

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

    @override
    void ngOnInit() => _getHeroes();

    Future<void> _getHeroes() async {
      try {
        heroes = await _heroService.getAll();
      } catch (e) {
        errorMessage = e.toString();
      }
    }

    Future<void> add(String name) async {
      name = name.trim();
      if (name.isEmpty) return null;
      try {
        heroes.add(await _heroService.create(name));
      } catch (e) {
        errorMessage = e.toString();
      }
    }
  }
```

Angular injects a `HeroService` into the constructor,
and the component calls that service to fetch and save data.

The component doesn't interact directly with the `Client`.
Instead, it delegates data access to the `HeroService`.

<div class="alert alert-warning" markdown="1">
**Always delegate data access to a supporting service class.**
</div>

Although _at runtime_ the component requests heroes immediately after creation,
this request is **not** in the component's constructor.
Instead, the request is in the `ngOnInit` [lifecycle hook](lifecycle-hooks).

<div class="alert alert-info" markdown="1">
  **Keep constructors simple.**
  Components are easier to test and debug when
  their constructors are simple, with all real work (such as
  calling a remote server) handled by a separate method.
</div>

The asynchronous methods in the hero service, `getAll()` and `create()`,
return the [Future][] values of the current hero list and the newly added
hero, respectively. The methods in the hero list component, `_getHeroes()` and
`add()`, specify the actions to be taken when the asynchronous method
calls succeed or fail.

For more information about `Future`, see the
[futures tutorial]({{site.dartlang}}/tutorials/language/futures)
and the resources at the end of that tutorial.


<div id="HeroService"></div>
## Fetching data {#fetch-data}

In the previous samples, the app faked interaction with the server by
returning mock heroes in a service:

<?code-excerpt "../toh-4/lib/src/hero_service.dart" plaster="none"?>
```
  import 'dart:async';

  import 'hero.dart';
  import 'mock_heroes.dart';

  class HeroService {
    Future<List<Hero>> getAll() async => mockHeroes;
  }
```

It's time to get real data. The following code makes `HeroService` get
the heroes from the server:

<?code-excerpt "lib/src/toh/hero_service.dart (revised)" region="v1" title?>
```
  import 'dart:async';
  import 'dart:convert';

  import 'package:http/http.dart';

  import 'hero.dart';

  class HeroService {
    static final _headers = {'Content-Type': 'application/json'};
    static const _heroesUrl = 'api/heroes'; // URL to web API
    final Client _http;

    HeroService(this._http);

    Future<List<Hero>> getAll() async {
      try {
        final response = await _http.get(_heroesUrl);
        final heroes = (_extractData(response) as List)
            .map((value) => Hero.fromJson(value))
            .toList();
        return heroes;
      } catch (e) {
        throw _handleError(e);
      }
    }
```

<div id="client-object"></div>
### Use a *Client* object

This demo uses a `Client` object
that's injected into the `HeroService` constructor:

<?code-excerpt "lib/src/toh/hero_service.dart (ctor)"?>
```
  HeroService(this._http);
```

Here's the code that uses the client's `get()` method to fetch data:

<?code-excerpt "lib/src/toh/hero_service.dart (getAll)" region="http-get" title?>
```
  static const _heroesUrl = 'api/heroes'; // URL to web API
  // ···
  Future<List<Hero>> getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractData(response) as List)
          .map((value) => Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }
```

The `get()` method takes a resource URL, which it uses to contact the server
that returns heroes.


<div id="mock-server"></div>
### Mock the server

When no server exists yet or you want to
avoid network reliability issues during testing,
don't use a `BrowserClient` as the `Client` object.
Instead, you can mock the server by using the
[in-memory web API](/angular/tutorial/toh-pt6#simulate-the-web-api),
which is what the {% example_ref %} does.

Alternatively, use a JSON file:

<?code-excerpt "lib/src/toh/hero_service.dart (endpoint-json)"?>
```
  static const _heroesUrl = 'heroes.json'; // URL to JSON file
```

<div id="extract-data"></div>
## Processing the response object

The `getAll()` method uses an `_extractData()` helper method to
map the `_http.get()` response object to heroes:

<?code-excerpt "lib/src/toh/hero_service.dart (excerpt)" region="extract-data" title?>
```
  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];
```

The `response` object doesn't hold the data in a form that
the app can use directly.
To use the response data, you must first decode it.


<div id="parse-to-json"></div>
### Decode JSON

The response data is in JSON string form.
You must deserialize that string into objects, which you can do by calling
the `JSON.decode()` method from the [dart:convert][] library.
For examples of decoding and encoding JSON, see the
[dart:convert section][] of the Dart library tour.

<div class="l-sub-section" markdown="1">
  The decoded JSON doesn't list the heroes.
  Instead, the server wraps JSON results in an object with a `data` property.
  This is conventional web API behavior, driven by
  [security concerns.](https://www.owasp.org/index.php/OWASP_AJAX_Security_Guidelines#Always_return_JSON_with_an_Object_on_the_outside)
</div>

<div class="alert alert-warning" markdown="1">
  **Assume nothing about the server API.**
  Not all servers return an object with a `data` property.
</div>

<div id="no-return-response-object"></div>
### Don't return the response object

Although it's possible for `getAll()` to return the HTTP response,
that's not a good practice. The point of a data service is to hide the server
interaction details from consumers. A component that calls the `HeroService`
only wants the heroes. It is separated from from the code that's responsible
for getting the data, and from the response object.

<div id="error-handling"></div>
### Always handle errors

An important part of dealing with I/O is anticipating errors by preparing to catch them
and do something with them. One way to handle errors is to pass an error message
back to the component for presentation to the user,
but only if the message is something that the user can understand and act upon.

This simple app handles a `getAll()` error as follows:

<?code-excerpt "lib/src/toh/hero_service.dart (excerpt)" region="error-handling" plaster="none" title?>
```
  Future<List<Hero>> getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractData(response) as List)
          .map((value) => Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
```
{%comment%} block error-handling - TODO: describe `_handleError`?
  The `catch()` operator passes the error object from `http` to the `handleError()` method.
  The `handleError` method transforms the error into a developer-friendly message,
  logs it to the console, and returns the message in a new, failed Observable via `Observable.throw`.
{%endcomment%}

<div id="subscribe"></div>
#### _HeroListComponent_ error handling  {#hero-list-component}

In `HeroListComponent`, the call to
`_heroService.getAll()` is in a `try` clause, and the
`errorMessage` variable is conditionally bound in the template.
When an exception occurs,
the `errorMessage` variable is assigned a value as follows:

<?code-excerpt "lib/src/toh/hero_list_component.dart (_getHeroes)" title?>
```
  Future<void> _getHeroes() async {
    try {
      heroes = await _heroService.getAll();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
```

<div class="l-sub-section" markdown="1">
  To create a failure scenario,
  reset the API endpoint to a bad value in `HeroService`.
  Afterward, remember to restore its original value.

</div>

<div id="create"></div><div id="update"></div>
## Sending data to the server  {#post}

So far you've seen how to retrieve data from a remote location using an HTTP service.
The next task is adding the ability to create new heroes and
save them in the backend.

First, the service needs a method that the component can call to create
and save a hero.
For this demo, the method is called `create()` and takes the name of a new hero:

<?code-excerpt "lib/src/toh/hero_service.dart (create-sig)"?>
```
  Future<Hero> create(String name) async {
```

To implement the method, you must know the server's API for creating heroes.
[This sample's data server](/angular/tutorial/toh-pt6#simulate-the-web-api)
follows typical REST guidelines.
It supports a [`POST`](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.5) request
at the same endpoint as `GET` heroes.
The new hero data must be in the body of the request,
structured like a `Hero` entity but without the `id` property.
Here's an example of the body of the request:

```json
{"name": "Windstorm"}
```

The server generates the `id` and returns the JSON representation of the
new hero, including the generated ID. The hero is inside a response object
with its own `data` property.

Now that you know the server's API, here's the implementation of `create()`:

<?code-excerpt "lib/src/toh/hero_service.dart (create)" title?>
```
  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: json.encode({'name': name}));
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
```

### Headers

In the `_headers` object, the `Content-Type` specifies that
the body represents JSON.

### JSON results

As in `_getHeroes()`, the `_extractData()` helper
[extracts the data](#extract-data) from the response.

Back in `HeroListComponent`, the `addHero()` method
waits for the service's asynchronous `create()` method to create a hero.
When `create()` is finished,
`addHero()` puts the new hero in the `heroes` list:

<?code-excerpt "lib/src/toh/hero_list_component.dart (add)" title?>
```
  Future<void> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return null;
    try {
      heroes.add(await _heroService.create(name));
    } catch (e) {
      errorMessage = e.toString();
    }
  }
```

## Cross-origin requests: Wikipedia example  {#cors}

Although making XMLHttpRequests
(often with a helper API, such as `BrowserClient`)
is a common approach to server communication in Dart web apps,
this approach isn't always possible.

For security reasons, web browsers block XHR calls to a remote server whose origin is different from the origin of the web page.
The *origin* is the combination of URI scheme, hostname, and port number.
This is called the [same-origin policy.](https://en.wikipedia.org/wiki/Same-origin_policy)

<div class="l-sub-section" markdown="1">
  Modern browsers allow XHR requests to servers from a different origin if the server supports the
  [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) protocol.
  You can enable user credentials in [request headers](#headers).
</div>

Some servers do not support CORS but do support an older, read-only alternative called [JSONP.](https://en.wikipedia.org/wiki/JSONP)

<div class="l-sub-section" markdown="1">

For more information about JSONP, see
[this Stack Overflow answer.](http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about/2067584#2067584)
</div>

### Search Wikipedia

The following simple search shows suggestions from Wikipedia as the user
types in a text box:

<img class="image-display" src="{% asset ng/devguide/server-communication/wiki-1.gif @path %}" alt="Wikipedia search app (v.1)" width="282">

Wikipedia offers a modern **CORS** API and a legacy **JSONP** search API.

<div class="alert alert-warning" markdown="1">
  This page is under construction.
  For now, see the
  [demo source code]({{site.ghNgEx}}/server-communication/tree/{{site.branch}})
  for an example of using Wikipedia's JSONP API.
</div>

{%comment%}
==============================================================================
==============================================================================
==============================================================================

//- block wikipedia-jsonp+ unused portion from TS
Wikipedia offers a modern `CORS` API and a legacy `JSONP` search API. This example uses the latter.
The Angular `Jsonp` service both extends the `BrowserClient` service for JSONP and restricts you to `GET` requests.
All other HTTP methods throw an error because `JSONP` is a read-only facility.

Wrap the interaction with an Angular data access client service inside a dedicated service. For example, `WikipediaService`.

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart" title linenums?>

The constructor expects Angular to inject its `Jsonp` service, which
is available because `JsonpModule` is in the root `@NgModule` `imports` array
in `app.module.ts`.

#### Search parameters  {#query-parameters}

The [Wikipedia "opensearch" API](https://www.mediawiki.org/wiki/API:Opensearch)
expects four parameters (key/value pairs) to arrive in the request URL's query string.
The keys are `search`, `action`, `format`, and `callback`.
The value of the `search` key is the user-supplied search term in Wikipedia.
The other three are the fixed values "opensearch", "json", and "JSONP_CALLBACK", respectively.

<div class="l-sub-section" markdown="1">
    The `JSONP` technique requires you to pass a callback function name to the server in the query string: `callback=JSONP_CALLBACK`.
    The server uses that name to build a JavaScript wrapper function in its response, which Angular ultimately calls to extract the data.
    </div>

To search for articles with the term, "Angular", construct the query string and call `jsonp` as follows:

<?xcode-excerpt "lib/src/wiki/wikipedia_service_1.dart (query-string)"?>

In more parameterized example, build the query string with the Angular `URLSearchParams` helper:

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart (search parameters)" region="search-parameters" title?>

Call `jsonp` with *two* arguments: the `wikiUrl` and an options object whose `search` property is the `params` object.

<?xcode-excerpt "lib/src/wiki/wikipedia_service.dart (call jsonp)" region="call-jsonp" title?>

`Jsonp` flattens the `params` object into the same query string and sends the request to the server.

#### The WikiComponent  {#wikicomponent}

The abovementioned service can query the Wikipedia API.
The component (template and class) takes user input and displays search results.

<?xcode-excerpt "lib/src/wiki/wiki_component.dart" title linenums?>

The template presents an `<input>` element *search box* to gather search terms from the user,
and calls a `search(term)` method after each `keyup` event.

The component's `search(term)` method delegates to the `WikipediaService`, which returns an
Observable list of string results (`Observable<string[]>`).
Instead of subscribing to the Observable inside the component, as in the `HeroListComponent`,
the app forwards the Observable result to the template (via `items`) where the `async` pipe
in the `ngFor` handles the subscription. For more information, see [async pipes](pipes#async-pipe)
on the [Pipes](pipes) page.

<div class="l-sub-section" markdown="1">
  The [async pipe](pipes#async-pipe) has read-only components, which do not interact with the data.

  `HeroListComponent` can't use the pipe because `addHero()` pushes newly created heroes into the list.
</div>

### A wasteful app  {#wasteful-app}

The Wikipedia search makes multiple calls to the server. This method is
inefficient and potentially expensive on mobile devices with limited data plans.

#### 1. Wait for the user to stop typing

Presently, the code calls the server after every keystroke.
It should only make requests when the user *stops typing*.
Here's how it will work after refactoring:

<img class="image-display" src="{% asset ng/devguide/server-communication/wiki-2.gif @path %}" alt="Wikipedia search app (v.2)" width="250">

#### 2. Search when the search term changes

If a user enters the word *angular* in the search box and pauses for a while, the app issues a search request for *angular*.

If the user deletes the last three letters, *lar*, and re-types *lar* before pausing again.
The search term is still _angular_. Therefore, the app should not make another request.

#### 3. Cope with out-of-order responses

The user enters *angular*, pauses, clears the search box, and enters *http*.
The app issues two search requests, one for *angular* and the other for *http*.

Which response arrives first? It's unpredictable.
When there are multiple requests in-flight, the app should present the responses
in the original request order.
In this example, the app must always display the results for the *http* search
no matter which response arrives first.

<div id="more-observables"></div>
### More fun with Observables

You can make changes to the `WikipediaService` service. However, for a better
user experience, create a copy of the `WikiComponent` and make it smarter
with some Observable operators.

In the following code, `WikiSmartComponent` component is displayed next to the original `WikiComponent`:

<code-tabs>
  <?code-pane "lib/src/wiki/wiki_smart_component.dart" linenums?>
  <?code-pane "lib/src/wiki_component.dart" linenums?>
</code-tabs>

While the templates are virtually identical,
there is more RxJS such as, `debounceTime`, `distinctUntilChanged`, and `switchMap` operators in the new version.
These are imported as [described above](#rxjs-library).

<div id="create-stream"></div>
#### Create a stream of search terms

The `WikiComponent` passes a new search term directly to the `WikipediaService` after every keystroke.

The `WikiSmartComponent` class turns the keystrokes into an Observable _stream of search terms_
with the help of a `Subject`, which is imported from RxJS:

<?xcode-excerpt "lib/src/wiki/wiki_smart_component.dart (import-subject)"?>

The component creates a `searchTermStream` as a subject of type `string`.
The `search()` method adds each new search box value to that stream through the `next()` method of the subject.

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

See the full source code in the {% example_ref %}.

{%endcomment%}

[HttpRequest]: {{site.dart_api}}/stable/dart-html/HttpRequest-class.html
[dart:html]: {{site.dart_api}}/stable/dart-html/dart-html-library.html
[dependency injection]: dependency-injection
[factory provider]: dependency-injection#factory-providers
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[http]: https://pub.dartlang.org/packages/http
[Client]: {{site.api}}/http/latest/http/Client-class.html
[BrowserClient]: {{site.api}}/http/latest/browser_client/BrowserClient-class.html
[dart:convert section]: {{site.dartlang}}/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more
[dart:convert]: {{site.dart_api}}/stable/dart-convert/dart-convert-library.html

