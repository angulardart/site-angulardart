<table id="routing">

<tr>
  <th>Routing and navigation</th>
  <th markdown="1">
  `import 'package:angular_router/angular_router.dart';`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    new <b>RouteDefinition</b>(<br>
    &nbsp;&nbsp;path: 'heroes',<br>
    &nbsp;&nbsp;component: HeroesComponentNgFactory,<br>
    )<br>
  </code></td>
  <td markdown="1">
  Basic unit used to configure routes.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouteDefinition class](/api/angular_router/angular_router/RouteDefinition-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;<b>router-outlet</b> [routes]="routes">&lt;/router-outlet>
  </code></td>
  <td markdown="1">
  Reserves a location in the DOM as an outlet for the router.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouterOutlet class](/api/angular_router/angular_router/RouterOutlet-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;a <b>routerLink</b>="/heroes/{!{hero.id}!}">...&lt;/a><br>
    &lt;a <b>[routerLink]</b>="heroesRoute">...&lt;/a>
  </code></td>
  <td markdown="1">
  Creates a link to a different view.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouterLink class](/api/angular_router/angular_router/RouterLink-class)
  </td>
</tr>

<!--

Needs updating for angular_router 2.0.0

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@CanActivate</b>(() => ...)<br>
    class MyComponent() {}
  </code></td>
  <td markdown="1">
  A component decorator defining a function that the router should call first to determine if it should activate this component. Should return a boolean or a future.
  <!-- TODO: link to good resource. >
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnActivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  After navigating to a component, the router calls the component's `routerOnActivate` method (if defined).

  See: [OnActivate class](/api/angular_router/angular_router/OnActivate-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerCanReuse</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls a component's `routerCanReuse` method (if defined) to determine whether to reuse the instance or destroy it and create a new instance. Should return a boolean or a future.

  See: [CanReuse class](/api/angular_router/angular_router/CanReuse-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnReuse</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls the component's `routerOnReuse` method (if defined) when it reuses a component instance.

  See: [OnReuse class](/api/angular_router/angular_router/OnReuse-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>canDeactivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls the `canDeactivate()` methods (if defined) of every component that would be removed after a navigation. The navigation proceeds if and only if all such methods return true or a future that completes successfully.

  See: [CanDeactivate class](/api/angular_router/angular_router/CanDeactivate-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnDeactivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  Called before the directive is removed as the result of a route change. May return a future that pauses removing the directive until the future completes.

  See: [OnDeactivate class](/api/angular_router/angular_router/OnDeactivate-class)
  </td>
</tr>
-->

</table>
