import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'crisis.dart';
import 'crisis_service.dart';
import 'dialog_service.dart';
// #docregion routes
import 'route_paths.dart' as paths;
import 'routes.dart';

@Component(
  selector: 'my-crises',
  // #enddocregion routes
  templateUrl: 'crisis_list_component.html',
  styleUrls: ['crisis_list_component.css'],
  // #docregion routes
  directives: [coreDirectives, RouterOutlet],
  // #enddocregion routes
  // #docregion providers
  providers: [
    ClassProvider(CrisisService),
    ClassProvider(DialogService),
    ClassProvider(Routes),
  ],
  // #enddocregion providers
  // #docregion routes
)
class CrisisListComponent implements OnActivate {
  final CrisisService _crisisService;
  final Routes routes;
  final Router _router;
  List<Crisis> crises;
  Crisis selected;

  CrisisListComponent(this._crisisService, this._router, this.routes);
  // #enddocregion routes

  Future<void> _getCrises() async {
    crises = await _crisisService.getAll();
  }

  @override
  void onActivate(_, RouterState current) async {
    await _getCrises();
    selected = _select(current);
  }

  Crisis _select(RouterState routerState) {
    final id = paths.getId(routerState.parameters);
    return id == null
        ? null
        : crises.firstWhere((e) => e.id == id, orElse: () => null);
  }

  // #docregion onSelect, onSelect-_gotoDetail
  void onSelect(Crisis crises) => _gotoDetail(crises.id);
  // #enddocregion onSelect, onSelect-_gotoDetail

  String _crisisUrl(int id) =>
      paths.crisis.toUrl(parameters: {paths.idParam: id.toString()});

  // #docregion _gotoDetail, onSelect-_gotoDetail
  Future<NavigationResult> _gotoDetail(int id) =>
      _router.navigate(_crisisUrl(id));
  // #enddocregion _gotoDetail, onSelect-_gotoDetail
  // #docregion routes
}
