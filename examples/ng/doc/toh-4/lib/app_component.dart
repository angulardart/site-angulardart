import 'dart:async';

import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_component.dart';
// #docregion hero-service-import
import 'src/hero_service.dart';
// #enddocregion hero-service-import

@Component(
  selector: 'my-app',
  // #docregion template
  templateUrl: 'app_component.html',
  // #enddocregion template
  styleUrls: ['app_component.css'],
  directives: [coreDirectives, HeroComponent],
  providers: [ClassProvider(HeroService)],
)
class AppComponent implements OnInit {
  final title = 'Tour of Heroes';
  final HeroService _heroService;
  List<Hero> heroes;
  Hero selected;

  AppComponent(this._heroService);

  // #docregion _getHeroes
  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }
  // #enddocregion _getHeroes

  void ngOnInit() => _getHeroes();

  void onSelect(Hero hero) => selected = hero;
}
