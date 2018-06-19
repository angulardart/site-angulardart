import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_app_main_component.dart';

// #docregion class
@Component(
  selector: 'hero-app',
  template: '''
    <h1>Tour of Heroes</h1>
    <hero-app-main [hero]="hero"></hero-app-main>
  ''',
  styles: ['h1 { font-weight: normal; }'],
  directives: [HeroAppMainComponent],
)
class AppComponent {
  // #enddocregion class
  Hero hero =
      Hero('Human Torch', ['Mister Fantastic', 'Invisible Woman', 'Thing']);

  @HostBinding('class')
  String get themeClass => 'theme-light';
  // #docregion class
}
