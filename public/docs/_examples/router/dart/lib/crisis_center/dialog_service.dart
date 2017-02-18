// #docregion
import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';

@Injectable()
class DialogService {
  Future<bool> confirm(String message) async =>
      await window.confirm(message ?? 'Ok?');
}
