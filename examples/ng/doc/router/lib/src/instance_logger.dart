mixin InstanceLogger {
  static int _idCounter = 0;
  final _id = _idCounter++;
  String get loggerPrefix => '';

  void log(String msg) {
    if (loggerPrefix != null) print('[$_id] $loggerPrefix: $msg');
  }
}
