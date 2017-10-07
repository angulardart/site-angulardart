// #docregion
import 'package:angular/angular.dart';

import 'src/hero_service.dart';
import 'src/heroes_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <my-heroes></my-heroes>
  ''',
  directives: const [HeroesComponent],
  providers: const [HeroService],
)
class AppComponent {
  final title = 'Tour of Heroes';
}
