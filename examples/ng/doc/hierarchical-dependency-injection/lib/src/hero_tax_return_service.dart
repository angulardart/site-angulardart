// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'heroes_service.dart';

@Injectable()
class HeroTaxReturnService {
  final HeroesService _heroService;
  HeroTaxReturn _currentTR, _originalTR;

  HeroTaxReturnService(this._heroService);

  void set taxReturn(HeroTaxReturn htr) {
    _originalTR = htr;
    _currentTR = new HeroTaxReturn.copy(htr);
  }

  HeroTaxReturn get taxReturn => _currentTR;

  void restoreTaxReturn() {
    taxReturn = _originalTR;
  }

  Future<Null> saveTaxReturn() async {
    taxReturn = _currentTR;
    await _heroService.saveTaxReturn(_currentTR);
  }
}
