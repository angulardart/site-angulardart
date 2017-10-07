// #docplaster
// #docregion
import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_detail_component.dart';
import 'src/hero_service_1.dart';

// Testable but never shown
@Component(
  selector: 'my-app',
  template: '''
    <div *ngFor="let hero of heroes" (click)="onSelect(hero)">
      {{hero.name}}
    </div>
    <hero-detail [hero]="selectedHero"></hero-detail>
    ''',
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
  // #docregion providers
  providers: const [HeroService],
// #enddocregion providers
)
// #docregion OnInit-and-ngOnInit
class AppComponent implements OnInit {
  // #enddocregion OnInit-and-ngOnInit
  final title = 'Tour of Heroes';
  // #docregion heroes, heroes-and-getHeroes
  List<Hero> heroes;
  // #enddocregion heroes, heroes-and-getHeroes
  Hero selectedHero;

  // #docregion new-service
  HeroService heroService = new HeroService(); // DON'T do this
  // #enddocregion new-service
  // #docregion ctor
  final HeroService _heroService;
  AppComponent(this._heroService);
  // #enddocregion ctor
  // #docregion heroes-and-getHeroes

  // #docregion getHeroes
  void getHeroes() {
    // #docregion get-heroes
    heroes = _heroService.getHeroes();
    // #enddocregion get-heroes
  }
  // #enddocregion getHeroes, heroes-and-getHeroes

  // #docregion ngOnInit, OnInit-and-ngOnInit
  void ngOnInit() => getHeroes();
  // #enddocregion ngOnInit, OnInit-and-ngOnInit

  void onSelect(Hero hero) => selectedHero = hero;
  // #docregion OnInit-and-ngOnInit
}
