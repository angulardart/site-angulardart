import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero_list_component_1.template.dart' as hero_list_template;
import 'not_found_component.template.dart' as not_found_template;

class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  // #docregion redirect, wildcard
  final List<RouteDefinition> all = [
    // #enddocregion redirect, wildcard
    RouteDefinition(
      routePath: paths.crises,
      component: crisis_list_template.CrisisListComponentNgFactory,
    ),
    // #docregion useAsDefault
    RouteDefinition(
      routePath: paths.heroes,
      component: hero_list_template.HeroListComponentNgFactory,
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
      component: not_found_template.NotFoundComponentNgFactory,
    ),
    // #docregion redirect
  ];
  // #enddocregion redirect, wildcard
}
