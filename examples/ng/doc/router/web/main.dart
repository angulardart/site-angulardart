import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:router_example/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(
      AppComponent,
      [
        routerProvidersHash // You can use routerProviders in production
      ],
      ng.initReflector);
}
