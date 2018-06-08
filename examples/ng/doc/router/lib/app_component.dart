import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';
import 'src/hero/hero_service.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>Angular Router</h1>
    <nav>
      <a [routerLink]="routes.crises.toUrl()"
         routerLinkActive="active-route">Crisis Center</a>
      <a [routerLink]="routes.heroes.toUrl()"
         routerLinkActive="active-route">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
  styles: ['.active-route {color: #039be5}'],
  directives: [routerDirectives],
  providers: [
    const ClassProvider(HeroService),
    const ClassProvider(Routes),
  ],
)
class AppComponent {
  final Routes routes;

  AppComponent(this.routes);
}
