import 'package:angular/angular.dart';
import 'hero.dart';

// #docregion inline-styles
@Component(
  selector: 'hero-controls',
  template: '''
    <h3>Controls</h3>
    <button (click)="activate()">Activate</button>
  ''',
)
class HeroControlsComponent {
  @Input()
  Hero hero;

  void activate() {
    hero.active = true;
  }
}
