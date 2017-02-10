// This is a copy of app_component_4.dart
// #docregion
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

// Not yet used: import 'compose_message_component.dart';
import 'crisis_center/crisis_center_component.dart';
import 'heroes/hero_detail_component.dart';
import 'heroes/hero_service.dart';
import 'heroes/heroes_component.dart';
import 'not_found_component.dart';

@Component(
    selector: 'my-app',
    template: '''
      <h1>Angular Router</h1>
      <nav>
        <a [routerLink]="['CrisisCenter']">Crisis Center</a>
        <a [routerLink]="['Heroes']">Heroes</a>
        <!--
        // #docregion dragon-crisis
        <a [routerLink]="['CrisisCenter', 'CrisisDetail', {'id': '1'}]">Dragon Crisis</a>
        // #enddocregion dragon-crisis
        -->
      </nav>
      // #docregion outlets
      <router-outlet></router-outlet>
      <!-- Not yet used:
      <router-outlet name="popup"></router-outlet>
      -->
      // #enddocregion outlets
    ''',
    directives: const [ROUTER_DIRECTIVES],
    providers: const [HeroService, ROUTER_PROVIDERS])
// #docregion routes
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['Heroes']),
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
