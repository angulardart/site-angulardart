// #docplaster
// #docregion
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
// #docregion

import 'src/hero_service.dart';
import 'src/heroes_component.dart';

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <a [routerLink]="['Heroes']">Heroes</a>
    <router-outlet></router-outlet>
  ''',
  // #enddocregion template
  directives: const [ROUTER_DIRECTIVES],
  providers: const [HeroService],
)
@RouteConfig(const [
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
])
class AppComponent {
  final title = 'Tour of Heroes';
}
