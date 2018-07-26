import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'hero-list',
  templateUrl: 'hero_list_component.html',
  providers: [HeroService],
  styles: ['.error {color:red;}'],
  directives: [coreDirectives],
)
// #docregion component
class HeroListComponent implements OnInit {
  final HeroService _heroService;
  String errorMessage;
  List<Hero> heroes = [];

  HeroListComponent(this._heroService);

  @override
  void ngOnInit() => _getHeroes();

  // #docregion methods, _getHeroes
  Future<void> _getHeroes() async {
    try {
      heroes = await _heroService.getAll();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
  // #enddocregion _getHeroes

  // #docregion add
  Future<void> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return null;
    try {
      heroes.add(await _heroService.create(name));
    } catch (e) {
      errorMessage = e.toString();
    }
  }
  // #enddocregion add, methods
}
