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

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnChanges(changeRecord)</b> { ... }
  </code></td>
  <td markdown="1">
Called after every change to input properties and before processing content or child views.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[OnChanges class](/api/angular2/angular2.core/OnChanges-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after the constructor, initializing input properties, and the first call to `ngOnChanges`.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[OnInit class](/api/angular2/angular2.core/OnInit-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngDoCheck()</b> { ... }
  </code></td>
  <td markdown="1">
Called every time that the input properties of a component or a directive are checked. Use it to extend change detection by performing a custom check.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[DoCheck class](/api/angular2/angular2.core/DoCheck-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterContentInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after ngOnInit when the component's or directive's content has been initialized.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[AfterContentInit class](/api/angular2/angular2.core/AfterContentInit-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterContentChecked()</b> { ... }
  </code></td>
  <td markdown="1">
Called after every check of the component's or directive's content.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[AfterContentChecked class](/api/angular2/angular2.core/AfterContentChecked-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterViewInit()</b> { ... }
  </code></td>
  <td markdown="1">
Called after `ngAfterContentInit` when the component's view has been initialized. Applies to components only.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[AfterViewInit class](/api/angular2/angular2.core/AfterViewInit-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngAfterViewChecked()</b> { ... }
  </code></td>
  <td markdown="1">
Called after every check of the component's view. Applies to components only.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[AfterViewChecked class](/api/angular2/angular2.core/AfterViewChecked-class)

  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>ngOnDestroy()</b> { ... }
  </code></td>
  <td markdown="1">
Called once, before the instance is destroyed.

See: [Lifecycle Hooks](/angular/guide/lifecycle-hooks),
[OnDestroy class](/api/angular2/angular2.core/OnDestroy-class)
  </td>
</tr>

</table>
