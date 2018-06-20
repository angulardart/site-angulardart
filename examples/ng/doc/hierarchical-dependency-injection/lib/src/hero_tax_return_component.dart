import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'hero.dart';
import 'hero_tax_return_service.dart';

@Component(
  selector: 'hero-tax-return',
  template: '''
    <div class="tax-return">
      <div class="msg" [class.canceled]="message==='Canceled'">{{message}}</div>
      <fieldset>
        <span id="name">{{taxReturn.name}}</span>
        <label id="tid">TID: {{taxReturn.taxId}}</label>
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
  styleUrls: ['hero_tax_return_component.css'],
  directives: [coreDirectives, formDirectives],
  // #docregion providers
  providers: [ClassProvider(HeroTaxReturnService)],
  // #enddocregion providers
)
class HeroTaxReturnComponent {
  final HeroTaxReturnService _heroTaxReturnService;
  String message = '';

  HeroTaxReturnComponent(this._heroTaxReturnService);

  final _close = StreamController<Null>();
  @Output()
  Stream<Null> get close => _close.stream;

  HeroTaxReturn get taxReturn => _heroTaxReturnService.taxReturn;

  @Input()
  void set taxReturn(HeroTaxReturn htr) {
    _heroTaxReturnService.taxReturn = htr;
  }

  Future<void> onCanceled() async {
    _heroTaxReturnService.restoreTaxReturn();
    await flashMessage('Canceled');
  }

  void onClose() => _close.add(null);

  Future<void> onSaved() async {
    await _heroTaxReturnService.saveTaxReturn();
    await flashMessage('Saved');
  }

  Future<void> flashMessage(String msg) async {
    message = msg;
    await Future.delayed(Duration(milliseconds: 500));
    message = '';
  }
}
