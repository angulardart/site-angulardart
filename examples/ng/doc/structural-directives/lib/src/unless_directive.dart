// #docregion no-docs, skeleton
import 'package:angular/angular.dart';

// #enddocregion no-docs, skeleton
/// Add the template content to the DOM unless the condition is true.
///
///  If the expression assigned to `myUnless` evaluates to a truthy value
///  then the templated elements are removed removed from the DOM,
///  the templated elements are (re)inserted into the DOM.
///
///  <div *ngUnless="errorCount" class="success">
///    Congrats! Everything is great!
///  </div>
///
///  ### Syntax
///
///  - `<div *myUnless="condition">...</div>`
///  - `<template [myUnless]="condition"><div>...</div></template>`
// #docregion no-docs, skeleton
@Directive(selector: '[myUnless]')
class UnlessDirective {
  // #enddocregion skeleton
  bool _hasView = false;

  // #docregion ctor
  TemplateRef _templateRef;
  ViewContainerRef _viewContainer;

  UnlessDirective(this._templateRef, this._viewContainer);
  // #enddocregion ctor

  // #docregion set
  @Input()
  set myUnless(bool condition) {
    if (!condition && !_hasView) {
      _viewContainer.createEmbeddedView(_templateRef);
      _hasView = true;
    } else if (condition && _hasView) {
      _viewContainer.clear();
      _hasView = false;
    }
  }
  // #enddocregion set
  // #docregion skeleton
}
