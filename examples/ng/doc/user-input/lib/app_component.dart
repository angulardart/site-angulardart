import 'package:angular/angular.dart';

import 'src/click_me_component.dart';
import 'src/click_me2_component.dart';
import 'src/keyup_components.dart';
import 'src/little_tour_component.dart';
import 'src/loop_back_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [
    ClickMeComponent,
    ClickMe2Component,
    KeyUpComponentV1,
    KeyUpComponentV2,
    KeyUpComponentV3,
    KeyUpComponentV4,
    LoopBackComponent,
    LittleTourComponent,
  ],
)
class AppComponent {}
