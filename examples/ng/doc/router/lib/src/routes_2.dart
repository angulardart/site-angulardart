import 'package:angular_router/angular_router.dart';

import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero_list_component_1.template.dart' as hero_list_template;
import 'not_found_component.template.dart' as not_found_template;
import 'route_paths.dart';

export 'route_paths.dart';

class Routes {
  static final crises = RouteDefinition(
    routePath: RoutePaths.crises,
    component: crisis_list_template.CrisisListComponentNgFactory,
  );

  // #docregion useAsDefault
  static final heroes = RouteDefinition(
    routePath: RoutePaths.heroes,
    component: hero_list_template.HeroListComponentNgFactory,
    useAsDefault: true,
  );
  // #enddocregion useAsDefault

  // #docregion redirect, wildcard
  static final all = <RouteDefinition>[
    // #enddocregion redirect, wildcard
    crises,
    heroes,
    // #docregion redirect
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.heroes.toUrl(),
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
