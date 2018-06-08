import 'package:angular/angular.dart';

// #docregion little-tour
@Component(
  selector: 'little-tour',
  template: '''
    <input #newHero
      (keyup.enter)="addHero(newHero.value)"
      (blur)="addHero(newHero.value); newHero.value='' ">

    <button (click)="addHero(newHero.value)">Add</button>

    <ul><li *ngFor="let hero of heroes">{{hero}}</li></ul>
  ''',
  directives: [coreDirectives],
)
class LittleTourComponent {
  List<String> heroes = ['Windstorm', 'Bombasto', 'Magneta', 'Tornado'];

  void addHero(String newHero) {
    if (newHero == null || newHero.isEmpty) return;
    heroes.add(newHero);
  }
}
