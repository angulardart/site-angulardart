import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'flying_heroes_pipe.dart';
import 'heroes.dart';

@Component(
  selector: 'flying-heroes',
  templateUrl: 'flying_heroes_component.html',
  styles: ['#flyers, #all {font-style: italic}'],
  pipes: [FlyingHeroesPipe],
  directives: [coreDirectives, formDirectives],
)
// #docregion v1
class FlyingHeroesComponent {
  List<Hero> heroes;
  bool canFly = true;
  // #enddocregion v1
  bool mutate = true;
  String title = 'Flying Heroes (pure pipe)';
  // #docregion v1

  FlyingHeroesComponent() {
    reset();
  }

  void addHero(String name) {
    name = name.trim();
    if (name.isEmpty) return;

    var hero = Hero(name, canFly);
    // #enddocregion v1
    if (mutate) {
      // Pure pipe won't update display because heroes list
      // reference is unchanged; Impure pipe will display.
      // #docregion v1, push
      heroes.add(hero);
      // #enddocregion v1, push
    } else {
      // Pipe updates display because heroes list is a object
      // #docregion concat
      heroes = List<Hero>.from(heroes)..add(hero);
      // #enddocregion concat
    }
    // #docregion v1
  }

  void reset() {
    heroes = List<Hero>.from(mockHeroes);
  }
}
// #enddocregion v1

//\\\\ Identical except for impure pipe \\\\\\
// #docregion impure-component
@Component(
  selector: 'flying-heroes-impure',
  templateUrl: 'flying_heroes_component.html',
  // #enddocregion impure-component
  styles: ['.flyers, .all {font-style: italic}'],
  // #docregion impure-component
  pipes: [FlyingHeroesImpurePipe],
  directives: [coreDirectives, formDirectives],
)
class FlyingHeroesImpureComponent extends FlyingHeroesComponent {
  FlyingHeroesImpureComponent() {
    title = 'Flying Heroes (impure pipe)';
  }
}
