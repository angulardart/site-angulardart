// **WARNING** To try out this version of the app, ensure that you update:
//
// - web/index.html
// - pubspec.yaml
//
// to refer to this file instead of main.dart
//
// Rename main_alt() to main().

import 'package:angular/angular.dart';

import 'package:dependency_injection/app_component_1.dart';
import 'package:dependency_injection/src/heroes/hero_service_1.dart';

import 'main_1.template.dart' as ng;

void main_alt() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}

void main_discouraged() {
  // #docregion bootstrap-discouraged
  bootstrapStatic(
      AppComponent,
      [HeroService], // DISCOURAGED (but works)
      ng.initReflector);
  // #enddocregion bootstrap-discouraged
}
