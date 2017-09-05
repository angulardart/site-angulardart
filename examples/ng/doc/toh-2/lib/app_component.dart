// #docregion
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  final int id;
  String name;

  Hero(this.id, this.name);
}

// #docregion hero-array
final mockHeroes = <Hero>[
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
// #enddocregion hero-array

// #docregion directives, styleUrls
@Component(
  selector: 'my-app',
  // #enddocregion directives, styleUrls
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
    <div *ngIf="selectedHero != null">
      <h2>{{selectedHero.name}} details!</h2>
      <div><label>id: </label>{{selectedHero.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="selectedHero.name" placeholder="name"/>
      </div>
    </div>
  ''',
  /*
  // #docregion styles
  // Not recommended when adding many CSS classes:
  styles: const [
    '''
      .selected { ... }
      .heroes { ... }
      ...
    '''
  ],
  // #enddocregion styles
  */
  // #docregion styleUrls
  styleUrls: const ['app_component.css'],
  // #docregion directives
  directives: const [CORE_DIRECTIVES, formDirectives],
)
// #enddocregion directives, styleUrls
class AppComponent {
  final title = 'Tour of Heroes';
  // #docregion heroes
  final List<Hero> heroes = mockHeroes;
  // #enddocregion heroes
  // #docregion selected-hero
  Hero selectedHero;
  // #enddocregion selected-hero

  // #docregion on-select
  void onSelect(Hero hero) {
    selectedHero = hero;
  }
  // #enddocregion on-select
}
