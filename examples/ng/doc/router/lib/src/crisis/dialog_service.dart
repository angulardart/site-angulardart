import 'dart:async';
import 'dart:html';

class DialogService {
  Future<bool> confirm(String message) async =>
      window.confirm(message ?? 'Ok?');
}
