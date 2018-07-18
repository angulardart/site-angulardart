import 'dart:html';

// #docregion class
class Logger {
  void log(Object msg) => window.console.log(msg);
  void error(Object msg) => window.console.error(msg);
  void warn(Object msg) => window.console.warn(msg);
}
