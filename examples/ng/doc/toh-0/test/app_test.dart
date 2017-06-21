// #docregion , initial
@Tags(const ['aot'])
@TestOn('browser')

// #enddocregion
import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:angular_tour_of_heroes/app_component.dart';

// #docregion initial
@AngularEntrypoint()
void main() {
  // #docregion test-bed-and-fixture
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  // #enddocregion test-bed-and-fixture

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  // #docregion default-test
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
  // #enddocregion default-test, initial

  // #docregion more-tests
  test('Greet world', () async {
    await fixture.update((c) => c.name = 'World');
    expect(fixture.text, 'Hello World');
  });

  test('Greet world HTML', () {
    final html = fixture.rootElement.innerHtml;
    expect(html, '<h1>Hello Angular</h1>');
  });
  // #enddocregion more-tests
  // #docregion initial
}
