// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'heroes_component.html',
  styleUrls: const ['heroes_component.css'],
  directives: const [CORE_DIRECTIVES],
)
class HeroesComponent implements OnInit {
  final Router _router;
  final RouteParams _routeParams;
  final HeroService _heroService;
  List<Hero> heroes;
  Hero selectedHero;

  HeroesComponent(this._heroService, this._router, this._routeParams);

  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  // #docregion ngOnInit
  Future<Null> ngOnInit() async {
    await getHeroes();
    var id = _getId();
    if (id == null) return;
    selectedHero =
        heroes.firstWhere((hero) => hero.id == id, orElse: () => null);
  }

  int _getId() {
    var _id = _routeParams.get('id');
    return int.parse(_id ?? '', onError: (_) => null);
  }
  // #enddocregion ngOnInit

  // #docregion onSelect
  void onSelect(Hero hero) {
    selectedHero = hero;
    gotoDetail();
  }

  // #docregion gotoDetail
  Future gotoDetail() => _router.navigate([
        'HeroDetail',
        {'id': selectedHero.id.toString()}
      ]);
  // #enddocregion gotoDetail, onSelect
}
