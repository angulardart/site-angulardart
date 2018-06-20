import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_component.dart';
import 'src/hero_service_1.dart';

// Testable but never shown
@Component(
  selector: 'my-app',
  template: '''
    <div *ngFor="let hero of heroes" (click)="onSelect(hero)">
      {{hero.name}}
    </div>
    <my-hero [hero]="selected"></my-hero>
    ''',
  directives: [coreDirectives, HeroComponent],
  // #docregion providers
  providers: [ClassProvider(HeroService)],
// #enddocregion providers
)
// #docregion OnInit-and-ngOnInit
class AppComponent implements OnInit {
  // #enddocregion OnInit-and-ngOnInit
  final title = 'Tour of Heroes';
  // #docregion heroes, heroes-and-getHeroes
  List<Hero> heroes;
  // #enddocregion heroes, heroes-and-getHeroes
  Hero selected;

  // #docregion new-service
  HeroService heroService = HeroService(); // DON'T do this
  // #enddocregion new-service
  // #docregion ctor
  final HeroService _heroService;
  AppComponent(this._heroService);
  // #enddocregion ctor

  // #docregion _getHeroes, heroes-and-getHeroes
  void _getHeroes() {
    // #docregion get-heroes
    heroes = _heroService.getAll();
    // #enddocregion get-heroes
  }
  // #enddocregion _getHeroes, heroes-and-getHeroes

  // #docregion ngOnInit, OnInit-and-ngOnInit
  void ngOnInit() => _getHeroes();
  // #enddocregion ngOnInit, OnInit-and-ngOnInit

  void onSelect(Hero hero) => selected = hero;
  // #docregion OnInit-and-ngOnInit
}
