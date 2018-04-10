// #docregion
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../route_paths.dart' as paths;
import 'crisis.dart';
import 'crisis_service.dart';

@Component(
  selector: 'my-crisis',
  templateUrl: 'crisis_component_3.html',
  styleUrls: ['crisis_component.css'],
  directives: [coreDirectives, formDirectives],
)
class CrisisComponent implements OnActivate {
  Crisis crisis;
  final CrisisService _crisisService;
  final Router _router;

  CrisisComponent(this._crisisService, this._router);

  @override
  Future<void> onActivate(_, RouterState current) async {
    final id = _getId(current);
    if (id != null) crisis = await (_crisisService.get(id));
  }

  int _getId(RouterState routerState) => int
      .parse(routerState.parameters[paths.idParam] ?? '', onError: (_) => null);

  // #docregion goBack
  Future<NavigationResult> goBack() => _router.navigate(
      paths.heroes.toUrl(),
      new NavigationParams(
          queryParameters: {paths.idParam: crisis.id.toString()}));
  // #enddocregion goBack
}
