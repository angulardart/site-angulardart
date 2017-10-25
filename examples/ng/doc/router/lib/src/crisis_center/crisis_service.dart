import 'dart:async';

import 'package:angular/angular.dart';

import 'crisis.dart';
import 'mock_crises.dart';

@Injectable()
class CrisisService {
  Future<List<Crisis>> getCrises() async => mockCrises;

  Future<List<Crisis>> getCrisesSlowly() {
    return new Future<List<Crisis>>.delayed(
        const Duration(seconds: 2), getCrises);
  }

  Future<Crisis> getCrisis(int id) async =>
      (await getCrises()).firstWhere((crisis) => crisis.id == id);
}
