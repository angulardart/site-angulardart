@Tags(const ['aot'])
@TestOn('browser')
library angular2_complex_test;

import 'dart:async';

import 'package:angular2_api_examples.testing/api.dart';
import 'package:angular2_api_examples.testing/ui.dart';
import 'package:angular2_api_examples.testing/testing.dart';

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:mockito/mockito_no_mirrors.dart';
import 'package:test/test.dart';

@Component(
  selector: 'test',
  directives: const [IssueListComponent],
  template: r'<issue-list></issue-list>',
)
class ComplexTestComponent {}

@AngularEntrypoint()
void main() {
  tearDown(disposeAnyRunningTest);

  group('$IssueListComponent', () {
    test('should properly render markdown', () async {
      var stream = new StreamController<GithubIssue>();
      var service = new MockGithubService();
      when(service.getIssues()).thenReturn(stream.stream);
      var testBed = new NgTestBed<ComplexTestComponent>().addProviders([
        provide(GithubService, useValue: service),
      ]);
      var fixture = await testBed.create();

      // NOT REQUIRED: We just want to slow down the test to see it.
      await new Future.delayed(const Duration(seconds: 1));

      // Get a handle to the list.
      IssueListPO list = await fixture.resolvePageObject(IssueListPO);
      expect(await list.isLoading, isTrue);
      expect(await list.items, isEmpty);

      // Complete the RPC.
      await fixture.update((_) {
        stream.add(
          new GithubIssue(
            id: 1,
            url: Uri.parse('http://github.com'),
            title: 'First issue',
            author: 'matanlurey',
            description: 'I need **help**!',
          ),
        );
        stream.add(
          new GithubIssue(
            id: 2,
            url: Uri.parse('http://github.com'),
            title: 'Second issue',
            author: 'matanlurey',
            description: 'Did you _read_ my first issue yet?',
          ),
        );
        stream.close();
      });

      // NOT REQUIRED: We just want to slow down the test to see it.
      await new Future.delayed(const Duration(seconds: 1));

      // Try toggling an item.
      var row = (await list.items)[0];
      expect(await row.isToggled, isFalse);
      await row.toggle();
      expect(await row.isToggled, isTrue);

      // Check the content inside.
      expect(await list.description, 'I need help!');

      // NOT REQUIRED: We just want to slow down the test to see it.
      await new Future.delayed(const Duration(seconds: 1));

      // Toggle again.
      await row.toggle();
      expect(await row.isToggled, isFalse);

      // NOT REQUIRED: We just want to slow down the test to see it.
      await new Future.delayed(const Duration(seconds: 1));

      row = (await list.items)[1];
      await row.toggle();
      expect(await list.description, 'Did you read my first issue yet?');
    });
  });
}
