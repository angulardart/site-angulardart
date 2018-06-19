import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis_list_component_1.template.dart' as clct;
import 'hero/hero_list_component.template.dart' as hlct;
// #docregion hero
import 'hero/hero_component.template.dart' as hct;
// #enddocregion hero
import 'not_found_component.template.dart' as nfct;

// #docregion hero
@Injectable()
class Routes {
  // #enddocregion hero
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  // #docregion hero
  final List<RouteDefinition> all = [
    // #enddocregion hero
    RouteDefinition(
      routePath: paths.crises,
      component: clct.CrisisListComponentNgFactory,
    ),
    RouteDefinition(
      routePath: paths.heroes,
      component: hlct.HeroListComponentNgFactory,
    ),
    // #docregion hero
    RouteDefinition(
      routePath: paths.hero,
      component: hct.HeroComponentNgFactory,
    ),
    // #enddocregion hero
    RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    RouteDefinition(
      path: '.+',
      component: nfct.NotFoundComponentNgFactory,
    ),
    // #docregion hero
  ];
}
