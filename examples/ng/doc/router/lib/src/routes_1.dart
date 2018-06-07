import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths_1.dart' as paths;
import 'crisis_list_component_1.template.dart' as clct;
import 'hero_list_component_1.template.dart' as hlct;

@Injectable()
class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  final List<RouteDefinition> all = [
    new RouteDefinition(
      path: paths.crises.path,
      component: clct.CrisisListComponentNgFactory,
    ),
    new RouteDefinition(
      path: paths.heroes.path,
      component: hlct.HeroListComponentNgFactory,
    ),
  ];
}
