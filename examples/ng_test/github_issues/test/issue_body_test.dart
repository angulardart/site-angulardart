@Tags(const ['aot'])
@TestOn('browser')
library angular_simple_test;

import 'package:angular/angular.dart';
import 'package:ng_test.github_issues/api.dart';
import 'package:ng_test.github_issues/ui.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

@AngularEntrypoint()
void main() {
  tearDown(disposeAnyRunningTest);

  group('$IssueBodyComponent', () {
    test('should properly render markdown', () async {
      var testBed = new NgTestBed<IssueBodyComponent>();
      var fixture = await testBed.create(beforeChangeDetection: (c) {
        c.issue = new GithubIssue(
          description: '**Hello World**',
        );
      });
      expect(
        fixture.rootElement.innerHtml,
        contains('<strong>Hello World</strong>'),
      );
    });
  });
}
