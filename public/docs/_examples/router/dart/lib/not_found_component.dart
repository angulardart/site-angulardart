// #docregion
import 'package:angular2/core.dart';

@Component(
    // selector isn't needed, but must be provided
    // https://github.com/dart-lang/angular2/issues/60
    selector: 'my-not-found',
    // #docregion template
    template: '<h2>Page not found</h2>'
    // #enddocregion template
)
class NotFoundComponent { }
