class Hero {
  static int _nextId = 0;

  static final List<Hero> mockHeroes = [
    Hero(null, 'Hercules', 'happy', DateTime(1970, 1, 25),
        'http://www.imdb.com/title/tt0065832/', 325),
    Hero(null, 'Mr. Nice', 'happy'),
    Hero(null, 'Narco', 'sad'),
    Hero(null, 'Windstorm', 'confused'),
    Hero(null, 'Magneta')
  ];

  int id;
  String name;
  String emotion;
  DateTime birthdate;
  String url;
  int rate;

  Hero(int _id,
      [this.name, this.emotion, this.birthdate, this.url, this.rate = 100])
      : this.id = _id ?? _nextId++;

  factory Hero.copy(Hero h) =>
      Hero(h.id, h.name, h.emotion, h.birthdate, h.url, h.rate);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emotion': emotion,
        'birthdate': birthdate.toString(),
        'url': url,
        'rate': rate
      };

  @override
  String toString() => '$name (rate: $rate)';
}
