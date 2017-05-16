// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'crisis.dart';
import 'crisis_service.dart';
import 'crisis_detail_component.dart';
import 'crisis_center_home_component.dart';

@Component(
  selector: 'my-crises',
  templateUrl: 'crises_component.html',
  styleUrls: const ['crises_component.css'],
  directives: const [CORE_DIRECTIVES, ROUTER_DIRECTIVES],
)
// #docregion routes
@RouteConfig(const [
  const Route(
      path: '/',
      name: 'CrisesHome',
      component: CrisisCenterHomeComponent,
      useAsDefault: true),
  const Route(
      path: '/:id', name: 'CrisisDetail', component: CrisisDetailComponent),
])
class CrisesComponent implements OnInit {
  // #enddocregion routes
  final Router _router;
  final RouteParams _routeParams;
  final CrisisService _crisisService;
  List<Crisis> crises;
  Crisis selectedCrisis;

  CrisesComponent(this._crisisService, this._router, this._routeParams);

  Future<Null> getCrises() async {
    crises = await _crisisService.getCrises();
  }

  // #docregion ngOnInit
  Future<Null> ngOnInit() async {
    await getCrises();
    var id = _getId();
    if (id == null) return;
    selectedCrisis =
        crises.firstWhere((crisis) => crisis.id == id, orElse: () => null);
  }

  int _getId() {
    var _id = _routeParams.get('id');
    return int.parse(_id ?? '', onError: (_) => null);
  }
  // #enddocregion ngOnInit

  // #docregion onSelect
  void onSelect(Crisis crisis) {
    selectedCrisis = crisis;
    gotoDetail();
  }

  Future gotoDetail() => _router.navigate([
        'CrisisDetail',
        {'id': selectedCrisis.id.toString()}
      ]);
  // #enddocregion onSelect
  // #docregion routes
}
