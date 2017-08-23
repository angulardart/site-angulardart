// #docplaster
// #docregion , v2
// #docregion added-imports
import 'dart:async';

// #enddocregion added-imports
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
// #docregion added-imports
import 'package:angular_router/angular_router.dart';

// #enddocregion added-imports
import 'hero.dart';
// #docregion added-imports
import 'hero_service.dart';
// #enddocregion added-imports

@Component(
  selector: 'hero-detail',
  // #docregion metadata, templateUrl
  templateUrl: 'hero_detail_component.html',
  // #enddocregion metadata, templateUrl, v2
  styleUrls: const ['hero_detail_component.css'],
  directives: const [CORE_DIRECTIVES, formDirectives],
  // #docregion v2
)
// #docregion implement
class HeroDetailComponent implements OnInit {
  // #enddocregion implement
  Hero hero;
  // #docregion ctor
  final HeroService _heroService;
  final RouteParams _routeParams;
  final Location _location;

  HeroDetailComponent(this._heroService, this._routeParams, this._location);
  // #enddocregion ctor

  // #docregion ngOnInit
  Future<Null> ngOnInit() async {
    var _id = _routeParams.get('id');
    var id = int.parse(_id ?? '', onError: (_) => null);
    if (id != null) hero = await (_heroService.getHero(id));
  }
  // #enddocregion ngOnInit

  // #docregion goBack
  void goBack() => _location.back();
  // #enddocregion goBack
}
