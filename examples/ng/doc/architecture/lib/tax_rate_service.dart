import 'package:angular2/core.dart';

@Injectable()
class TaxRateService {
  num getRate(String rateName) => 0.10;
}
