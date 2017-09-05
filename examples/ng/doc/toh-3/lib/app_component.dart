// #docregion
import 'package:angular/angular.dart';

// #docregion hero-import
import 'src/hero.dart';
// #enddocregion hero-import
// #docregion hero-detail-import
import 'src/hero_detail_component.dart';
// #enddocregion hero-detail-import

final List<Hero> mockHeroes = [
  new Hero(11, 'Mr. Nice'),
  new Hero(12, 'Narco'),
  new Hero(13, 'Bombasto'),
  new Hero(14, 'Celeritas'),
  new Hero(15, 'Magneta'),
  new Hero(16, 'RubberMan'),
  new Hero(17, 'Dynama'),
  new Hero(18, 'Dr IQ'),
  new Hero(19, 'Magma'),
  new Hero(20, 'Tornado')
];

@Component(
  selector: 'my-app',
  // #docregion hero-detail-template, template
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
  // #enddocregion hero-detail-template, template
  styleUrls: const ['app_component.css'],
  // #docregion directives
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
  // #enddocregion directives
)
class AppComponent {
  final title = 'Tour of Heroes';
  final List<Hero> heroes = mockHeroes;
  Hero selectedHero;

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
