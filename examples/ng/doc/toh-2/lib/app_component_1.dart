/// This file is used to hold snippets
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart' as fd;

// A bit of hacking to make the template compiler happy:
const formDirectives = const [CORE_DIRECTIVES, fd.formDirectives];

// #docregion metadata
@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [formDirectives],
)
// #enddocregion metadata
class bogusClass1 {}

@Component(
  selector: 'my-app',
  template: '',
  /*
  // #docregion styles
  // Not recommended when adding many CSS classes:
  styles: const [
    '''
      .selected { ... }
      .heroes { ... }
      ...
    '''
  ],
  // #enddocregion styles
  */
)
class bogusClass2 {}
