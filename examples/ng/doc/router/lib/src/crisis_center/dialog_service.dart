// #docregion
import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

@Injectable()
class DialogService {
  Future<bool> confirm(String message) async =>
      window.confirm(message ?? 'Ok?');
}
