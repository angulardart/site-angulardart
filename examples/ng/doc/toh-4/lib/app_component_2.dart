import 'dart:async';

import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-app',
  template: '',
  providers: const [HeroService],
)
class AppComponent {
  List<Hero> heroes;
  final HeroService _heroService;

  AppComponent(this._heroService);

  // #docregion getHeroes
  Future<Null> getHeroes() {
    _heroService.getHeroes().then((heroes) => this.heroes = heroes);
  }
  // #enddocregion getHeroes

}
