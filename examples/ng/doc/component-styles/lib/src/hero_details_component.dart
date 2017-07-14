import 'package:angular2/angular2.dart';
import 'hero.dart';
import 'hero_team_component.dart';

// #docregion styleUrls
@Component(
    selector: 'hero-details',
    template: '''
      <h2>{{hero.name}}</h2>
      <hero-team [hero]=hero></hero-team>
      <ng-content></ng-content>''',
    styleUrls: const ['hero_details_component.css'],
    directives: const [HeroTeamComponent])
class HeroDetailsComponent {
  // #enddocregion styleUrls
  @Input()
  Hero hero;
  // #docregion styleUrls
}
