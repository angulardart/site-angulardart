<table id="dependency-injection">

<tr>
  <th>Dependency injection configuration</th>
  <th markdown="1">
  `import 'package:angular2/angular2.dart';`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    const <b>Provider</b>(MyService, <b>useClass</b>: MyMockService)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyService` to the `MyMockService` class.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function](/api/angular2/angular2.core/provide),
  [Provider class](/api/angular2/angular2.core/Provider-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    const <b>Provider</b>(MyService, <b>useFactory</b>: myFactory)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyService` to the `myFactory` factory function.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function](/api/angular2/angular2.core/provide),
  [Provider class](/api/angular2/angular2.core/Provider-class)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    const <b>Provider</b>(MyValue, <b>useValue</b>: 42)
  </code></td>
  <td markdown="1">
  Sets or overrides the provider for `MyValue` to the value `42`.

  See:
  [Dependency Injection](/angular/guide/dependency-injection),
  [provide function](/api/angular2/angular2.core/provide),
  [Provider class](/api/angular2/angular2.core/Provider-class)
  </td>
</tr>

</table>
