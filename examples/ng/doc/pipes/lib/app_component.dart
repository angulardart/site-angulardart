import 'package:angular/angular.dart';

import 'src/flying_heroes_component.dart';
import 'src/hero_async_message_component.dart';
import 'src/hero_birthday1_component.dart';
import 'src/hero_birthday2_component.dart';
import 'src/hero_list_component.dart';
import 'src/power_boost_calculator_component.dart';
import 'src/power_booster_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: [
    FlyingHeroesComponent,
    FlyingHeroesImpureComponent,
    HeroAsyncMessageComponent,
    HeroBirthdayComponent,
    HeroBirthday2Component,
    HeroListComponent,
    PowerBoostCalculatorComponent,
    PowerBoosterComponent,
  ],
  pipes: [commonPipes],
)
class AppComponent {
  DateTime birthday = DateTime(1988, 4, 15); // April 15, 1988
}
