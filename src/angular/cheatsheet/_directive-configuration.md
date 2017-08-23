<table id="directive-configuration">

<tr>
  <th>Directive configuration</th>
  <th markdown="1">
    `@Directive(property1: value1, ...)`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>selector:</b> '.cool-button:not(a)'
  </code></td>
  <td markdown="1">
  Specifies a CSS selector that identifies this directive within a template. Supported selectors include `element`, `[attribute]`, `.class`, and `:not()`.

  Does not support parent-child relationship selectors.

  See: [Structural Directives](/angular/guide/structural-directives),
  [selector property](/api/angular2/angular2.core/Directive/selector)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>providers:</b> const [MyService, const Provider(...)]
  </code></td>
  <td markdown="1">
  List of dependency injection providers for this directive and its children.

  See:
  [Attribute Directives](/angular/guide/attribute-directives),
  [Structural Directives](/angular/guide/structural-directives),
  [providers property](/api/angular2/angular2.core/Directive/providers)
  </td>
</tr>

</table>
