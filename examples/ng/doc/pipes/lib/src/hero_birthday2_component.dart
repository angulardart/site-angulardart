import 'package:angular/angular.dart';

@Component(
  selector: 'hero-birthday2',
  // #docregion template
  template: '''
      <p>The hero's birthday is {{ birthday | date:format }}</p>
      <button (click)="toggleFormat()">Toggle Format</button>
    ''',
  // #enddocregion template
  pipes: [commonPipes],
)
// #docregion class
class HeroBirthday2Component {
  DateTime birthday = DateTime(1988, 4, 15); // April 15, 1988

  bool toggle = true;

  get format => toggle ? 'shortDate' : 'fullDate';

  void toggleFormat() {
    toggle = !toggle;
  }
}
