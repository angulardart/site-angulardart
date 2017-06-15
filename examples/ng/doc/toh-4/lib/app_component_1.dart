// #docplaster
// #docregion on-init
import 'package:angular2/angular2.dart';

// #enddocregion on-init
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
// #docregion on-init
class AppComponent implements OnInit {
  // #enddocregion on-init
  String title = 'Tour of Heroes';
  // #docregion heroes-prop
  List<Hero> heroes;
  // #enddocregion heroes-prop
  Hero selectedHero;

  // #docregion new-service
  HeroService heroService = new HeroService(); // don't do this
  // #enddocregion new-service
  // #docregion ctor
  final HeroService _heroService;
  AppComponent(this._heroService);
  // #enddocregion ctor

  // #docregion getHeroes
  void getHeroes() {
    // #docregion get-heroes
    heroes = _heroService.getHeroes();
    // #enddocregion get-heroes
  }
  // #enddocregion getHeroes

  // #docregion ng-on-init, on-init
  void ngOnInit() {
    // #enddocregion on-init
    getHeroes();
    // #docregion on-init
  }
  // #enddocregion ng-on-init, on-init

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
  // #docregion on-init
}
