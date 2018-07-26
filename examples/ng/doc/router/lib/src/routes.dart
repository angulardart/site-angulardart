import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis/crisis_list_component.template.dart' as crisis_list_template;
import 'hero/hero_list_component.template.dart' as hero_list_template;
import 'hero/hero_component.template.dart' as hero_template;
import 'not_found_component.template.dart' as not_found_template;

class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  final List<RouteDefinition> all = [
    RouteDefinition(
      routePath: paths.crises,
      component: crisis_list_template.CrisisListComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.heroes,
      component: hero_list_template.HeroListComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.hero,
      component: hero_template.HeroComponentNgFactory,
    ),
    RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    RouteDefinition(
      path: '.*',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
  ];
}
