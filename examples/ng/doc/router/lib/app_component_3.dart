// #docplaster
// #docregion v1,
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'src/crisis_center_component_1.dart';
// #enddocregion v1
import 'src/heroes/hero_detail_component.dart';
// #docregion v1
import 'src/heroes/hero_service.dart';
import 'src/heroes/heroes_component.dart';
import 'src/not_found_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>Angular Router</h1>
    <nav>
      <a [routerLink]="['CrisisCenter']">Crisis Center</a>
      <a [routerLink]="['Heroes']">Heroes</a>
    </nav>
    <router-outlet></router-outlet>
  ''',
  styles: const ['.router-link-active {color: #039be5;}'],
  directives: const [ROUTER_DIRECTIVES],
  providers: const [HeroService, ROUTER_PROVIDERS],
)
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Heroes']),
  const Redirect(path: '/index.html', redirectTo: const ['Heroes']),
  const Route(
      path: '/crisis-center',
      name: 'CrisisCenter',
      component: CrisisCenterComponent),
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent),
  // #enddocregion v1
  // #docregion HeroDetail-route
  const Route(
      path: '/hero/:id', name: 'HeroDetail', component: HeroDetailComponent),
  // #enddocregion HeroDetail-route
  // #docregion v1
  const Route(path: '/**', name: 'NotFound', component: NotFoundComponent),
])
class AppComponent {}
