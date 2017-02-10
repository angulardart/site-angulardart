// #docregion
import 'package:angular2/core.dart';

@Component(
    // selector isn't needed, but must be provided
    // https://github.com/dart-lang/angular2/issues/60
    selector: 'my-crisis-center',
    // #docregion template
    template: '''
      <h2>Crisis Center</h2>
      <p>Get your crisis here</p>
    '''
    // #enddocregion template
)
class CrisisCenterComponent { }
