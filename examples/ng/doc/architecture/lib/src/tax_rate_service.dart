import 'package:angular/angular.dart';

@Injectable()
class TaxRateService {
  num getRate(String rateName) => 0.10;
}
