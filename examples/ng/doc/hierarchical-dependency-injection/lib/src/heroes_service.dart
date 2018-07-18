import 'dart:async';

import 'hero.dart';

class HeroesService {
  static final List<Hero> _mockHeroes = <Hero>[
    Hero(16, 'RubberMan', '082-27-5678'),
    Hero(20, 'Tornado', '099-42-4321')
  ];

  static final List<HeroTaxReturn> _mockTaxReturns = <HeroTaxReturn>[
    HeroTaxReturn(10, _mockHeroes[0], 35000),
    HeroTaxReturn(20, _mockHeroes[1], 1250000)
  ];

  Future<List<Hero>> getAll() async => _mockHeroes;

  Future<HeroTaxReturn> getTaxReturn(Hero hero) async {
    HeroTaxReturn r = _mockTaxReturns.firstWhere((r) => r.hero.id == hero.id,
        orElse: () => null);
    return r ?? HeroTaxReturn(null, hero);
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
