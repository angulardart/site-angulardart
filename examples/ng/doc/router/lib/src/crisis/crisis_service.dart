import 'dart:async';

import 'package:angular/angular.dart';

import 'crisis.dart';
import 'mock_crises.dart';

@Injectable()
class CrisisService {
  Future<List<Crisis>> getAll() async => mockCrises;

  Future<Crisis> get(int id) async =>
      (await getAll()).firstWhere((crisis) => crisis.id == id);
}
