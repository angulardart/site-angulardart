import 'dart:async';

import 'package:angular/angular.dart';
// #docregion gotoDetail-stub
import 'package:angular_router/angular_router.dart';
// #enddocregion gotoDetail-stub

import 'route_paths.dart';
import 'hero.dart';
import 'hero_service.dart';

// #docregion metadata, pipes, renaming
@Component(
  selector: 'my-heroes',
  // #enddocregion pipes
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  // #enddocregion renaming
  directives: [coreDirectives],
  // #docregion pipes
  pipes: [commonPipes],
  // #docregion renaming
)
// #enddocregion metadata, pipes
// #docregion class, gotoDetail-stub
class HeroListComponent implements OnInit {
  // #enddocregion renaming, gotoDetail-stub
  final HeroService _heroService;
  final Router _router;
  List<Hero> heroes;
  Hero selected;

  // #docregion renaming
  HeroListComponent(this._heroService, this._router);
  // #enddocregion renaming

  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }

  void ngOnInit() => _getHeroes();

  void onSelect(Hero hero) => selected = hero;

  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  // #docregion gotoDetail, gotoDetail-stub
  Future<NavigationResult> gotoDetail() =>
      _router.navigate(_heroUrl(selected.id));
  // #enddocregion gotoDetail
  // #docregion renaming
}
