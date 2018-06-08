// #docregion pure
import 'package:angular/angular.dart';
import 'heroes.dart';

@Pipe('flyingHeroes')
class FlyingHeroesPipe extends PipeTransform {
  // #docregion filter
  List<Hero> transform(List<Hero> value) =>
      value.where((hero) => hero.canFly).toList();
  // #enddocregion filter
}
// #enddocregion pure

// Identical except for the pure flag
// #docregion impure, pipe-decorator
@Pipe('flyingHeroes', pure: false)
// #enddocregion pipe-decorator
class FlyingHeroesImpurePipe extends FlyingHeroesPipe {}
