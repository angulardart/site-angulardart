class Hero {
  final String name;
  final bool canFly;

  const Hero(this.name, this.canFly);

  String toString() => "$name (${canFly ? 'can fly' : 'doesn\'t fly'})";
}

const List<Hero> mockHeroes = <Hero>[
  Hero("Windstorm", true),
  Hero("Bombasto", false),
  Hero("Magneto", false),
  Hero("Tornado", true),
];
