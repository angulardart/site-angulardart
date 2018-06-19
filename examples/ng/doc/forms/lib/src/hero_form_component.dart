// #docregion '', v1, final
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'hero.dart';

const List<String> _powers = [
  'Really Smart',
  'Super Flexible',
  'Super Hot',
  'Weather Changer'
];

@Component(
  selector: 'hero-form',
  templateUrl: 'hero_form_component.html',
  directives: [coreDirectives, formDirectives],
)
class HeroFormComponent {
  Hero model = Hero(18, 'Dr IQ', _powers[0], 'Chuck Overstreet');
  // #docregion submitted
  bool submitted = false;

  // #enddocregion submitted
  List<String> get powers => _powers;

  // #docregion submitted
  void onSubmit() => submitted = true;
  // #enddocregion submitted, v1

  /// Returns a map of CSS class names representing the state of [control].
  // #docregion setCssValidityClass
  Map<String, bool> setCssValidityClass(NgControl control) {
    final validityClass = control.valid == true ? 'is-valid' : 'is-invalid';
    return {validityClass: true};
  }
  // #enddocregion setCssValidityClass

  // #docregion clear
  void clear() {
    model.name = '';
    model.power = _powers[0];
    model.alterEgo = '';
  }
  // #enddocregion clear
  // #docregion v1
}
// #enddocregion '', v1, final

Hero skyDog() {
  // #docregion SkyDog
  var myHero =
      Hero(42, 'SkyDog', 'Fetch any object at any distance', 'Leslie Rollover');
  print('My hero is ${myHero.name}.'); // "My hero is SkyDog."
  // #enddocregion SkyDog
  return myHero;
}
