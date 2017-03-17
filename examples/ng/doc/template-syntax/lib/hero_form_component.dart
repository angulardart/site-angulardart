import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'hero.dart';

@Component(
    selector: 'hero-form',
    templateUrl: 'hero_form_component.html',
    styles: const [
      '''
      button { margin: 6px 0; }
      #heroForm { border: 1px solid black; margin: 20px 0; padding: 8px; max-width: 350px; }
    '''
    ])
class HeroFormComponent {
  @Input()
  Hero hero;
  @ViewChild('heroForm')
  NgForm form;
  var _submitMessage = '';

  String get submitMessage {
    if (!this.form.valid) {
      this._submitMessage = '';
    }
    return this._submitMessage;
  }

  void onSubmit(NgForm form) {
    this._submitMessage =
        'Submitted. form value is ' + /*JSON.stringify*/(this.form.value).toString();
  }
}
