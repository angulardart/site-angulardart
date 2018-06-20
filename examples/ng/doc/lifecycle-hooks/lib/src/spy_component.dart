import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'logger_service.dart';
import 'spy_directive.dart';

@Component(
  selector: 'spy-parent',
  templateUrl: 'spy_component.html',
  styles: [
    '.parent {background: khaki}',
    '.heroes {background: LightYellow; padding: 0 8px}'
  ],
  directives: [coreDirectives, formDirectives, SpyDirective],
  providers: [ClassProvider(LoggerService)],
)
class SpyParentComponent {
  final LoggerService _logger;
  String newName = 'Herbie';
  List<String> heroes = ['Windstorm', 'Magneta'];

  SpyParentComponent(this._logger);

  List<String> get logs => _logger.logs;

  addHero() {
    if (newName.trim().isNotEmpty) {
      heroes.add(newName.trim());
      newName = '';
      _logger.tick();
    }
  }

  // removeHero(String hero) { } is not used.

  void reset() {
    _logger.log('-- reset --');
    heroes.clear();
    _logger.tick();
  }
}
