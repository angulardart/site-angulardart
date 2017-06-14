// #docregion
// #docplaster
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'src/crisis_center_component_1.dart';
import 'src/heroes_component_1.dart';
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
  providers: const [ROUTER_PROVIDERS],
)
@RouteConfig(const [
  // #docregion Redirect
  const Redirect(path: '/', redirectTo: const ['Heroes']),
  const Redirect(path: '/index.html', redirectTo: const ['Heroes']),
  // #enddocregion Redirect
  const Route(
      path: '/crisis-center',
      name: 'CrisisCenter',
      component: CrisisCenterComponent),
  // #enddocregion ,
  /*
  // #docregion Route.useAsDefault
  const Route(
      path: '/heroes',
      name: 'Heroes',
      component: HeroesComponent,
      useAsDefault: true),
  // #enddocregion Route.useAsDefault
  */
  // #docregion ,
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent),
  // #docregion wildcard
  const Route(path: '/**', name: 'NotFound', component: NotFoundComponent)
  // #enddocregion wildcard
])
class AppComponent {}
