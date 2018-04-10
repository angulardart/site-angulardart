import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'logger_service.dart';
import 'peek_a_boo_component.dart';

@Component(
  selector: 'peek-a-boo-parent',
  template: '''
    <div class="parent">
      <h2>Peek-A-Boo</h2>

      <button (click)="toggleChild()">
        {{hasChild ? 'Destroy ' : 'Create '}}PeekABooComponent
      </button>
      <button (click)="updateHero()" [hidden]="!hasChild">Update Hero</button>

      <peek-a-boo *ngIf="hasChild" [name]="heroName">
      </peek-a-boo>

      <h4>-- Lifecycle Hook Log --</h4>
      <div *ngFor="let msg of logs">{{msg}}</div>
    </div>
    ''',
  styles: ['.parent {background: moccasin}'],
  directives: [coreDirectives, formDirectives, PeekABooComponent],
  providers: [LoggerService],
)
class PeekABooParentComponent {
  final LoggerService _logger;
  bool hasChild = false;
  String heroName = 'Windstorm';

  PeekABooParentComponent(this._logger);

  List<String> get logs => _logger.logs;

  toggleChild() {
    hasChild = !hasChild;
    if (hasChild) {
      heroName = 'Windstorm';
      _logger.clear(); // clear log on create
    }
    _logger.tick();
  }

  updateHero() {
    heroName += '!';
    _logger.tick();
  }
}
