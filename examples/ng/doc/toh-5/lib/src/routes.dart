// #docregion , a-first-route
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
// #enddocregion a-first-route
// #docregion dct
import 'dashboard_component.template.dart' as dct;
// #enddocregion dct
// #docregion hct
import 'hero_component.template.dart' as hct;
// #enddocregion hct
// #docregion a-first-route, hlct
import 'hero_list_component.template.dart' as hlct;
// #enddocregion hlct

@Injectable()
// #docregion hero
class Routes {
  // #enddocregion hero
  static final _heroes = new RouteDefinition(
    routePath: paths.heroes,
    component: hlct.HeroListComponentNgFactory,
  );

  RouteDefinition get heroes => _heroes;
  // #enddocregion a-first-route

  // #docregion dashboard
  static final _dashboard = new RouteDefinition(
    routePath: paths.dashboard,
    component: dct.DashboardComponentNgFactory,
  );

  RouteDefinition get dashboard => _dashboard;
  // #enddocregion dashboard

  // #docregion hero
  static final _hero = new RouteDefinition(
    routePath: paths.hero,
    component: hct.HeroComponentNgFactory,
  );

  RouteDefinition get hero => _hero;
  // #docregion a-first-route, dashboard

  final List<RouteDefinition> all = [
    // #enddocregion a-first-route, dashboard, hero
    // #docregion redirect-route
    new RouteDefinition.redirect(path: '', redirectTo: paths.dashboard.toUrl()),
    // #enddocregion redirect-route
    // #docregion dashboard
    _dashboard,
    // #enddocregion dashboard
    // #docregion hero
    _hero,
    // #docregion a-first-route, dashboard
    _heroes,
  ];
  // #enddocregion dashboard
}
