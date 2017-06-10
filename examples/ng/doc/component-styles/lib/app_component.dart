import 'package:angular2/angular2.dart';
import 'src/hero.dart';
import 'src/hero_app_main_component.dart';

// #docregion
@Component(
    selector: 'hero-app',
    template: '''
      <h1>Tour of Heroes</h1>
      <hero-app-main [hero]="hero"></hero-app-main>''',
    styles: const ['h1 { font-weight: normal; }'],
    directives: const [HeroAppMainComponent])
class AppComponent {
// #enddocregion
  Hero hero =
      new Hero('Human Torch', ['Mister Fantastic', 'Invisible Woman', 'Thing']);

  @HostBinding('class')
  String get themeClass => 'theme-light';
// #docregion
}
