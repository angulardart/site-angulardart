@TestOn('browser')
library heroes_test;

import 'package:test/test.dart';

import 'all_test.template.dart' as ng;
import 'app.dart' as app;
import 'dashboard.dart' as dashboard;
import 'dashboard_real_router.dart' as dashboard_real_router;
import 'heroes.dart' as heroes;
import 'hero.dart' as hero_detail;

void main() {
  ng.initReflector();
  group('app:', app.main);
  group('dashboard: mock router:', dashboard.main);
  group('dashboard: real router:', dashboard_real_router.main);
  group('heroes:', heroes.main);
  group('heroes_detail:', hero_detail.main);
}
