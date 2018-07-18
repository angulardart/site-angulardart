import 'package:angular/angular.dart';

import 'hero_list_component.dart';
import 'hero_service_provider.dart';

@Component(
  selector: 'my-heroes',
  template: '''
      <h2>Heroes</h2>
      <hero-list></hero-list>''',
  providers: [heroServiceProvider],
  directives: [HeroListComponent],
)
class HeroesComponent {}
