// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class AppPO {
  @ByTagName('h1')
  PageLoaderElement _h1;

  @ByCss('nav a')
  List<PageLoaderElement> _tabLinks;

  Future<String> get pageTitle => _h1.visibleText;

  Iterable<Future<String>> get tabTitles =>
      _tabLinks.map((el) => el.visibleText);
}
