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
class Routes {
  RoutePath get heroes => paths.heroes;

  // #enddocregion a-first-route
  // #docregion dashboard
  RoutePath get dashboard => paths.dashboard;
  // #enddocregion dashboard

  // #docregion hero
  RoutePath get hero => paths.hero;

  // #docregion a-first-route, dashboard
  final List<RouteDefinition> all = [
    // #enddocregion a-first-route, dashboard, hero
    // #docregion redirect-route
    new RouteDefinition.redirect(path: '', redirectTo: paths.dashboard.toUrl()),
    // #enddocregion redirect-route
    // #docregion dashboard
    new RouteDefinition(
      path: paths.dashboard.path,
      component: dct.DashboardComponentNgFactory,
    ),
    // #enddocregion dashboard
    // #docregion hero
    new RouteDefinition(
      path: paths.hero.path,
      component: hct.HeroComponentNgFactory,
    ),
    // #enddocregion hero
    // #docregion a-first-route
    new RouteDefinition(
      path: paths.heroes.path,
      component: hlct.HeroListComponentNgFactory,
    ),
    // #docregion dashboard, hero
  ];
  // #enddocregion dashboard, hero
}
