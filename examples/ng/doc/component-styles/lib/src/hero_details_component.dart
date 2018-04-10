import 'package:angular/angular.dart';
import 'hero.dart';
import 'hero_team_component.dart';

// #docregion styleUrls
@Component(
    selector: 'hero-details',
    template: '''
      <h2>{{hero.name}}</h2>
      <hero-team [hero]="hero"></hero-team>
      <ng-content></ng-content>''',
    styleUrls: ['hero_details_component.css'],
    directives: [HeroTeamComponent])
class HeroDetailsComponent {
  // #enddocregion styleUrls
  @Input()
  Hero hero;
  // #docregion styleUrls
}
