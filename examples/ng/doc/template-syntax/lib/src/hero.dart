// #docregion
class Hero {
  static int _nextId = 0;

  static final List<Hero> mockHeroes = [
    new Hero(null, 'Hercules', 'happy', new DateTime(1970, 1, 25),
        'http://www.imdb.com/title/tt0065832/', 325),
    new Hero(null, 'Mr. Nice', 'happy'),
    new Hero(null, 'Narco', 'sad'),
    new Hero(null, 'Windstorm', 'confused'),
    new Hero(null, 'Magneta')
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
      new Hero(h.id, h.name, h.emotion, h.birthdate, h.url, h.rate);

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
