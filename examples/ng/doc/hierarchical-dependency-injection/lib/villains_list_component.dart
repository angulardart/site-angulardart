// #docregion
import 'dart:async';
import 'package:angular2/angular2.dart';

import 'villains_service.dart';

// #docregion metadata
@Component(
  selector: 'villains-list',
  template: '''
      <div>
        <h3>Villains</h3>
        <ul>
          <li *ngFor="let villain of villains | async">{{villain.name}}</li>
        </ul>
      </div>
    ''',
  directives: const [CORE_DIRECTIVES],
  providers: const [VillainsService],
  pipes: const [COMMON_PIPES],
)
// #enddocregion metadata
class VillainsListComponent {
  final VillainsService _villainsService;

  Future<List<Villain>> villains;

  VillainsListComponent(this._villainsService) {
    villains = _villainsService.getVillains();
  }
}
