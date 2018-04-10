/// @license
/// Copyright Google Inc. All Rights Reserved.

import 'package:angular/angular.dart';
import 'package:pipes/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
