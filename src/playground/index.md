---
layout: angular
title: "Writers' Playground"
permalink: /playground
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
  name: angular_app
  description: A web app that uses AngularDart
  version: 0.0.1

  environment:
    sdk: '>=1.23.0 <2.0.0'

  dependencies:
    angular2: ^3.1.0

  dev_dependencies:
    angular_test: ^1.0.0-beta+2
    browser: ^0.10.0
    dart_to_js_script_rewriter: ^1.0.1
    test: ^0.12.21

  transformers:
  - angular2:
      entry_points: web/main.dart
  - angular2/transform/reflection_remover:
      $include: test/**_test.dart
  - test/pub_serve:
      $include: test/**_test.dart
  - dart_to_js_script_rewriter
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
