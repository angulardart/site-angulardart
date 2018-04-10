import 'dart:async';
import 'package:angular/angular.dart';

import 'hero.dart';

@Injectable()
class HeroesService {
  static final List<Hero> _mockHeroes = <Hero>[
    new Hero(16, 'RubberMan', '082-27-5678'),
    new Hero(20, 'Tornado', '099-42-4321')
  ];

  static final List<HeroTaxReturn> _mockTaxReturns = <HeroTaxReturn>[
    new HeroTaxReturn(10, _mockHeroes[0], 35000),
    new HeroTaxReturn(20, _mockHeroes[1], 1250000)
  ];

  Future<List<Hero>> getAll() async => _mockHeroes;

  Future<HeroTaxReturn> getTaxReturn(Hero hero) async {
    HeroTaxReturn r = _mockTaxReturns.firstWhere((r) => r.hero.id == hero.id,
        orElse: () => null);
    return r ?? new HeroTaxReturn(null, hero);
  }

  Future<HeroTaxReturn> saveTaxReturn(HeroTaxReturn r) async {
    HeroTaxReturn result =
        _mockTaxReturns.firstWhere((_r) => _r.id == r.id, orElse: () => null);
    if (result == null) {
      result = r;
      _mockTaxReturns.add(result);
    } else {
      result.income = r.income; // demo: mutate in-place
    }
    return result;
  }
}
