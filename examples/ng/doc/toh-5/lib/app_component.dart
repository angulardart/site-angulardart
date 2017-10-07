// #docplaster
// #docregion
import 'package:angular/angular.dart';
// #docregion router-import
import 'package:angular_router/angular_router.dart';
// #enddocregion router-import

import 'src/dashboard_component.dart';
// #docregion hero-detail-import
import 'src/hero_detail_component.dart';
// #enddocregion hero-detail-import
import 'src/hero_service.dart';
import 'src/heroes_component.dart';

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <nav>
      <a [routerLink]="['Dashboard']">Dashboard</a>
      <a [routerLink]="['Heroes']">Heroes</a>
    </nav>
    <router-outlet></router-outlet>
  ''',
  // #enddocregion template
  // #docregion styleUrls
  styleUrls: const ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion directives
  directives: const [ROUTER_DIRECTIVES],
  // #enddocregion directives
  providers: const [HeroService],
)
// #docregion Heroes-route, routes
@RouteConfig(const [
  // #enddocregion Heroes-route
  // #docregion Redirect-route
  const Redirect(path: '/', redirectTo: const ['Dashboard']),
  // #enddocregion Redirect-route
  // #docregion Dashboard-route
  const Route(
    path: '/dashboard',
    name: 'Dashboard',
    component: DashboardComponent,
  ),
  // #enddocregion Dashboard-route
  // #docregion HeroDetail-route
  const Route(
    path: '/detail/:id',
    name: 'HeroDetail',
    component: HeroDetailComponent,
  ),
  // #enddocregion HeroDetail-route
  // #docregion Heroes-route
  const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
])
// #enddocregion Heroes-route, routes
class AppComponent {
  final title = 'Tour of Heroes';
}
