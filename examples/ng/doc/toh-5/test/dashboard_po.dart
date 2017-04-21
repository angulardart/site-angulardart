// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class DashboardPO {
  @FirstByCss('h3')
  PageLoaderElement _title;

  @ByTagName('a')
  List<PageLoaderElement> _heroes;

  Future<String> get title => _title.visibleText;

  Stream<String> get heroNames async* {
    for (var el in _heroes) yield await el.visibleText;
  }

  Future clickHero(int index) => _heroes[index].click();
}
