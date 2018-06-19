@TestOn('browser')

import 'dart:async';

import 'package:angular_test/angular_test.dart';
import 'package:pageloader/html.dart';
import 'package:template_syntax/src/sizer_component.dart';
import 'package:test/test.dart';

import 'sizer_test.template.dart' as ng;
import 'sizer_po.dart';

NgTestFixture<SizerComponent> fixture;
SizerPO po;

void main() {
  ng.initReflector();

  const initSize = 16;

  final testBed = NgTestBed<SizerComponent>();

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = SizerPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('initial font size', () => _expectSize(initSize));

  const inputSize = 10;

  test('@Input() size ${inputSize} as String', () async {
    await fixture.update((c) => c.size = inputSize.toString());
    await _expectSize(inputSize);
  });

  test('@Input() size ${inputSize} as int', () async {
    await fixture.update((c) => c.size = inputSize);
    await _expectSize(inputSize);
  });

  group('dec:', () {
    const expectedSize = initSize - 1;

    setUp(() => po.dec());

    test('font size is $expectedSize', () async {
      await _expectSize(expectedSize);
    });

    test(
        '@Output $expectedSize size event',
        () => fixture.update((c) async {
              expect(await c.sizeChange.first, expectedSize);
            }));
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

    test(
        '@Output $expectedSize size event',
        () => fixture.update((c) async {
              expect(await c.sizeChange.first, expectedSize);
            }));
  });
  // #enddocregion Output-after-inc
}

Future<void> _expectSize(int size) async {
  expect(await po.fontSizeFromLabelText, size);
  expect(await po.fontSizeFromStyle, size);
}
