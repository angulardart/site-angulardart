import 'tax_rate_service.dart';

class SalesTaxService {
  TaxRateService rateService;

  SalesTaxService(this.rateService);

  num getVAT(dynamic /* String | num */ value) =>
      rateService.getRate('VAT') *
      (value is num ? value : num.tryParse(value) ?? 0);
}
