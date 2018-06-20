import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:http/browser_client.dart';

import 'main_1.template.dart' as self;

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  ClassProvider(BrowserClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
