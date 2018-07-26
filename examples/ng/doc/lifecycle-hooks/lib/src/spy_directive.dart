import 'package:angular/angular.dart';

import 'logger_service.dart';

int _nextId = 1;

// #docregion spy-directive
// Spy on any element to which it is applied.
// Usage: <div mySpy>...</div>
@Directive(selector: '[mySpy]')
class SpyDirective implements OnInit, OnDestroy {
  final LoggerService _logger;

  SpyDirective(this._logger);

  @override
  void ngOnInit() => _logIt('onInit');

  @override
  void ngOnDestroy() => _logIt('onDestroy');

  _logIt(String msg) => _logger.log('Spy #${_nextId++} $msg');
}
// #enddocregion spy-directive
