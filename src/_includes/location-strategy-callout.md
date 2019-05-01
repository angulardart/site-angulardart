<div class="alert alert-warning" markdown="1">
  <h4>Which location strategy to use</h4>

  The default [LocationStrategy][] is [PathLocationStrategy][] so, in
  production, you can use [routerProviders][].
  During development, it is more convenient to use [routerProvidersHash]
  (which has a [HashLocationStrategy][] provider override for [LocationStrategy][])
  because [webdev serve][] does not support [deep linking.][deep linking]
  See the Router Appendix on [LocationStrategy and browser URL styles][appendix]
  for details.
</div>

[appendix]: /guide/router/appendices#browser-url-styles
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[HashLocationStrategy]: /api/angular_router/angular_router/HashLocationStrategy-class
[LocationStrategy]: /api/angular_router/angular_router/LocationStrategy-class
[PathLocationStrategy]: /api/angular_router/angular_router/PathLocationStrategy-class
[routerProviders]: /api/angular_router/angular_router/routerProviders-constant
[routerProvidersHash]: /api/angular_router/angular_router/routerProvidersHash-constant
[webdev serve]: /tools/index#webdev
