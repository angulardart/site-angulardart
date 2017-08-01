---
layout: angular
title: "Writers' Playground"
permalink: /playground
sitemap: false
---

Title and code not tied to a file:
<?code-excerpt title="some title!"?>
```dart
  var y = 0; // title="some title!"
```

Quickstart pubspec w/ title:
<?code-excerpt "quickstart/lib/app_component.dart" title?>
```
  import 'package:angular2/angular2.dart';

  [!@Component(
    selector: 'my-app',
    template: '<h1>Hello {{name}}</h1>')!]
  class AppComponent {
    var [!name!] = 'Angular';
  }
```

<?code-excerpt path-base="quickstart"?>

Quickstart pubspec w/ title:
<?code-excerpt "pubspec.yaml" title?>
```
  ...
```

`index.html` my-app excerpt (no title)
<?code-excerpt "web/index.html (my-app)"?>
```
  <my-app>Loading...</my-app>
```

## Converted (manually)

<div class="code-example">
<header><h4>lib/x.dart</h4></header>
<code-example language="dart">  var x = '&lt;b&gt;x&lt;/b&gt;';
<span class="highlight">  var z = 'x';
  var y = 3;</span>
</code-example>
</div>

This doesn't quite work:

<div class="code-example">
<header><h4>lib/x2.dart</h4></header>
<div code-example language="dart" markdown="1">
```
  var x = '<b>x</b>';
```
</div>
</div>
