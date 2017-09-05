// #docplaster
// #docregion
import 'dart:async';

import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_detail_component.dart';
// #docregion hero-service-import
import 'src/hero_service.dart';
// #enddocregion hero-service-import

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
      <h1>{{title}}</h1>
      <h2>My Heroes</h2>
      <ul class="heroes">
        <li *ngFor="let hero of heroes"
          [class.selected]="hero == selectedHero"
          (click)="onSelect(hero)">
          <span class="badge">{{hero.id}}</span> {{hero.name}}
        </li>
      </ul>
      <hero-detail [hero]="selectedHero"></hero-detail>
    ''',
  // #enddocregion template
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
  providers: const [HeroService],
)
class AppComponent implements OnInit {
  final title = 'Tour of Heroes';
  List<Hero> heroes;
  Hero selectedHero;

  final HeroService _heroService;

  AppComponent(this._heroService);

  // #docregion getHeroes
  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }
  // #enddocregion getHeroes

  void ngOnInit() {
    getHeroes();
  }

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
