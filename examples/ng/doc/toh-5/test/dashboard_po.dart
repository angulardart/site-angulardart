import 'dart:async';

import 'package:pageloader/objects.dart';
import 'utils.dart';

class DashboardPO {
  @FirstByCss('h3')
  PageLoaderElement _title;

  @ByTagName('a')
  List<PageLoaderElement> _heroes;

  Future<String> get title => _title.visibleText;

  Future<List<String>> get heroNames =>
      inIndexOrder(_heroes.map((el) => el.visibleText)).toList();

  Future selectHero(int index) => _heroes[index].click();
}
