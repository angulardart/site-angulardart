/// @license
/// Copyright Google Inc. All Rights Reserved.

import 'package:angular/angular.dart';

import 'async_pipe.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: [
    coreDirectives,
    AsyncGreeterPipe,
    AsyncTimePipe,
  ],
  pipes: [SlicePipe],
)
class AppComponent {
  final String str = 'abcdefghij'; // used in slice pipe example
}
