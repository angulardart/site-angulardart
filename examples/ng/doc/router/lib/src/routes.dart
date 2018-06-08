import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'crisis/crisis_list_component.template.dart' as clct;
import 'hero/hero_list_component.template.dart' as hlct;
import 'hero/hero_component.template.dart' as hct;
import 'not_found_component.template.dart' as nfct;

@Injectable()
class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  final List<RouteDefinition> all = [
    new RouteDefinition(
      routePath: paths.crises,
      component: clct.CrisisListComponentNgFactory,
    ),
    new RouteDefinition(
      routePath: paths.heroes,
      component: hlct.HeroListComponentNgFactory,
    ),
    new RouteDefinition(
      routePath: paths.hero,
      component: hct.HeroComponentNgFactory,
    ),
    new RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    new RouteDefinition(
      path: '.*',
      component: nfct.NotFoundComponentNgFactory,
    ),
  ];
}
