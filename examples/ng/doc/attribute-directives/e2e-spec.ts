'use strict'; // necessary for es6 output in node

import { browser, element, by } from 'protractor';

describe('Attribute directives', () => {

  const _title = 'My First Attribute Directive';

  beforeAll(() => browser.get(''));

  it(`has title: ${_title}`, () => {
    expect(element(by.css('h1')).getText()).toEqual(_title);
  });

  it('selects green highlight', async () => {
    let highlightedEl = element(by.cssContainingText('p', 'Highlight me!'));
    let lightGreen = 'rgba(144, 238, 144, 1)';

    expect(highlightedEl.getCssValue('background-color')).not.toEqual(lightGreen);
    // let greenRb = element(by.cssContainingText('input', 'Green'));
    let greenRb = element.all(by.css('input')).get(0);
    await greenRb.click();
    await browser.actions().mouseMove(highlightedEl as any).perform();
    expect(highlightedEl.getCssValue('background-color')).toEqual(lightGreen);
  });

  it('headings have auto-generated id', async () => {
    expect(element(by.css('#heading-0')).getText()).toEqual('Auto-ID at work');
    expect(element(by.css('#heading-1')).getText()).toEqual('Auto-ID at work, again');
  });
});
