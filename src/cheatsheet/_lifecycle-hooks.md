<table id="lifecycle-hooks">

<tr>
  <th>Directive and component change detection and lifecycle hooks</th>
  <th markdown="1">
  (implemented as class methods)
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>MyAppComponent(MyService myService, ...)</b> { ... }
  </code></td>
  <td markdown="1">
Called before any other lifecycle hook. Use it to inject dependencies, but avoid any serious work here.

See: [Lifecycle Hooks](/guide/lifecycle-hooks)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnChanges(changeRecord)</b> { ... }
  </code></td>
  <td markdown="1">
Called after every change to input properties and before processing content or child views.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[OnChanges class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/OnChanges-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after the constructor, initializing input properties, and the first call to `ngOnChanges`.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[OnInit class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/OnInit-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngDoCheck()</b> { ... }
  </code></td>
  <td markdown="1">
Called every time that the input properties of a component or a directive are checked. Use it to extend change detection by performing a custom check.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[DoCheck class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/DoCheck-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterContentInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after ngOnInit when the component's or directive's content has been initialized.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[AfterContentInit class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/AfterContentInit-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterContentChecked()</b> { ... }
  </code></td>
  <td markdown="1">
Called after every check of the component's or directive's content.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[AfterContentChecked class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/AfterContentChecked-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterViewInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after `ngAfterContentInit` when the component's view has been initialized. Applies to components only.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[AfterViewInit class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/AfterViewInit-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterViewChecked()</b> { ... }
  </code></td>
  <td markdown="1">
Called after every check of the component's view. Applies to components only.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[AfterViewChecked class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/AfterViewChecked-class.html)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnDestroy()</b> { ... }
  </code></td>
  <td markdown="1">
Called once, before the instance is destroyed.

See: [Lifecycle Hooks](/guide/lifecycle-hooks),
[OnDestroy class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/OnDestroy-class.html)
  </td>
</tr>

</table>
