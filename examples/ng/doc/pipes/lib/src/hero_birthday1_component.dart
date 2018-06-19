import 'package:angular/angular.dart';

@Component(
  selector: 'hero-birthday',
  // #docregion hero-birthday-template
  template: "<p>The hero's birthday is {{ birthday | date }}</p>",
  // #enddocregion hero-birthday-template
  pipes: [commonPipes],
)
class HeroBirthdayComponent {
  DateTime birthday = DateTime(1988, 4, 15); // April 15, 1988
}
