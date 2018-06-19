// A simple test
// More details will be in the testing chapter.
import 'package:dependency_injection/src/heroes/hero.dart';
import 'package:dependency_injection/src/heroes/hero_list_component.dart';
import 'package:dependency_injection/src/heroes/hero_service.dart';
import 'package:test/test.dart';

///////////////////////////////////////
// #docregion spec
List<Hero> expectedHeroes = [
  Hero(1, 'hero1'),
  Hero(2, 'hero2', true)
];

class HeroServiceMock implements HeroService {
  @override
  List<Hero> getAll() => expectedHeroes;
}

var mockService = HeroServiceMock();

void main() {
  test('should have heroes when HeroListComponent created', () {
    var hlc = HeroListComponent(mockService);
    expect(hlc.heroes.length, expectedHeroes.length);
  });
}
// #enddocregion spec
