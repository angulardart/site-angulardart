import 'package:angular2/angular2.dart';
import 'hero.dart';

// #docregion stylesheet-link
@Component(
  selector: 'hero-team',
  template: '''
      <link rel="stylesheet" href="hero_team_component.css">
      <h3>Team</h3>
      <ul>
        <li *ngFor="let member of hero.team">
          {{member}}
        </li>
      </ul>''',
  directives: const [CORE_DIRECTIVES],
)
class HeroTeamComponent {
  @Input()
  Hero hero;
}
