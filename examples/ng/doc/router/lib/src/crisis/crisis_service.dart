import 'dart:async';

import 'crisis.dart';
import 'mock_crises.dart';

class CrisisService {
  Future<List<Crisis>> getAll() async => mockCrises;

  Future<Crisis> get(int id) async =>
      (await getAll()).firstWhere((crisis) => crisis.id == id);
}
