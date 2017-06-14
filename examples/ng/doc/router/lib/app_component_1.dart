// #docregion
import 'package:angular2/angular2.dart';
// #docregion import
import 'package:angular2/router.dart';
// #enddocregion import

import 'src/crisis_center_component_1.dart';
import 'src/heroes_component_1.dart';

// #docregion app-component-routes
@Component(
  selector: 'my-app',
  // #enddocregion app-component-routes
  // #docregion template
  template: '''
    <h1>Angular Router</h1>
    <nav>
      // #docregion CrisisCenter-link
      <a [routerLink]="['CrisisCenter']">Crisis Center</a>
      // #enddocregion CrisisCenter-link
      // #docregion Heroes-link
      <a [routerLink]="['Heroes']">Heroes</a>
      // #enddocregion Heroes-link
    </nav>
    <router-outlet></router-outlet>
  ''',
  styles: const ['.router-link-active {color: #039be5;}'],
  // #enddocregion template
  directives: const [ROUTER_DIRECTIVES],
  providers: const [ROUTER_PROVIDERS],
  // #docregion app-component-routes
)
// #docregion routes
@RouteConfig(const [
  const Route(
      path: '/crisis-center',
      name: 'CrisisCenter',
      component: CrisisCenterComponent),
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
])
class AppComponent {}
