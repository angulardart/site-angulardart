// #docregion
import 'package:angular2/angular2.dart';

import 'src/hero_form_component.dart';

@Component(
  selector: 'my-app',
  template: '<hero-form></hero-form>',
  directives: const [HeroFormComponent],
)
class AppComponent {}
