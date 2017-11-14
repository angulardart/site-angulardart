<div class="callout is-important" markdown="1">
  <header>Which location strategy to use</header>
  The default [LocationStrategy][] is [PathLocationStrategy][] so, in
  production, you can use [ROUTER_PROVIDERS][] without the [LocationStrategy][]
  provider override.
  During development, it is more convenient to use [HashLocationStrategy][]
  because `pub serve` does not support [deep linking.][deep linking]
  See the Router Appendix on [LocationStrategy and browser URL styles][appendix]
  for details.
</div>

[appendix]: /angular/guide/router/appendices#browser-url-styles
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[HashLocationStrategy]: /api/angular_router/angular_router/HashLocationStrategy-class
[LocationStrategy]: /api/angular_router/angular_router/LocationStrategy-class
[PathLocationStrategy]: /api/angular_router/angular_router/PathLocationStrategy-class
[ROUTER_PROVIDERS]: /api/angular_router/angular_router/ROUTER_PROVIDERS-constant
