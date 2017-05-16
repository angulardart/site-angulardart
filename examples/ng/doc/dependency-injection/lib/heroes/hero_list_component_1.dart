// #docregion
import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Component(
  selector: 'hero-list',
  template: '''
    <div *ngFor="let hero of heroes">
      {{hero.id}} - {{hero.name}}
    </div>''',
  directives: const [CORE_DIRECTIVES],
)
class HeroListComponent {
  final List<Hero> heroes = HEROES;
}
