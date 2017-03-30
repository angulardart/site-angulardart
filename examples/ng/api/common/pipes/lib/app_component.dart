/// @license
/// Copyright Google Inc. All Rights Reserved.

import 'package:angular2/core.dart';

import 'async_pipe.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [AsyncGreeterPipe, AsyncTimePipe])
class AppComponent {
  final String str = 'abcdefghij'; // used in slice pipe example
}
