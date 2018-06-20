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
    <h1>{{title}}</h1>
    <nav>
      <a [routerLink]="routes.dashboard.toUrl()"
         routerLinkActive="active">Dashboard</a>
      <a [routerLink]="routes.heroes.toUrl()"
         routerLinkActive="active">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
  // #enddocregion template, routes-and-template
  // #docregion styleUrls
  styleUrls: ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion directives
  directives: [routerDirectives],
  // #enddocregion directives
  // #docregion routes-and-template
  providers: [
    ClassProvider(HeroService),
    ClassProvider(Routes),
  ],
)
class AppComponent {
  final title = 'Tour of Heroes';
  final Routes routes;

  AppComponent(this.routes);
}
