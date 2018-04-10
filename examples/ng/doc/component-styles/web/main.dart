import 'package:angular/angular.dart';
import 'package:component_styles/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
