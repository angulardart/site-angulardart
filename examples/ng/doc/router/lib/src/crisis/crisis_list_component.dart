import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../instance_logger.dart';
import 'crisis.dart';
import 'crisis_service.dart';
import 'dialog_service.dart';
// #docregion routes
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
  ],
  // #enddocregion providers
  // #docregion routes
  exports: [RoutePaths, Routes],
)
// #docregion CanReuse
class CrisisListComponent extends Object
    with CanReuse, InstanceLogger
    implements OnActivate, OnDeactivate {
  // #enddocregion CanReuse
  final CrisisService _crisisService;
  final Router _router;
  List<Crisis> crises;
  Crisis selected;
  String get loggerPrefix => null; // 'CrisisListComponent';

  CrisisListComponent(this._crisisService, this._router) {
    log('created');
  }
  // #enddocregion routes

  Future<void> _getCrises() async {
    crises = await _crisisService.getAll();
  }

  @override
  void onActivate(_, RouterState current) async {
    log('onActivate: ${_?.toUrl()} -> ${current?.toUrl()}; '
        'selected.id = ${selected?.id}');
    await _getCrises();
    selected = _selectHero(current);
    log('onActivate: set selected.id = ${selected?.id}');
  }

  @override
  void onDeactivate(RouterState current, RouterState next) {
    log('onDeactivate: ${current?.toUrl()} -> ${next?.toUrl()}');
  }

  // #docregion _select
  Crisis _selectHero(RouterState routerState) {
    final id = getId(routerState.parameters);
    return id == null
        ? null
        : crises.firstWhere((e) => e.id == id, orElse: () => null);
  }
  // #enddocregion _select

  // #docregion onSelect
  void onSelect(Crisis crisis) async {
    log('onSelect requested for id = ${crisis?.id}');
    final result = await _gotoDetail(crisis.id);
    if (result == NavigationResult.SUCCESS) {
      selected = crisis;
    }
    log('onSelect _gotoDetail navigation $result; '
        'selected.id = ${selected?.id}');
  }
  // #enddocregion onSelect

  String _crisisUrl(int id) =>
      RoutePaths.crisis.toUrl(parameters: {idParam: '$id'});

  // #docregion gotoDetail
  Future<NavigationResult> _gotoDetail(int id) =>
      _router.navigate(_crisisUrl(id));
  // #enddocregion gotoDetail
  // #docregion CanReuse, routes
}
