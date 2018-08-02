import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

// #docregion import
import '../route_paths.dart';
// #enddocregion import
import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  directives: [coreDirectives],
)
class HeroListComponent implements OnActivate {
  final HeroService _heroService;
  final Router _router;
  List<Hero> heroes;
  Hero selected;

  HeroListComponent(this._heroService, this._router);

  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }

  // #docregion onActivate
  @override
  void onActivate(_, RouterState current) async {
    await _getHeroes();
    selected = _select(current);
  }

  Hero _select(RouterState routerState) {
    final id = getId(routerState.queryParameters);
    return id == null
        ? null
        : heroes.firstWhere((e) => e.id == id, orElse: () => null);
  }
  // #enddocregion onActivate

  // #docregion onSelect, onSelect-_gotoDetail
  void onSelect(Hero hero) => _gotoDetail(hero.id);
  // #enddocregion onSelect, onSelect-_gotoDetail

  // #docregion _gotoDetail-heroUrl
  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  // #docregion _gotoDetail, onSelect-_gotoDetail
  Future<NavigationResult> _gotoDetail(int id) =>
      _router.navigate(_heroUrl(id));
  // #enddocregion _gotoDetail, _gotoDetail-heroUrl, onSelect-_gotoDetail
}
