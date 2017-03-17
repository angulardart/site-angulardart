// #docregion without-routes,
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'crisis_service.dart';
import 'crises_component.dart';

@Component(
    // selector isn't needed, but must be provided
    // https://github.com/dart-lang/angular2/issues/60
    selector: 'my-crisis-center',
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
