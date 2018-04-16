// #docregion
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
      <a [routerLink]="routes.crises.path"
         routerLinkActive="active-route">Crisis Center</a>
      <a [routerLink]="routes.heroes.path"
         routerLinkActive="active-route">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
  // #enddocregion template-and-directives
  styles: ['.active-route {color: #039be5;}'],
  // #enddocregion template
  // #docregion template-and-directives
  directives: [routerDirectives],
  // #enddocregion template-and-directives
  providers: [const ClassProvider(Routes)],
  // #docregion routes
)
class AppComponent {
  final Routes routes;

  AppComponent(this.routes);
}
