// #docregion
import 'package:angular2/core.dart';

import 'hero_form_component.dart';

@Component(
    selector: 'my-app',
    template: '<hero-form></hero-form>',
    directives: const [HeroFormComponent])
class AppComponent {}
