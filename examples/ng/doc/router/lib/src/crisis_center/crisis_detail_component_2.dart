// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'crisis.dart';
import 'crisis_service.dart';
import 'dialog_service.dart';

@Component(
  selector: 'crisis-detail',
  templateUrl: 'crisis_detail_component.html',
  styleUrls: const ['crisis_detail_component.css'],
  directives: const [COMMON_DIRECTIVES],
)
class CrisisDetailComponent implements CanDeactivate, OnInit {
  Crisis crisis;
  String name;
  final CrisisService _crisisService;
  final Router _router;
  final RouteParams _routeParams;
  final DialogService _dialogService;

  CrisisDetailComponent(this._crisisService, this._router, this._routeParams,
      this._dialogService);

  // #docregion ngOnInit
  Future<Null> ngOnInit() async {
    var _id = _routeParams.get('id');
    var id = int.parse(_id ?? '', onError: (_) => null);
    if (id != null) crisis = await (_crisisService.getCrisis(id));
    if (crisis != null) name = crisis.name;
  }
  // #enddocregion ngOnInit

  // #docregion save
  Future<Null> save() async {
    crisis.name = name;
    goBack();
  }
  // #enddocregion save

  // #docregion goBack
  Future goBack() => _router.navigate([
        'CrisesHome',
        crisis == null ? {} : {'id': crisis.id.toString()}
      ]);
  // #enddocregion goBack

  // TODO: remove cast of true once there is a fix for https://github.com/dart-lang/sdk/issues/25368
  // #docregion routerCanDeactivate
  @override
  FutureOr<bool> routerCanDeactivate(next, prev) =>
      crisis == null || crisis.name == name
          ? true as FutureOr<bool>
          : _dialogService.confirm('Discard changes?');
  // #enddocregion routerCanDeactivate
}
