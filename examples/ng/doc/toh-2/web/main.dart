import 'package:angular/angular.dart';

import 'package:angular_tour_of_heroes/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
