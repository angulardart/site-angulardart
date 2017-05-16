// #docregion
import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'hero-list',
  template: '''
    <div *ngFor="let hero of heroes">
      {{hero.id}} - {{hero.name}}
      ({{hero.isSecret ? 'secret' : 'public'}})
    </div>''',
  directives: const [CORE_DIRECTIVES],
)
class HeroListComponent {
  final List<Hero> heroes;

  // #docregion ctor-signature
  HeroListComponent(HeroService heroService)
      // #enddocregion ctor-signature
      : heroes = heroService.getHeroes();
}
