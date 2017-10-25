import 'package:angular/angular.dart';

import 'car_services.dart';

@Component(
    selector: 'c-car',
    template: '<div>C: {{description}}</div>',
    providers: const [const Provider(CarService, useClass: CarService3)])
class CCarComponent {
  String description;
  CCarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
    selector: 'b-car',
    template: '''
      <div>B: {{description}}</div>
      <c-car></c-car>
    ''',
    directives: const [
      CCarComponent
    ],
    providers: const [
      const Provider(CarService, useClass: CarService2),
      const Provider(EngineService, useClass: EngineService2)
    ])
class BCarComponent {
  String description;
  BCarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
    selector: 'a-car',
    template: '''
      <div>A: {{description}}</div>
      <b-car></b-car>
    ''',
    directives: const [BCarComponent])
class ACarComponent {
  String description;
  ACarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
    selector: 'my-cars',
    template: '''
      <h3>Cars</h3>
      <a-car></a-car>
    ''',
    directives: const [ACarComponent])
class CarsComponent {}

const carComponents = const [
  CarsComponent,
  ACarComponent,
  BCarComponent,
  CCarComponent
];

// generic car-related services
const carServices = const [CarService, EngineService, TiresService];
