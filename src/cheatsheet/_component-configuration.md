<table id="component-configuration">

<tr>
  <th>Component configuration</th>
  <th markdown="1">
  `@Component` extends `@Directive`,
  so the `@Directive` configuration applies to components as well
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>viewProviders:</b> [MyService, Provider(...)]
  </code></td>
  <td markdown="1">
  List of dependency injection providers scoped to this component's view.

  See: [viewProviders property]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/di/Component/viewProviders.html)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>template:</b> 'Hello {&#8203;{name}}',<br>
    <b>templateUrl:</b> 'my-component.html'
  </code></td>
  <td markdown="1">
  Inline template or external template URL of the component's view.

  See: [Architecture Overview](/guide/architecture)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>styles:</b> ['.primary {color: red}']<br>
    <b>styleUrls:</b> ['my-component.css']
  </code></td>
  <td markdown="1">
  List of inline CSS styles or external stylesheet URLs for styling the component’s view.

  See: [Component Styles](/guide/component-styles)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>directives:</b> [CORE_DIRECTIVES, MyDirective, MyComponent]
  </code></td>
  <td markdown="1">
  List of directives used in the component's template.

  See: [Architecture Overview](/guide/architecture),
  [CORE_DIRECTIVES]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/CORE_DIRECTIVES-constant.html)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>pipes:</b> [commonPipes, MyPipe, ...]
  </code></td>
  <td markdown="1">
  List of pipes used in the component's template.

  See: [Pipes](/guide/pipes), [commonPipes]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/commonPipes-constant.html)
  </td>
</tr>

</table>
