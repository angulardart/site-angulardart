import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'heroes_service.dart';

class HeroTaxReturnService {
  final HeroesService _heroService;
  HeroTaxReturn _currentTR, _originalTR;

  HeroTaxReturnService(this._heroService);

  void set taxReturn(HeroTaxReturn htr) {
    _originalTR = htr;
    _currentTR = HeroTaxReturn.copy(htr);
  }

  HeroTaxReturn get taxReturn => _currentTR;

  void restoreTaxReturn() {
    taxReturn = _originalTR;
  }

  Future<void> saveTaxReturn() async {
    taxReturn = _currentTR;
    await _heroService.saveTaxReturn(_currentTR);
  }
}
