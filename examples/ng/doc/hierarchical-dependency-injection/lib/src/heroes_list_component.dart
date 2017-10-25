import 'dart:async';
import 'package:angular/angular.dart';

import 'hero.dart';
import 'heroes_service.dart';
import 'hero_tax_return_component.dart';

@Component(
  selector: 'heroes-list',
  template: '''
      <div>
        <h3>Hero Tax Returns</h3>
        <ul>
          <li *ngFor="let hero of heroes | async"
              (click)="showTaxReturn(hero)">{{hero.name}}
          </li>
        </ul>
        <hero-tax-return
          *ngFor="let selected of selectedTaxReturns; let i = index"
          [taxReturn]="selected"
          (close)="closeTaxReturn(i)">
        </hero-tax-return>
      </div>
    ''',
  styles: const ['li {cursor: pointer;}'],
  directives: const [CORE_DIRECTIVES, HeroTaxReturnComponent],
  pipes: const [COMMON_PIPES],
)
class HeroesListComponent {
  final HeroesService _heroesService;

  Future<List<Hero>> heroes;
  final List<HeroTaxReturn> selectedTaxReturns = [];

  HeroesListComponent(this._heroesService) {
    heroes = _heroesService.getHeroes();
  }

  Future<Null> showTaxReturn(Hero hero) async {
    var r = await _heroesService.getTaxReturn(hero);
    if (!selectedTaxReturns.any((_r) => _r.id == r.id)) {
      selectedTaxReturns.add(r);
    }
  }

  void closeTaxReturn(int index) {
    selectedTaxReturns.removeAt(index);
  }
}
