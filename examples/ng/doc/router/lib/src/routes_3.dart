import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero/hero_list_component.template.dart' as hero_list_template;
// #docregion hero
import 'hero/hero_component.template.dart' as hero_template;
// #enddocregion hero
import 'not_found_component.template.dart' as not_found_template;

// #docregion hero
class Routes {
  // #enddocregion hero
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  // #docregion hero
  final List<RouteDefinition> all = [
    // #enddocregion hero
    RouteDefinition(
      routePath: paths.crises,
      component: crisis_list_template.CrisisListComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.heroes,
      component: hero_list_template.HeroListComponentNgFactory,
    ),
    // #docregion hero
    RouteDefinition(
      routePath: paths.hero,
      component: hero_template.HeroComponentNgFactory,
    ),
    // #enddocregion hero
    RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    RouteDefinition(
      path: '.+',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
    // #docregion hero
  ];
}
