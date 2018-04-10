// #docplaster
// #docregion final
import 'package:angular/angular.dart';
// #enddocregion final

//import 'package:displaying_data/app_component_1.dart' as v1;
//import 'package:displaying_data/app_component_2.dart' as v2;
//import 'package:displaying_data/app_component_3.dart' as v3;
// #docregion final
import 'package:displaying_data/app_component.dart';

import 'main.template.dart' as ng;

void main() {
// #enddocregion final
// pick one
//  bootstrapStatic(v1.AppComponent, [], ng.initReflector);
//  bootstrapStatic(v2.AppComponent, [], ng.initReflector);
//  bootstrapStatic(v3.AppComponent, [], ng.initReflector);
// #docregion final
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
