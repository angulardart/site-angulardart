// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'hero-detail',
  templateUrl: 'hero_detail_component.html',
  styleUrls: const ['hero_detail_component.css'],
  directives: const [COMMON_DIRECTIVES],
)
class HeroDetailComponent implements OnInit {
  Hero hero;
  final HeroService _heroService;
  final Router _router;
  final RouteParams _routeParams;

  HeroDetailComponent(this._heroService, this._router, this._routeParams);

  // #docregion ngOnInit
  Future<Null> ngOnInit() async {
    var _id = _routeParams.get('id');
    var id = int.parse(_id ?? '', onError: (_) => null);
    if (id != null) hero = await (_heroService.getHero(id));
  }
  // #enddocregion ngOnInit

  // #docregion goBack
  Future goBack() => _router.navigate([
        'Heroes',
        hero == null ? {} : {'id': hero.id.toString()}
      ]);
  // #enddocregion goBack
}
