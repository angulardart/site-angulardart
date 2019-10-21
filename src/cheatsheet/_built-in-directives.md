<table id="core-directives">

<tr>
  <th>Core directives</th>
  <th markdown="1">
  `import 'package:angular/angular.dart';`
  Available from [CORE_DIRECTIVES]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/CORE_DIRECTIVES-constant.html)
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;section <b>*ngIf</b>="showSection">
  </code></td>
  <td markdown="1">
  Removes or recreates a portion of the DOM tree based on the `showSection` expression.

  See: [Template Syntax](/guide/template-syntax),
  [NgIf class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgIf-class.html)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;li <b>*ngFor</b>="let item of list">
  </code></td>
  <td markdown="1">
  Turns the li element and its contents into a template, and uses that to instantiate a view for each item in list.

  See: [Template Syntax](/guide/template-syntax),
  [NgFor class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgFor-class.html)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div <b>[ngSwitch]</b>="conditionExpression"><br>
    &nbsp;&nbsp;&lt;template <b>[ngSwitchCase]</b>="case1Exp">...&lt;/template><br>
    &nbsp;&nbsp;&lt;template <b>ngSwitchCase</b>="case2LiteralString">...&lt;/template><br>
    &nbsp;&nbsp;&lt;template <b>ngSwitchDefault</b>>...&lt;/template><br>
    &lt;/div>
  </code></td>
  <td markdown="1">
  Conditionally swaps the contents of the div by selecting one of the embedded templates based on the current value of conditionExpression.

  See: [Template Syntax](/guide/template-syntax),
  [NgSwitch class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgSwitch-class.html),
  [NgSwitchCase class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgSwitchWhen-class.html),
  [NgSwitchDefault class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgSwitchDefault-class.html)
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-html">
    &lt;div <b>[ngClass]</b>="{active: isActive, disabled: isDisabled}">
  </code></td>
  <td markdown="1">
  Binds the presence of CSS classes on the element to the truthiness of the associated map values. The right-hand expression should return {class-name: true/false} map.

  See: [Template Syntax](/guide/template-syntax),
  [NgClass class]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular/NgClass-class.html)
  </td>
</tr>

</table>

<!-- TODO: Why isn't NgStyle in here or in the TS cheat sheet? -->
