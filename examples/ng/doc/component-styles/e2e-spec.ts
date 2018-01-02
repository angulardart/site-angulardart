'use strict'; // necessary for es6 output in node

import { browser, element, by } from 'protractor';

// Font weight of 'normal' is defined as 400. See https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight
// Browsers differ in which value they return so expect either value.
const normalFontWeight = ['normal', '400'];

describe('Component Style Tests', () => {

  beforeAll(() =>  browser.get(''));

  it('applies component styles to component view', () => {
    let h1 = element(by.css('hero-app > h1'));
    expect(normalFontWeight).toContain(h1.getCssValue('fontWeight'));
  });

  it('does not apply component styles outside component', () => {
    let h1 = element(by.css('body > h1'));
    expect(normalFontWeight).not.toContain(h1.getCssValue('fontWeight'));
  });

  it('allows styling :host element', function() {
    let host = element(by.css('hero-details'));

    expect(host.getCssValue('borderWidth')).toEqual('1px');
  });

  it('supports :host() in function form', function() {
    let host = element(by.css('hero-details'));

    host.element(by.buttonText('Activate')).click();
    expect(host.getCssValue('borderWidth')).toEqual('3px');
  });

  it('allows conditional :host-context() styling', function() {
    let h2 = element(by.css('hero-details h2'));

    expect(h2.getCssValue('backgroundColor')).toEqual('rgba(238, 238, 255, 1)'); // #eeeeff
  });

  it('styles both view and content children with ::ng-deep', function() {
    let viewH3 = element(by.css('hero-team h3'));
    let contentH3 = element(by.css('hero-controls h3'));

    expect(viewH3.getCssValue('fontStyle')).toEqual('italic');
    expect(contentH3.getCssValue('fontStyle')).toEqual('italic');
  });

  it('includes styles loaded with CSS @import', function() {
    let host = element(by.css('hero-details'));

    expect(host.getCssValue('padding')).toEqual('10px');
  });

  it('processes template inline styles', function() {
    let button = element(by.css('hero-controls button'));
    let externalButton = element(by.css('body > button'));
    expect(button.getCssValue('backgroundColor')).toEqual('rgba(255, 255, 255, 1)'); // #ffffff
    expect(externalButton.getCssValue('backgroundColor')).not.toEqual('rgba(255, 255, 255, 1)');
  });

  it('processes template <link>s', function() {
    let li = element(by.css('hero-team li:first-child'));
    let externalLi = element(by.css('body > ul li'));

    expect(li.getCssValue('listStyleType')).toEqual('square');
    expect(externalLi.getCssValue('listStyleType')).not.toEqual('square');
  });

});
