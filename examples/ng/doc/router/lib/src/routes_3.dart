import 'package:angular_router/angular_router.dart';

import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero/hero_list_component.template.dart' as hero_list_template;
// #docregion hero
import 'hero/hero_component.template.dart' as hero_template;
// #enddocregion hero
import 'not_found_component.template.dart' as not_found_template;
import 'route_paths.dart';

export 'route_paths.dart';

// #docregion hero
class Routes {
  // #enddocregion hero
  static final crises = RouteDefinition(
    routePath: RoutePaths.crises,
    component: crisis_list_template.CrisisListComponentNgFactory,
  );

  static final heroes = RouteDefinition(
    routePath: RoutePaths.heroes,
    component: hero_list_template.HeroListComponentNgFactory,
  );

  // #docregion hero
  static final hero = RouteDefinition(
    routePath: RoutePaths.hero,
    component: hero_template.HeroComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    // #enddocregion hero
    crises,
    heroes,
    // #docregion hero
    hero,
    // #enddocregion hero
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.heroes.toUrl(),
    ),
    RouteDefinition(
      path: '.+',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
    // #docregion hero
  ];
}
