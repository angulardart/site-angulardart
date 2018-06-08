import 'package:angular/angular.dart';

// #docregion ViewEncapsulation
@Component(
  // #enddocregion ViewEncapsulation
  selector: 'quest-summary',
  // #docregion urls
  templateUrl: 'quest_summary_component.html',
  styleUrls: ['quest_summary_component.css'],
  // #enddocregion urls
  // #docregion ViewEncapsulation
  encapsulation: ViewEncapsulation.Emulated,
)
// #enddocregion ViewEncapsulation
class QuestSummaryComponent {}
