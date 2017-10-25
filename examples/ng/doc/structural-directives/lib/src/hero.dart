class Hero {
  final int id;
  String name;
  /*@nullable*/ String emotion;

  Hero(this.id, this.name, [this.emotion]);

  @override
  String toString() => '$name';
}

final List<Hero> mockHeroes = <Hero>[
  new Hero(1, 'Mr. Nice', 'happy'),
  new Hero(2, 'Narco', 'sad'),
  new Hero(3, 'Windstorm', 'confused'),
  new Hero(4, 'Magneta')
];
