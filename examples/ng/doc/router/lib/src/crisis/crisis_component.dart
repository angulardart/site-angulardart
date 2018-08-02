import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../instance_logger.dart';
import 'crisis.dart';
import 'crisis_service.dart';
import 'dialog_service.dart';
import 'route_paths.dart';

@Component(
  selector: 'my-crisis',
  templateUrl: 'crisis_component.html',
  styleUrls: ['crisis_component.css'],
  directives: [coreDirectives, formDirectives],
)
// #docregion CanReuse
class CrisisComponent extends Object
    with CanReuse, InstanceLogger
    implements CanDeactivate, CanNavigate, OnActivate, OnDeactivate {
  // #enddocregion CanReuse
  Crisis crisis;
  String name;
  final CrisisService _crisisService;
  final Router _router;
  final DialogService _dialogService;
  String get loggerPrefix => 'CrisisComponent';

  // #docregion OnActivate-and-OnDeactivate
  CrisisComponent(this._crisisService, this._router, this._dialogService) {
    log('created');
  }
  // #enddocregion OnActivate-and-OnDeactivate

  @override
  // #docregion onActivate, OnActivate-and-OnDeactivate
  void onActivate(_, RouterState current) async {
    // #enddocregion onActivate
    log('onActivate: ${_?.toUrl()} -> ${current?.toUrl()}');
    // #enddocregion OnActivate-and-OnDeactivate
    // #docregion onActivate
    final id = getId(current.parameters);
    if (id == null) return null;
    crisis = await (_crisisService.get(id));
    name = crisis?.name;
    log('onActivate: set name = $name');
    // #docregion OnActivate-and-OnDeactivate
  }
  // #enddocregion onActivate, OnActivate-and-OnDeactivate

  @override
  // #docregion onDeactivate, OnActivate-and-OnDeactivate
  void onDeactivate(RouterState current, _) {
    log('onDeactivate: ${current?.toUrl()} -> ${_?.toUrl()}');
  }
  // #enddocregion onDeactivate, OnActivate-and-OnDeactivate

  // #docregion save
  Future<void> save() async {
    log('save: $name (was ${crisis?.name}');
    crisis?.name = name;
    goBack();
  }
  // #enddocregion save

  // #docregion goBack
  Future<NavigationResult> goBack() =>
      _router.navigate(RoutePaths.home.toUrl());
  // #enddocregion goBack

  @override
  // #docregion canNavigate, OnActivate-and-OnDeactivate
  Future<bool> canNavigate() async {
    log('canNavigate: ${crisis?.name} == $name?');
    return crisis?.name == name ||
        await _dialogService.confirm('Discard changes?');
  }
  // #enddocregion canNavigate, OnActivate-and-OnDeactivate

  @override
  // For illustration purposes only; this method is not used in the component.
  // #docregion canDeactivate
  Future<bool> canDeactivate(RouterState current, RouterState next) async {
    log('canDeactivate: ${current?.toUrl()} -> ${next?.toUrl()}');
    return true;
  }
  // #enddocregion canDeactivate
  // #docregion CanReuse
}
