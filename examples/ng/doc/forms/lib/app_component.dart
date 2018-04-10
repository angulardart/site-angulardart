import 'package:angular/angular.dart';

import 'src/hero_form_component.dart';

@Component(
  selector: 'my-app',
  template: '<hero-form></hero-form>',
  directives: [HeroFormComponent],
)
class AppComponent {}
