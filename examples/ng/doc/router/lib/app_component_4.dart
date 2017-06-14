// #docregion
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

// Not yet used: import 'compose_message_component.dart';
import 'src/crisis_center/crisis_center_component.dart';
import 'src/heroes/hero_detail_component.dart';
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
      <!--
      // #docregion dragon-crisis
      <a [routerLink]="['CrisisCenter', 'Crises', 'CrisisDetail', {'id': '1'}]">Dragon Crisis</a>
      // #enddocregion dragon-crisis
      -->
    </nav>
    <router-outlet></router-outlet>
    <!-- Note: the named outlet is not yet used:
    // #docregion outlets
    <router-outlet></router-outlet>
    <router-outlet name="popup"></router-outlet>
    // #enddocregion outlets
    -->
  ''',
  styles: const ['.router-link-active {color: #039be5;}'],
  directives: const [ROUTER_DIRECTIVES],
  providers: const [HeroService, ROUTER_PROVIDERS],
)
// #docregion routes
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Heroes']),
  const Redirect(path: '/index.html', redirectTo: const ['Heroes']),
  const Route(
      // #docregion crisis-center-path
      path: '/crisis-center/...',
      // #enddocregion crisis-center-path
      name: 'CrisisCenter',
      component: CrisisCenterComponent),
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent),
  const Route(
      path: '/hero/:id', name: 'HeroDetail', component: HeroDetailComponent),
  // Not yet used: const AuxRoute(path: '/contact', name: 'Contact', component: ComposeMessageComponent),
  const Route(path: '/**', name: 'NotFound', component: NotFoundComponent)
])
class AppComponent {}
