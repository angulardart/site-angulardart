// #docregion a-first-route
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
// #enddocregion a-first-route
// #docregion dashboard_template
import 'dashboard_component.template.dart' as dashboard_template;
// #enddocregion dashboard_template
// #docregion hero_template
import 'hero_component.template.dart' as hero_template;
// #enddocregion hero_template
// #docregion a-first-route, hero_list_template
import 'hero_list_component.template.dart' as hero_list_template;
// #enddocregion hero_list_template

export 'route_paths.dart';

class Routes {
  // #enddocregion a-first-route
  // #docregion dashboard
  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );
  // #enddocregion dashboard

  // #docregion hero
  static final hero = RouteDefinition(
    routePath: RoutePaths.hero,
    component: hero_template.HeroComponentNgFactory,
  );
  // #enddocregion hero

  // #docregion a-first-route
  static final heroes = RouteDefinition(
    routePath: RoutePaths.heroes,
    component: hero_list_template.HeroListComponentNgFactory,
  );

  // #docregion dashboard, hero, redirect-route
  static final all = <RouteDefinition>[
    // #enddocregion a-first-route, hero, redirect-route
    dashboard,
    // #enddocregion dashboard
    // #docregion hero
    hero,
    // #enddocregion hero
    // #docregion a-first-route
    heroes,
    // #enddocregion a-first-route
    // #docregion redirect-route
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dashboard.toUrl(),
    ),
    // #docregion a-first-route, dashboard, hero
  ];
  // #enddocregion dashboard, hero, redirect-route
}
