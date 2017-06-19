<table id="template-syntax">

<tr>
  <th>Template syntax</th>
  <th></th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;input <b>[value]</b>="firstName">
  </code></td>
  <td markdown="1">
  Binds property `value` to the result of expression `firstName`.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div <b>[attr.role]</b>="myAriaRole">
  </code></td>
  <td markdown="1">
  Binds attribute `role` to the result of expression `myAriaRole`.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div <b>[class.extra-sparkle]</b>="isDelightful">
  </code></td>
  <td markdown="1">
  Binds the presence of the CSS class `extra-sparkle` on the element to the truthiness of the expression `isDelightful`.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div <b>[style.width.px]</b>="mySize">
  </code></td>
  <td markdown="1">
  Binds style property `width` to the result of expression `mySize` in pixels. Units are optional.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;button <b>(click)</b>="readRainbow($event)">
  </code></td>
  <td markdown="1">
  Calls method `readRainbow` when a click event is triggered on this button element (or its children) and passes in the event object.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div title="Hello <b>{&#8203;{ponyName}}</b>">
  </code></td>
  <td markdown="1">
  Binds a property to an interpolated string, for example, "Hello Seabiscuit". Equivalent to:
  `<div [title]="'Hello' + ponyName">`

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;p>Hello <b>{&#8203;{ponyName}}</b></p>
  </code></td>
  <td markdown="1">
  Binds text content to an interpolated string, for example, "Hello Seabiscuit".

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;my-cmp <b>[(title)]</b>="name">
  </code></td>
  <td markdown="1">
  Sets up two-way data binding. Equivalent to:
  `<my-cmp [title]="name" (titleChange)="name=$event">`

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
  &lt;video <b>#movieplayer</b> ...><br>
  &nbsp;&nbsp;&lt;button <b>(click)</b>="movieplayer.play()"><br>
  &lt;/video></code></td>
  <td markdown="1">
  Creates a local variable `movieplayer` that provides access to the `video` element instance in data-binding and event-binding expressions in the current template.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;p <b>*myUnless</b>="myExpression">...</p>
  </code></td>
  <td markdown="1">
  The `*` symbol turns the current element into an embedded template. Equivalent to:
  `<template [myUnless]="myExpression"><p>...</p></template>`

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;p><br>
    &nbsp;&nbsp;Card No.: <b>{&#8203;{cardNumber | myCardNumberFormatter}}</b><br>
    </p>
  </code></td>
  <td markdown="1">
  Transforms the current value of expression `cardNumber` via the pipe called `myCardNumberFormatter`.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;p><br>
    &nbsp;&nbsp;Employer: <b>{&#8203;{employer?.companyName}}</b><br>
    </p>
  </code></td>
  <td markdown="1">
  The safe navigation operator (`?`) means that the `employer` field is optional and if `undefined`, the rest of the expression should be ignored.

  See: [Template Syntax](/angular/guide/template-syntax)
  </td>
</tr>

</table>
