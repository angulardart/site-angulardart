// #docregion imports
import 'dart:async';

import 'package:pageloader/pageloader.dart';
// #enddocregion imports

// #docregion boilerplate
part 'app_po.g.dart';

// #docregion AppPO, AppPO-initial
@PageObject()
// #docregion AppPO-hero
abstract class AppPO {
  // #enddocregion AppPO-hero

  AppPO();
  factory AppPO.create(PageLoaderElement context) = $AppPO.create;
  // #enddocregion boilerplate

  @ByTagName('h1')
  PageLoaderElement get _title;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  @First(ByCss('div'))
  PageLoaderElement get _id; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement get _heroName;
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  @ByTagName('input')
  PageLoaderElement get _input;
  // #enddocregion AppPO-input

  // #docregion AppPO-initial
  String get title => _title.visibleText;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  int get heroId {
    final idAsString = _id.visibleText.split(':')[1];
    return int.tryParse(idAsString) ?? -1;
  }

  String get heroName => _heroName.visibleText;
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  Future<void> type(String s) => _input.type(s);
  // #enddocregion AppPO-input
  // #docregion AppPO-initial, AppPO-hero, boilerplate
}
