import 'package:angular2/angular2.dart';
import 'hero.dart';

// #docregion inline-styles
@Component(
    selector: 'hero-controls',
    template: '''
      <style>
        button {
          background-color: white;
          border: 1px solid #777;
        }
      </style>
      <h3>Controls</h3>
      <button (click)="activate()">Activate</button>''')
class HeroControlsComponent {
  @Input()
  Hero hero;

  void activate() {
    hero.active = true;
  }
}
