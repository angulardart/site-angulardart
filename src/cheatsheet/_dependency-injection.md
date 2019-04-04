<table id="dependency-injection">

<tr>
  <th>Dependency injection configuration</th>
  <th markdown="1">
  `import 'package:angular/angular.dart';`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>Provider</b>(MyService, <b>useClass</b>: MyMockService)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyService` to the `MyMockService` class.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function]({{site.api}}/angular/angular/provide),
  [Provider class]({{site.api}}/angular/angular/Provider-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>Provider</b>(MyService, <b>useFactory</b>: myFactory)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyService` to the `myFactory` factory function.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function]({{site.api}}/angular/angular/provide),
  [Provider class]({{site.api}}/angular/angular/Provider-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>Provider</b>(MyValue, <b>useValue</b>: 42)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyValue` to the value `42`.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function]({{site.api}}/angular/angular/provide),
  [Provider class]({{site.api}}/angular/angular/Provider-class)
  </td>
</tr>

</table>
