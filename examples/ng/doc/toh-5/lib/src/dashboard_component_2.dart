// #docregion imports
import 'package:angular/angular.dart';

import 'hero.dart';
import 'hero_service.dart';
// #enddocregion imports

// #docregion metadata, metadata-wo-styles
@Component(
  selector: 'my-dashboard',
  templateUrl: 'dashboard_component_1.html',
  // #enddocregion metadata-wo-styles
  styleUrls: ['dashboard_component.css'],
  // #docregion metadata-wo-styles
  directives: [coreDirectives],
)
// #enddocregion metadata, metadata-wo-styles
// #docregion class
class DashboardComponent implements OnInit {
  List<Hero> heroes;

  // #docregion ctor
  final HeroService _heroService;

  DashboardComponent(this._heroService);
  // #enddocregion ctor

  @override
  void ngOnInit() async {
    heroes = (await _heroService.getAll()).skip(1).take(4).toList();
  }
}
