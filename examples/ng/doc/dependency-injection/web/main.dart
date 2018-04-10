import 'package:angular/angular.dart';
import 'package:dependency_injection/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
