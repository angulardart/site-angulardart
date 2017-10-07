<div class="callout is-important" markdown="1">
  <header>Which location strategy to use</header>
  In production you can use [ROUTER_PROVIDERS][]
  without the [LocationStrategy][] override.
  During development it is more convenient to use
  [HashLocationStrategy][]
  because `pub serve` does not support [deep linking.][deep linking]
  The only difference between these
  two service lists is the kind of [LocationStrategy][] that
  they support ([PathLocationStrategy][] by default).
</div>

[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[HashLocationStrategy]: /api/angular_router/angular_router/HashLocationStrategy-class
[LocationStrategy]: /api/angular_router/angular_router/LocationStrategy-class
[PathLocationStrategy]: /api/angular_router/angular_router/PathLocationStrategy-class
