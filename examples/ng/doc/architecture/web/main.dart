// #docregion
import 'package:angular/angular.dart';
import 'package:developer_guide_intro/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  // #docregion bootstrap
  bootstrapStatic(AppComponent, [], ng.initReflector);
  // #enddocregion bootstrap
}
