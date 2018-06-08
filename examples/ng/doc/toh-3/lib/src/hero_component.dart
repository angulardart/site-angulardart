// #docregion v1
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

// #enddocregion v1
// #docregion hero
import 'hero.dart';

// #enddocregion hero
// #docregion v1
@Component(
  selector: 'my-hero',
  // #enddocregion v1
  // #docregion template
  template: '''
    <div *ngIf="hero != null">
      <h2>{{hero.name}}</h2>
      <div><label>id: </label>{{hero.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero.name" placeholder="name">
      </div>
    </div>''',
  // #enddocregion template
  // #docregion v1
  directives: [coreDirectives, formDirectives],
)
// #docregion hero
class HeroComponent {
  // #enddocregion hero, v1
  // #docregion Input-annotation
  @Input()
  // #docregion hero
  Hero hero;
  // #enddocregion Input-annotation
  // #docregion v1
}
