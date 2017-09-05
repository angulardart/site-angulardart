// #docplaster
// #docregion , imports
import 'dart:async';

import 'package:angular/angular.dart';
// #docregion import-router
import 'package:angular_router/angular_router.dart';
// #enddocregion import-router

import 'hero.dart';
import 'hero_service.dart';
// #enddocregion imports

// #docregion metadata, metadata-wo-styles
@Component(
  selector: 'my-dashboard',
  templateUrl: 'dashboard_component.html',
  // #enddocregion metadata-wo-styles
  styleUrls: const ['dashboard_component.css'],
  // #docregion metadata-wo-styles
  directives: const [CORE_DIRECTIVES, ROUTER_DIRECTIVES],
)
// #enddocregion metadata, metadata-wo-styles
// #docregion class
class DashboardComponent implements OnInit {
  List<Hero> heroes;

  // #docregion ctor
  final HeroService _heroService;

  DashboardComponent(this._heroService);
  // #enddocregion ctor

  Future<Null> ngOnInit() async {
    heroes = (await _heroService.getHeroes()).skip(1).take(4).toList();
  }
}
