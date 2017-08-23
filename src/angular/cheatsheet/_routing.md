<table id="routing">

<tr>
  <th>Routing and navigation</th>
  <th markdown="1">
  `import 'package:angular2/router.dart';`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@RouteConfig</b>(const [<br>
      &nbsp;&nbsp;const Route(<br>
      &nbsp;&nbsp;&nbsp;&nbsp;path: '/:myParam',<br>
      &nbsp;&nbsp;&nbsp;&nbsp;component: MyComponent,<br>
      &nbsp;&nbsp;&nbsp;&nbsp;name: 'MyCmp' ),<br>
    ])
  </code></td>
  <td markdown="1">
  Configures routes for the decorated component. Supports static, parameterized, and wildcard routes.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouteConfig class](/api/angular2/angular2.router/RouteConfig-class),
  [Route class](/api/angular2/angular2.router/Route-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;<b>router-outlet</b>>&lt;/router-outlet>
  </code></td>
  <td markdown="1">
  Marks the location to load the component of the active route.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouterOutlet class](/api/angular2/angular2.router/RouterOutlet-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;a <b>[routerLink]</b>="['/MyCmp', {myParam: 'value'}]">
  </code></td>
  <td markdown="1">
  Creates a link to a different view based on a route instruction consisting of a route name and optional parameters. To navigate to a root route, use the `/` prefix; for a child route, use the `./`prefix.

  See:
  [Tutorial: Routing](/angular/tutorial/toh-pt5),
  [RouterLink class](/api/angular2/angular2.router/RouterLink-class)
  </td>
</tr>

<!--
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
-->

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnActivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  After navigating to a component, the router calls the component's `routerOnActivate` method (if defined).

  See: [OnActivate class](/api/angular2/angular2.router/OnActivate-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerCanReuse</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls a component's `routerCanReuse` method (if defined) to determine whether to reuse the instance or destroy it and create a new instance. Should return a boolean or a future.

  See: [CanReuse class](/api/angular2/angular2.router/CanReuse-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnReuse</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls the component's `routerOnReuse` method (if defined) when it reuses a component instance.

  See: [OnReuse class](/api/angular2/angular2.router/OnReuse-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerCanDeactivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  The router calls the `routerCanDeactivate` methods (if defined) of every component that would be removed after a navigation. The navigation proceeds if and only if all such methods return true or a future that completes successfully.

  See: [CanDeactivate class](/api/angular2/angular2.router/CanDeactivate-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>routerOnDeactivate</b>(nextInstruction, prevInstruction) { ... }
  </code></td>
  <td markdown="1">
  Called before the directive is removed as the result of a route change. May return a future that pauses removing the directive until the future completes.

  See: [OnDeactivate class](/api/angular2/angular2.router/OnDeactivate-class)
  </td>
</tr>

</table>
