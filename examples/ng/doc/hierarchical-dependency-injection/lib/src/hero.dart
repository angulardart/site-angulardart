class Hero {
  final int id;
  String name, taxId;

  Hero(this.id, this.name, [this.taxId]);

  @override
  String toString() => '$name ($taxId)';
}

class HeroTaxReturn {
  static int _nextId = 100;

  final int id;
  final Hero hero;
  num income;

  HeroTaxReturn(int _id, this.hero, [this.income = 0]) : id = _id ?? _nextId++;

  factory HeroTaxReturn.copy(HeroTaxReturn r) =>
      HeroTaxReturn(r.id, r.hero, r.income);

  String get name => hero.name;
  num get tax => 0.10 * (income ?? 0);
  String get taxId => hero.taxId;

  @override
  String toString() => 'TaxReturn $id for ${hero.name}';
}
