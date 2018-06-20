// #docregion import
import 'package:angular/angular.dart';
// #enddocregion import

import 'src/backend_service.dart';
import 'src/hero_list_component.dart';
import 'src/hero_service.dart';
import 'src/logger_service.dart';
import 'src/sales_tax_component.dart';

// #docregion providers
@Component(
  // #enddocregion providers
  selector: 'my-app',
  template: '''
    <hero-list></hero-list>
    <sales-tax></sales-tax>
  ''',
  directives: [HeroListComponent, SalesTaxComponent],
  // #docregion providers
  providers: [
    ClassProvider(BackendService),
    ClassProvider(HeroService),
    ClassProvider(Logger),
  ],
)
// #docregion class
class AppComponent {}
