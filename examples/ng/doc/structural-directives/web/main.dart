// #docregion
import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';

import 'package:structural_directives/app_component.dart';

void main() {
  // bootstrap(StructuralDirectivesComponent);
  bootstrap(AppComponent,
      // https://github.com/dart-lang/angular2/issues/277
      [provide(ExceptionHandler, useClass: BrowserExceptionHandler)]);
}

@Injectable()
class BrowserExceptionHandler implements ExceptionHandler {
  const BrowserExceptionHandler();

  @override
  void call(exception, [stackTrace, String reason]) {
    window.console.error(ExceptionHandler.exceptionToString(
      exception,
      stackTrace,
      reason,
    ));
  }
}
