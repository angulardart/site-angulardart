// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'crisis.dart';
import 'crisis_service.dart';

@Component(
  selector: 'my-crises',
  templateUrl: 'crises_component_3.html',
  styleUrls: const ['crises_component.css'],
  directives: const [CORE_DIRECTIVES],
)
class CrisesComponent implements OnInit {
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
}
