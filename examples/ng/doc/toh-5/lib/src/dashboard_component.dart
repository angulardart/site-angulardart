import 'package:angular/angular.dart';
// #docregion import-router
import 'package:angular_router/angular_router.dart';
// #enddocregion import-router

import 'hero.dart';
import 'hero_service.dart';
import 'route_paths.dart';

// #docregion metadata, metadata-wo-styles
@Component(
  selector: 'my-dashboard',
  templateUrl: 'dashboard_component.html',
  // #enddocregion metadata-wo-styles
  styleUrls: ['dashboard_component.css'],
  // #docregion metadata-wo-styles
  directives: [coreDirectives, routerDirectives],
)
// #enddocregion metadata, metadata-wo-styles
// #docregion class
class DashboardComponent implements OnInit {
  List<Hero> heroes;

  // #docregion ctor
  final HeroService _heroService;

  DashboardComponent(this._heroService);
  // #enddocregion ctor

  // #docregion heroUrl
  String heroUrl(int id) => RoutePaths.hero.toUrl(parameters: {idParam: '$id'});
  // #enddocregion heroUrl

  @override
  void ngOnInit() async {
    heroes = (await _heroService.getAll()).skip(1).take(4).toList();
  }
}
