import 'package:angular/angular.dart';
// #docregion import, angular_router
import 'package:angular_router/angular_router.dart';
// #enddocregion angular_router

// #docregion routes
import 'src/routes_1.dart';
// #enddocregion import

@Component(
  selector: 'my-app',
  // #enddocregion routes
  // #docregion template, template-and-directives
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
  // #enddocregion template-and-directives
  styles: ['.active-route {color: #039be5}'],
  // #enddocregion template
  // #docregion template-and-directives
  directives: [routerDirectives],
  // #enddocregion template-and-directives
  // #docregion routes
  exports: [RoutePaths, Routes],
)
class AppComponent {}
