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
class CrisisDetailComponent
    implements
        CanDeactivate,
        CanReuse,
        OnActivate,
        OnDeactivate,
        OnInit,
        OnReuse {
  Crisis crisis;
  String name;
  final CrisisService _crisisService;
  final Router _router;
  final RouteParams _routeParams;
  final DialogService _dialogService;

  CrisisDetailComponent(this._crisisService, this._router, this._routeParams,
      this._dialogService);

  // #docregion ngOnInit
  Future<Null> ngOnInit() => _setCrisis(_routeParams.get('id'));

  Future<Null> _setCrisis(String idAsString) async {
    var id = int.parse(idAsString ?? '', onError: (_) => null);
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

  // #docregion routerCanReuse
  @override
  FutureOr<bool> routerCanReuse(next, prev) => true;
  // #enddocregion routerCanReuse

  // #docregion routerOnReuse
  @override
  Future<Null> routerOnReuse(ComponentInstruction next, prev) =>
      _setCrisis(next.params['id']);
  // #enddocregion routerOnReuse

  // #docregion routerOnActivate, routerOnActivate-and-routerOnDeactivate
  @override
  void routerOnActivate(next, prev) {
    print('Activating ${next.routeName} ${next.urlPath}');
  }
  // #enddocregion routerOnActivate

  // #docregion routerOnDeactivate
  @override
  void routerOnDeactivate(next, prev) {
    print('Deactivating ${prev.routeName} ${prev.urlPath}');
  }
  // #enddocregion routerOnDeactivate, routerOnActivate-and-routerOnDeactivate
}
