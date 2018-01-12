/// @license
/// Copyright Google Inc. All Rights Reserved.

import 'package:angular/angular.dart';

import 'async_pipe.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [
    CORE_DIRECTIVES,
    AsyncGreeterPipe,
    AsyncTimePipe,
  ],
  pipes: const [SlicePipe],
)
class AppComponent {
  final String str = 'abcdefghij'; // used in slice pipe example
}
