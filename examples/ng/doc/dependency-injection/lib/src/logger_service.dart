import 'package:angular/angular.dart';

/// Logger that keeps only the last log entry.
class Logger {
  String _log = '';
  String get id => 'Logger';

  void fine(String msg) => _log = msg;

  @override
  String toString() => '[$id] $_log';
}
