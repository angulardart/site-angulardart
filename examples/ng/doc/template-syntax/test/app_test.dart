// #docregion initial
@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:template_syntax/app_component.dart';
import 'package:template_syntax/app_component.template.dart' as ng;
import 'package:test/test.dart';

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  // Smoke tests

  group('smoke test:', () {
    test('app heading', () {
      expect(fixture.rootElement.querySelector('h1').text, 'Template Syntax');
    });

    test('initial formatting', () {
      const text = 'This div is initially italic, normal weight, '
          'and extra large (24px).';
      expect(fixture.text, contains(text));
    });
  });
}
