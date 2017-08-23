import 'package:angular/angular.dart';
import 'package:ng_test.github_issues/api.dart';
import 'package:ng_test.github_issues/ui.dart';

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
