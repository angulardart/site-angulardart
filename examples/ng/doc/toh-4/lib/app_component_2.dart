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
  providers: [ClassProvider(HeroService)],
)
class AppComponent implements OnInit {
  List<Hero> heroes;
  final HeroService _heroService;

  AppComponent(this._heroService);
  // #enddocregion locally-provided-service

  // #docregion _getHeroes
  void _getHeroes() {
    _heroService.getAll().then((heroes) => this.heroes = heroes);
  }
  // #enddocregion _getHeroes

  void ngOnInit() => _getHeroes();
  // #docregion locally-provided-service
}
