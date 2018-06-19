import 'car.dart';

// BAD pattern!
class CarFactory {
  Car createCar() => Car(createEngine(), createTires()) //!<br>
    ..description = 'Factory';

  Engine createEngine() => Engine();
  Tires createTires() => Tires();
}
