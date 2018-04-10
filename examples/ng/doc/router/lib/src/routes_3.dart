// #docregion
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
  static final _crises = new RouteDefinition(
    routePath: paths.crises,
    component: clct.CrisisListComponentNgFactory,
  );

  static final _heroes = new RouteDefinition(
    routePath: paths.heroes,
    component: hlct.HeroListComponentNgFactory,
  );

  // #docregion hero
  static final _hero = new RouteDefinition(
    routePath: paths.hero,
    component: hct.HeroComponentNgFactory,
  );
  // #enddocregion hero

  final crises = _crises;
  final heroes = _heroes;

  // #docregion hero
  final List<RouteDefinition> all = [
    _crises,
    _heroes,
    _hero,
    // #enddocregion hero
    new RouteDefinition.redirect(
      path: '',
      redirectTo: paths.heroes.toUrl(),
    ),
    new RouteDefinition(
      path: '.+',
      component: nfct.NotFoundComponentNgFactory,
    ),
    // #docregion hero
  ];
}
