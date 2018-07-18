import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis_list_component_1.template.dart' as clct;
import 'hero_list_component_1.template.dart' as hlct;
import 'not_found_component.template.dart' as nfct;

class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  // #docregion redirect, wildcard
  final List<RouteDefinition> all = [
    // #enddocregion redirect, wildcard
    RouteDefinition(
      routePath: paths.crises,
      component: clct.CrisisListComponentNgFactory,
    ),
    // #docregion useAsDefault
    RouteDefinition(
      routePath: paths.heroes,
      component: hlct.HeroListComponentNgFactory,
      useAsDefault: true,
    ),
    // #enddocregion useAsDefault
    // #docregion redirect
    RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    // #enddocregion redirect
    // #docregion wildcard
    RouteDefinition(
      path: '.+',
      component: nfct.NotFoundComponentNgFactory,
    ),
    // #docregion redirect
  ];
  // #enddocregion redirect, wildcard
}
