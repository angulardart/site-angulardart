import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';
import 'package:angular2_api_examples.testing/api.dart';
import 'package:angular2_api_examples.testing/ui.dart';

@Component(
  selector: 'ng-app',
  directives: const [
    IssueListComponent,
  ],
  template: '<issue-list></issue-list>',
)
class NgAppComponent {}

void main() {
  bootstrap(NgAppComponent, const [
    apiProviders,
  ]);
}
