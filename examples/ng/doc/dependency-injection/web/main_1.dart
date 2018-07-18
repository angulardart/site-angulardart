import 'package:angular/angular.dart';
import 'package:dependency_injection/app_component_1.template.dart' as ng;
import 'package:dependency_injection/src/heroes/hero_service_1.dart';

import 'main_1.template.dart' as self;

// #docregion discouraged
@GenerateInjector([
  // DON'T register app-local services here; this is for illustration purposes only
  ClassProvider(HeroService),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: rootInjector);
}
