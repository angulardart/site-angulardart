import 'package:angular/angular.dart';

import 'src/car_components.dart';
import 'src/heroes_list_component.dart';
import 'src/heroes_service.dart';
import 'src/villains_list_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <label><input type="checkbox" [checked]="showHeroes"   (change)="showHeroes=!showHeroes">Heroes</label>
    <label><input type="checkbox" [checked]="showVillains" (change)="showVillains=!showVillains">Villains</label>
    <label><input type="checkbox" [checked]="showCars"     (change)="showCars=!showCars">Cars</label>

    <h1>Hierarchical Dependency Injection</h1>

    <heroes-list   *ngIf="showHeroes"></heroes-list>
    <villains-list *ngIf="showVillains"></villains-list>
    <my-cars       *ngIf="showCars"></my-cars>
  ''',
  directives: [
    coreDirectives,
    carComponents,
    HeroesListComponent,
    VillainsListComponent,
  ],
  providers: [
    carServices,
    const ClassProvider(HeroesService),
  ],
)
class AppComponent {
  bool showCars = true;
  bool showHeroes = true;
  bool showVillains = true;
}
