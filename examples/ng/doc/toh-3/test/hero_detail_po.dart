import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'hero_detail_po.g.dart';

@PageObject()
abstract class HeroDetailPO {
  HeroDetailPO();
  factory HeroDetailPO.create(PageLoaderElement context) = $HeroDetailPO.create;

  @First(ByCss('div h2'))
  PageLoaderElement get _title;

  @First(ByCss('div div'))
  PageLoaderElement get _id;

  @ByTagName('input')
  PageLoaderElement get _input;

  Map get heroFromDetails {
    if (!_id.exists) return null;
    final idAsString = _id.visibleText.split(':')[1];
    return _heroData(idAsString, _title.visibleText);
  }

  Future<void> clear() => _input.clear();
  Future<void> type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.tryParse(idAsString) ?? -1, 'name': name};
}
