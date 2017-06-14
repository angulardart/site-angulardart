// #docregion
// #docregion imports
import 'package:angular2/angular2.dart';

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
  directives: const [CarComponent, HeroesComponent],
  providers: const [
    Logger,
    // #docregion providers
    const Provider(APP_CONFIG, useValue: heroDiConfig),
    // #enddocregion providers
  ],
)
class AppComponent {
  final String title;

  // #docregion ctor
  AppComponent(@Inject(APP_CONFIG) Map config) : title = config['title'];
  // #enddocregion ctor
}
