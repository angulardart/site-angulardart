'use strict'; // necessary for es6 output in node

import { browser, element, by } from 'protractor';

describe('Structural Directives', function () {

  beforeAll(() => browser.get(''));

  it('first div should show hero name with *ngIf', function () {
    const allDivs = element.all(by.tagName('div'));
    expect(allDivs.get(0).getText()).toEqual('Mr. Nice');
  });

  it('first li should show hero name with *ngFor', function () {
    const allLis = element.all(by.tagName('li'));
    expect(allLis.get(0).getText()).toEqual('Mr. Nice');
  });

  it('ngSwitch has <happy-hero> instances', function () {
    const happyHeroEls = element.all(by.tagName('happy-hero'));
    expect(happyHeroEls.count()).toEqual(2);
  });

  it('should toggle *ngIf="hero" with a button', function () {
    const toggleHeroButton = element.all(by.cssContainingText('button', 'Toggle hero')).get(0);
    const paragraph = element.all(by.cssContainingText('p', 'I turned the corner'));
    expect(paragraph.get(0).getText()).toContain('I waved');
    toggleHeroButton.click().then(() => {
      expect(paragraph.get(0).getText()).not.toContain('I waved');
    });
  });

  it('should have only one "Hip!" (the other is erased)', function () {
    const paragraph = element.all(by.cssContainingText('p', 'Hip!'));
    expect(paragraph.count()).toEqual(1);
  });

  it('myUnless shows (A)s', function () {
    // const paragraph = element.all(by.css('p.unless')).
    const paragraph = element.all(by.xpath('//p[contains(@class, "unless")][contains(text(), "(A)")]'));
    expect(paragraph.count()).toEqual(2);
  });

  it('myUnless should show 1 paragraph (B) after toggling condition', function () {
    const toggleConditionButton = element.all(by.cssContainingText('button', 'Toggle condition')).get(0);
    const paragraph = element.all(by.css('p.unless'));

    toggleConditionButton.click().then(() => {
      expect(paragraph.count()).toEqual(1);
      expect(paragraph.get(0).getText()).toContain('(B)');
    });
  });
});

