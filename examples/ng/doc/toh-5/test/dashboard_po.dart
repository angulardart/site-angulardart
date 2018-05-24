import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'dashboard_po.g.dart';

@PageObject()
abstract class DashboardPO {
  DashboardPO();
  factory DashboardPO.create(PageLoaderElement context) = $DashboardPO.create;

  @First(ByCss('h3'))
  PageLoaderElement get _title;

  @ByTagName('a')
  List<PageLoaderElement> get _heroes;

  String get title => _title.visibleText;

  Iterable<String> get heroNames => _heroes.map((el) => el.visibleText);

  Future<void> selectHero(int index) => _heroes[index].click();
}
