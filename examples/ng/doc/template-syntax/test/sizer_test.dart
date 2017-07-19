// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:template_syntax/src/sizer_component.dart';
import 'package:test/test.dart';

import 'sizer_po.dart';

NgTestFixture<SizerComponent> fixture;
SizerPO po;

@AngularEntrypoint()
void main() {
  const initSize = 16;

  final testBed = new NgTestBed<SizerComponent>();

  setUp(() async {
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(SizerPO);
  });

  tearDown(disposeAnyRunningTest);

  test('initial font size', () => _expectSize(initSize));

  const inputSize = 10;

  test('@Input() size ${inputSize} as String', () async {
    fixture.update((c) => c.size = inputSize.toString());
    po = await fixture.resolvePageObject(SizerPO);
    await _expectSize(inputSize);
  });

  test('@Input() size ${inputSize} as int', () async {
    fixture.update((c) => c.size = inputSize);
    po = await fixture.resolvePageObject(SizerPO);
    await _expectSize(inputSize);
  });

  group('dec:', () {
    const expectedSize = initSize - 1;

    setUp(() => po.dec());

    test('font size is $expectedSize', () async {
      await _expectSize(expectedSize);
    });

    test('@Output $expectedSize size event', () async {
      fixture.update((c) async {
        expect(await c.sizeChange.first, expectedSize);
      });
    });
  });

  // #docregion Output-after-inc
  group('inc:', () {
    const expectedSize = initSize + 1;

    setUp(() => po.inc());

    test('font size is $expectedSize', () async {
      // #enddocregion Output-after-inc
      await _expectSize(expectedSize);
      // #docregion Output-after-inc
    });

    test('@Output $expectedSize size event', () async {
      fixture.update((c) async {
        expect(await c.sizeChange.first, expectedSize);
      });
    });
  });
  // #enddocregion Output-after-inc
}

Future<Null> _expectSize(int size) async {
  expect(await po.fontSizeFromLabelText, size);
  expect(await po.fontSizeFromStyle, size);
}
