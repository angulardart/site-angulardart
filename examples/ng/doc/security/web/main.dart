// #docregion
import 'package:angular/angular.dart';

import 'package:angular_security/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
