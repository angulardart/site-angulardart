// #docregion
@Tags(const ['aot'])
@TestOn('browser')
library heroes_test;

import 'package:angular2/angular2.dart';
import 'package:test/test.dart';

import 'heroes.dart' as heroes;
import 'hero_detail.dart' as hero_detail;

@AngularEntrypoint()
void main() {
  group('heroes:', heroes.main);
  group('heroes_detail:', hero_detail.main);
}
