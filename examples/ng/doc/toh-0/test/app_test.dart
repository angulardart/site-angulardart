// #docplaster
// #docregion , initial
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:angular_tour_of_heroes/app_component.dart';

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> testFixture;

  setUp(() async {
    testFixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  // #docregion default-test
  test('Default greeting', () {
    expect(testFixture.text, 'Hello Angular');
  });
  // #enddocregion default-test, initial

  // #docregion more-tests
  test('Greet world', () async {
    await testFixture.update((c) => c.name = 'World');
    expect(testFixture.text, 'Hello World');
  });

  test('Greet world HTML', () {
    final html = testFixture.rootElement.innerHtml;
    expect(html, '<h1>Hello Angular</h1>');
  });
  // #enddocregion more-tests
  // #docregion initial
}
