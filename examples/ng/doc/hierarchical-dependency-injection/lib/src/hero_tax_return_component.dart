// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'hero_tax_return_service.dart';

@Component(
    selector: 'hero-tax-return',
    template: '''
      <div class="tax-return">
        <div class="msg" [class.canceled]="message==='Canceled'">{{message}}</div>
        <fieldset>
          <span  id=name>{{taxReturn.name}}</span>
          <label id=tid>TID: {{taxReturn.taxId}}</label>
        </fieldset>
        <fieldset>
          <label>
            Income: <input type="number" [(ngModel)]="taxReturn.income" class="num">
          </label>
        </fieldset>
        <fieldset>
          <label>Tax: {{taxReturn.tax}}</label>
        </fieldset>
        <fieldset>
          <button (click)="onSaved()">Save</button>
          <button (click)="onCanceled()">Cancel</button>
          <button (click)="onClose()">Close</button>
        </fieldset>
      </div>
    ''',
    styleUrls: const ['hero_tax_return_component.css'],
    directives: const [COMMON_DIRECTIVES],
    // #docregion providers
    providers: const [HeroTaxReturnService])
// #enddocregion providers
class HeroTaxReturnComponent {
  final HeroTaxReturnService _heroTaxReturnService;
  String message = '';

  HeroTaxReturnComponent(this._heroTaxReturnService);

  final _close = new StreamController<Null>();
  @Output()
  Stream<Null> get close => _close.stream;

  HeroTaxReturn get taxReturn => _heroTaxReturnService.taxReturn;

  @Input()
  void set taxReturn(HeroTaxReturn htr) {
    _heroTaxReturnService.taxReturn = htr;
  }

  Future<Null> onCanceled() async {
    _heroTaxReturnService.restoreTaxReturn();
    await flashMessage('Canceled');
  }

  void onClose() => _close.add(null);

  Future<Null> onSaved() async {
    await _heroTaxReturnService.saveTaxReturn();
    await flashMessage('Saved');
  }

  Future<Null> flashMessage(String msg) async {
    message = msg;
    await new Future.delayed(const Duration(milliseconds: 500));
    message = '';
  }
}
