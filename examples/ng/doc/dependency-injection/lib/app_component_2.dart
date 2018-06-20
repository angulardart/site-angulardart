// #docregion imports
import 'package:angular/angular.dart';

import 'src/app_config.dart';
import 'src/car/car_component.dart';
import 'src/heroes/heroes_component_1.dart';
import 'src/logger_service.dart';
// #enddocregion imports

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <my-car></my-car>
    <my-heroes></my-heroes>
  ''',
  directives: [CarComponent, HeroesComponent],
  providers: [
    ClassProvider(Logger),
    // #docregion providers
    ValueProvider.forToken(appTitleToken, appTitle),
    // #enddocregion providers
  ],
)
class AppComponent {
  final String title;

  // #docregion inject-appTitleToken
  AppComponent(@Inject(appTitleToken) this.title);
  // #enddocregion inject-appTitleToken

  // #docregion appTitleToken
  AppComponent._(@appTitleToken this.title);
  // #enddocregion appTitleToken
}
