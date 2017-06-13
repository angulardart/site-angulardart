import 'package:angular2/angular2.dart';

@Injectable()
class TaxRateService {
  num getRate(String rateName) => 0.10;
}
