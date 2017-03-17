// #docregion
import 'package:angular2/core.dart';

@Component(
    // selector isn't needed, but must be provided
    // https://github.com/dart-lang/angular2/issues/60
    selector: 'my-crisis-center-home',
    template: '<p>Welcome to the Crisis Center</p>')
class CrisisCenterHomeComponent {}
