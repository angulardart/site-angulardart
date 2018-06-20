import 'package:angular/angular.dart';

import 'src/hero_service.dart';
import 'src/hero_list_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <my-heroes></my-heroes>
  ''',
  directives: [HeroListComponent],
  providers: [ClassProvider(HeroService)],
)
class AppComponent {
  final title = 'Tour of Heroes';
}
