import 'package:angular_router/angular_router.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

IsNavParams isNavParams([dynamic expected]) => new IsNavParams(expected);

class IsNavParams extends Matcher {
  NavigationParams _expected;
  IsNavParams([NavigationParams expected]) {
    _expected = expected == null ? new NavigationParams() : expected;
  }
  bool matches(item, Map matchState) =>
      item is NavigationParams &&
      _expected.fragment == item.fragment &&
      const MapEquality()
          .equals(_expected.queryParameters, item.queryParameters) &&
      _expected.updateUrl == item.updateUrl;

  Description describe(Description description) => description.add(
      'NavigationParams(${_expected.queryParameters}, ${_expected.fragment}, ${_expected.updateUrl})');
}

IsRouterState isRouterState(dynamic expected) => new IsRouterState(expected);

class IsRouterState extends Matcher {
  RouterState _expected;
  IsRouterState(/*RouterState|String*/ expected) {
    _expected = expected is String ? new RouterState(expected, []) : expected;
  }
  bool matches(item, Map matchState) =>
      item is RouterState &&
      _expected.path == item.path &&
      const MapEquality()
          .equals(_expected.queryParameters, item.queryParameters) &&
      _expected.fragment == item.fragment;

  Description describe(Description description) => description.add(
      'RouterState(${_expected.path}, ..., queryParameters: ${_expected.queryParameters}, fragment: ${_expected.fragment})');
}
