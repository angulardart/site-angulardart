<table id="class-decorators">

<tr>
  <th>Class decorators</th>
  <th markdown="1">
  `import 'package:angular2/angular2.dart';`
  </th>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@Component(...)</b><br>
    class MyComponent() {}
  </code></td>
  <td markdown="1">
  Declares that a class is a component and provides metadata about the component.
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@Directive(...)</b><br>
    class MyDirective() {}
  </code></td>
  <td markdown="1">
  Declares that a class is a directive and provides metadata about the directive.
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@Pipe(...)</b><br>
    class MyPipe() {}
  </code></td>
  <td markdown="1">
  Declares that a class is a pipe and provides metadata about the pipe.
  </td>
</tr>

<tr>
  <td class="nowrap"><code class="prettyprint lang-dart">
    <b>@Injectable()</b><br>
    class MyService() {}
  </code></td>
  <td markdown="1">
  Declares that a class has dependencies that should be injected into the constructor when the dependency injector is creating an instance of this class.
  </td>
</tr>

</table>
