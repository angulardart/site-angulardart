// #docregion initial
@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:components_codelab/lottery_simulator.dart';
import 'package:components_codelab/lottery_simulator.template.dart' as ng;
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
    final initialBet = RegExp(r'Betting\s*\$10');

    test('app heading', () {
      expect(fixture.rootElement.querySelector('h1').text, 'Lottery Simulator');
    });

    test('initial investment', () {
      expect(fixture.text, contains(initialBet));
    });

    test('no stats yet', () {
      expect(fixture.text, contains('no stats yet'));
    });

    test('one step costs money', () async {
      await fixture.update((c) => c.step());
      expect(fixture.text.contains(initialBet), isFalse);
    });
  });
}
