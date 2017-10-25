import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'hero.dart';

@Component(
  selector: 'hero-detail',
  template: '''
    <div *ngIf="hero != null">
      <h2>{{hero.name}} details!</h2>
      <div><label>id: </label>{{hero.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero.name" placeholder="name"/>
      </div>
    </div>
  ''',
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class HeroDetailComponent {
  @Input()
  Hero hero;
}
