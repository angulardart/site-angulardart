import 'package:angular/angular.dart';

import 'package:attribute_directives/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
