class Hero {
  int id;
  String name, power, alterEgo;

  Hero(this.id, this.name, this.power, [this.alterEgo]);

  String toString() => '$id: $name ($alterEgo). Super power: $power';
}
