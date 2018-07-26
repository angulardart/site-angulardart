import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'dashboard_component.template.dart' as dashboard_template;
import 'hero_component.template.dart' as hero_template;
import 'hero_list_component.template.dart' as hero_list_template;

class Routes {
  RoutePath get heroes => paths.heroes;
  RoutePath get dashboard => paths.dashboard;
  RoutePath get hero => paths.hero;

  final List<RouteDefinition> all = [
    RouteDefinition.redirect(path: '', redirectTo: paths.dashboard.toUrl()),
    RouteDefinition(
      routePath: paths.dashboard,
      component: dashboard_template.DashboardComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.hero,
      component: hero_template.HeroComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.heroes,
      component: hero_list_template.HeroListComponentNgFactory,
    ),
  ];
}
