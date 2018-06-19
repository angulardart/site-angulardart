class Hero {
  final int id;
  String name;
  /*@nullable*/ String emotion;

  Hero(this.id, this.name, [this.emotion]);

  @override
  String toString() => '$name';
}

final List<Hero> mockHeroes = <Hero>[
  Hero(1, 'Mr. Nice', 'happy'),
  Hero(2, 'Narco', 'sad'),
  Hero(3, 'Windstorm', 'confused'),
  Hero(4, 'Magneta')
];
