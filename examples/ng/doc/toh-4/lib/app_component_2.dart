import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_service.dart';

// #docregion locally-provided-service
@Component(
  selector: 'my-app',
  // #enddocregion locally-provided-service
  template: '...',
  /* ... */
  // #docregion locally-provided-service
  providers: const [HeroService],
)
class AppComponent implements OnInit {
  List<Hero> heroes;
  final HeroService _heroService;

  AppComponent(this._heroService);
  // #enddocregion locally-provided-service

  // #docregion getHeroes
  void getHeroes() {
    _heroService.getHeroes().then((heroes) => this.heroes = heroes);
  }
  // #enddocregion getHeroes

  void ngOnInit() => getHeroes();
  // #docregion locally-provided-service
}
