import 'package:angular/angular.dart';
// #docregion router-import
import 'package:angular_router/angular_router.dart';
// #enddocregion router-import

// #docregion routes-and-template
import 'src/routes.dart';
// #enddocregion routes-and-template
import 'src/hero_service.dart';

// #docregion routes-and-template
@Component(
  // #enddocregion routes-and-template
  selector: 'my-app',
  // #docregion template, routes-and-template
  template: '''
    <!-- #enddocregion routes-and-template -->
    <h1>{{title}}</h1>
    <nav>
      <a [routerLink]="RoutePaths.dashboard.toUrl()"
         [routerLinkActive]="'active'">Dashboard</a>
      <a [routerLink]="RoutePaths.heroes.toUrl()"
         [routerLinkActive]="'active'">Heroes</a>
    </nav>
    <!-- #docregion routes-and-template --> 
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  // #enddocregion template, routes-and-template
  // #docregion styleUrls
  styleUrls: ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion routes-and-template
  directives: [routerDirectives],
  providers: [ClassProvider(HeroService)],
  exports: [RoutePaths, Routes],
)
class AppComponent {
  final title = 'Tour of Heroes';
}
