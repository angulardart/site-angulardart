import 'dart:async';
import 'package:angular/angular.dart';

class Villain {
  final int id;
  String name;

  Villain(this.id, this.name);
}

class VillainsService {
  static final List<Villain> _mockVillains = [
    Villain(1, 'Dr. Evil'),
    Villain(2, 'Moriarty')
  ];

  Future<List<Villain>> getVillains() async => _mockVillains;
}
