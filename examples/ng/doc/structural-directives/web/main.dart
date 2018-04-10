import 'package:angular/angular.dart';
import 'package:structural_directives/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
