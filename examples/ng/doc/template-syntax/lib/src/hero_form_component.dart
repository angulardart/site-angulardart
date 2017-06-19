import 'package:angular2/angular2.dart';
import 'hero.dart';

@Component(
  selector: 'hero-form',
  templateUrl: 'hero_form_component.html',
  styles: const [
    '''
      button { margin: 6px 0; }
      #heroForm { border: 1px solid black; margin: 20px 0; padding: 8px; max-width: 350px; }
    '''
  ],
  directives: const [COMMON_DIRECTIVES],
)
class HeroFormComponent {
  @Input()
  Hero hero;
  @ViewChild('heroForm')
  NgForm form;
  String _submitMessage = '';

  String get submitMessage {
    if (!form.valid) _submitMessage = '';
    return _submitMessage;
  }

  void onSubmit(NgForm form) {
    _submitMessage = 'Submitted. Form value is ${form.value}.';
  }
}
