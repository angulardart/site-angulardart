// ignore_for_file: unused_element
// #docplaster
// #docregion
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis_list_component_1.template.dart' as clct;
import 'hero_list_component_1.template.dart' as hlct;
import 'not_found_component.template.dart' as nfct;

@Injectable()
class Routes {
  static final _crises = new RouteDefinition(
    routePath: paths.crises,
    component: clct.CrisisListComponentNgFactory,
  );

  // #docregion useAsDefault
  static final _heroes = new RouteDefinition(
    routePath: paths.heroes,
    component: hlct.HeroListComponentNgFactory,
    useAsDefault: true,
  );
  // #enddocregion useAsDefault

  final crises = _crises;
  final heroes = _heroes;

  // #docregion redirect, wildcard
  final List<RouteDefinition> all = [
    _crises,
    _heroes,
    // #enddocregion wildcard
    new RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    // #enddocregion redirect
    // #docregion wildcard
    // ...
    new RouteDefinition(
      path: '.+',
      component: nfct.NotFoundComponentNgFactory,
    ),
    // #docregion redirect
  ];
  // #enddocregion redirect, wildcard
}
