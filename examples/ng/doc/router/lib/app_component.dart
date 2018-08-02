import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';
import 'src/hero/hero_service.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>Angular Router</h1>
    <nav>
      <a [routerLink]="RoutePaths.crises.toUrl()"
         [routerLinkActive]="'active-route'">Crisis Center</a>
      <a [routerLink]="RoutePaths.heroes.toUrl()"
         [routerLinkActive]="'active-route'">Heroes</a>
    </nav>
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  styles: ['.active-route {color: #039be5}'],
  directives: [routerDirectives],
  providers: [ClassProvider(HeroService)],
  exports: [RoutePaths, Routes],
)
class AppComponent {}
