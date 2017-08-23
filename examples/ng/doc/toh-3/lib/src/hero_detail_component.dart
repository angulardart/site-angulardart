// #docplaster
// #docregion
// #docregion v1
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

// #enddocregion v1
// #docregion hero-import
import 'hero.dart';
// #enddocregion hero-import

// #docregion v1
@Component(
  selector: 'hero-detail',
  // #enddocregion v1
  // #docregion template
  template: '''
    <div *ngIf="hero != null">
      <h2>{{hero.name}} details!</h2>
      <div><label>id: </label>{{hero.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero.name" placeholder="name">
      </div>
    </div>''',
  // #enddocregion template
  // #docregion v1
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class HeroDetailComponent {
  // #enddocregion v1
  // #docregion inputs
  @Input()
  // #docregion hero
  Hero hero;
  // #enddocregion hero, inputs
  // #docregion v1
}
