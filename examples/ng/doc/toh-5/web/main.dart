import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;

import 'main.template.dart' as self;

// #docregion injector
@GenerateInjector(
  routerProvidersHash, // You can use routerProviders in production
)
final InjectorFactory injector = self.injector$Injector;
// #enddocregion injector

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
