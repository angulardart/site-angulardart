import 'package:angular/angular.dart';

@Injectable()
/// Logger that keeps only the last log entry.
class Logger {
  String _log = '';

  void fine(String msg) => _log = msg;

  @override
  String toString() => '[$runtimeType] $_log';
}
