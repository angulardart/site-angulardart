// #docregion without-routes,
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'crisis_service.dart';
import 'crises_component.dart';

@Component(
    selector: 'crisis-center',
    template: '''
      <router-outlet></router-outlet>
    ''',
    directives: const [ROUTER_DIRECTIVES],
    providers: const [CrisisService])
// #enddocregion without-routes
// #docregion routes
@RouteConfig(const [
  const Route(
      path: '/...',
      name: 'Crises',
      component: CrisesComponent,
      useAsDefault: true)
])
// #docregion without-routes
class CrisisCenterComponent {}
