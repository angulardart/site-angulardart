import 'package:angular/angular.dart';
import 'hero.dart';

// #docregion stylesheet-link
@Component(
  selector: 'hero-team',
  template: '''
      <h3>Team</h3>
      <ul>
        <li *ngFor="let member of hero.team">
          {{member}}
        </li>
      </ul>''',
  styleUrls: ['hero_team_component.css'],
  directives: [coreDirectives],
)
class HeroTeamComponent {
  @Input()
  Hero hero;
}
