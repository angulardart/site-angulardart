// #docregion
// #docplaster
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'crisis_center_component_1.dart';
import 'heroes_component_1.dart';
import 'not_found_component.dart';

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
    directives: const [ROUTER_DIRECTIVES],
    providers: const [ROUTER_PROVIDERS])
@RouteConfig(const [
  // #docregion Redirect
  const Redirect(path: '/', redirectTo: const ['Heroes']),
  // #enddocregion Redirect
  const Route(
      path: '/crisis-center',
      name: 'CrisisCenter',
      component: CrisisCenterComponent
  ),
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
