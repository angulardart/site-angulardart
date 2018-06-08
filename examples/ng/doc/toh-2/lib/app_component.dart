import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

// #docregion hero-import
import 'src/hero.dart';
// #enddocregion hero-import
// #docregion heroes
import 'src/mock_heroes.dart';

// #enddocregion heroes
// #docregion directives, styleUrls, templateUrl
@Component(
  selector: 'my-app',
  // #enddocregion directives, styleUrls
  templateUrl: 'app_component.html',
  // #enddocregion templateUrl
  // #docregion styleUrls
  styleUrls: ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion directives
  directives: [coreDirectives, formDirectives],
  // #docregion styleUrls, templateUrl
)
// #enddocregion directives, styleUrls, templateUrl
// #docregion heroes
class AppComponent {
  final title = 'Tour of Heroes';
  List<Hero> heroes = mockHeroes;
  // #enddocregion heroes
  // #docregion selected
  Hero selected;
  // #enddocregion selected

  // #docregion onSelect
  void onSelect(Hero hero) => selected = hero;
  // #enddocregion onSelect
  // #docregion heroes
}
