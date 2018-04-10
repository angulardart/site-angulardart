import 'dart:async';

import 'package:pageloader/objects.dart';
import 'utils.dart';

class DashboardPO extends PageObjectBase {
  @FirstByCss('h3')
  PageLoaderElement get _title => q('h3');

  @ByTagName('a')
  List<PageLoaderElement> get _heroes => qq('a');

  Future<String> get title => _title.visibleText;

  Future<List<String>> get heroNames =>
      inIndexOrder(_heroes.map((el) => el.visibleText)).toList();

  Future selectHero(int index) => _heroes[index].click();
}
