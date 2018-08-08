import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import 'src/hero.dart';
import 'src/unless_directive.dart';
import 'src/hero_switch_components.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    heroSwitchComponents,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    UnlessDirective
  ],
  providers: [materialProviders],
)
class AppComponent {
  final List<Hero> heroes = mockHeroes;
  Hero hero;
  bool condition = false;
  final List<String> logs = [];
  bool showSad = true;
  String status = 'ready';

  AppComponent() {
    hero = heroes[0];
  }

  // #docregion trackByHeroId
  Object trackByHeroId(_, dynamic o) => o is Hero ? o.id : o;
  // #enddocregion trackByHeroId
}
