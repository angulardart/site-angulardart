---
layout: angular
title: Lifecycle Hooks
description: Angular calls lifecycle hook methods on directives and components as it creates, changes, and destroys them.
sideNavGroup: advanced
prevpage:
  title: HTTP Client
  url: /angular/guide/server-communication
nextpage:
  title: Pipes
  url: /angular/guide/pipes
---
<!-- FilePath: src/angular/guide/lifecycle-hooks.md -->
<?code-excerpt path-base="lifecycle-hooks"?>

<img src="{% asset_path 'ng/devguide/lifecycle-hooks/hooks-in-sequence.png' %}" alt="Us" align="right" style="width:200px; margin-right:30px">

A component has a lifecycle managed by Angular itself.

Angular creates it, renders it, creates and renders its children,
checks it when its data-bound properties change, and destroys it before removing it from the DOM.

Angular offers **lifecycle hooks**
that provide visibility into these key life moments and the ability to act when they occur.

A directive has the same set of lifecycle hooks, minus the hooks that are specific to component content and views.

Try the <live-example></live-example>.

<div id="hooks-overview"></div>
## Component lifecycle hooks

Directive and component instances have a lifecycle
as Angular creates, updates, and destroys them.
Developers can tap into key moments in that lifecycle by implementing
one or more of the *Lifecycle Hook* interfaces in the Angular `core` library.

Each interface has a single hook method whose name is the interface name prefixed with `ng`.
For example, the `OnInit` interface has a hook method named `ngOnInit`
that Angular calls shortly after creating the component:

<?code-excerpt "lib/src/peek_a_boo_component.dart (ngOnInit)" title?>
```
  class PeekABoo implements OnInit {
    final LoggerService _logger;

    PeekABoo(this._logger);

    // implement OnInit's `ngOnInit` method
    void ngOnInit() {
      _logIt('OnInit');
    }

    void _logIt(String msg) {
      // Don't tick or else
      // the AfterContentChecked and AfterViewChecked recurse.
      // Let parent call tick()
      _logger.log("#${_nextId++} $msg");
    }
  }
```

No directive or component will implement all of the lifecycle hooks and some of the hooks only make sense for components.
Angular only calls a directive/component hook method *if it is defined*.

<div id="hooks-purpose-timing"></div>
## Lifecycle sequence

*After* creating a component/directive by calling its constructor, Angular
calls the lifecycle hook methods in the following sequence at specific moments:

<table>
<col width="20%">
<col width="80%">
<tr>
  <th>Hook</th>
  <th>Purpose and Timing</th>
</tr>
<tr style="vertical-align:top">
  <td>ngOnChanges</td>
  <td markdown="1">
  Respond when Angular (re)sets data-bound input properties.
  The method receives a `SimpleChanges` object of current and previous property values.

  Called before `ngOnInit` and whenever one or more data-bound input properties change.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngOnInit</td>
  <td markdown="1">
  Initialize the directive/component after Angular first displays the data-bound properties
  and sets the directive/component's input properties.

  Called _once_, after the _first_ `ngOnChanges`.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngDoCheck</td>
  <td markdown="1">
  Detect and act upon changes that Angular can't or won't detect on its own.

  Called during every change detection run, immediately after `ngOnChanges` and `ngOnInit`.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngAfterContentInit</td>
  <td markdown="1">
  Respond after Angular projects external content into the component's view.

  Called _once_ after the first `NgDoCheck`.

  _A component-only hook_.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngAfterContentChecked</td>
  <td markdown="1">
  Respond after Angular checks the content projected into the component.

  Called after the `ngAfterContentInit` and every subsequent `NgDoCheck`.

  _A component-only hook_.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngAfterViewInit</td>
  <td markdown="1">
  Respond after Angular initializes the component's views and child views.

  Called _once_ after the first `ngAfterContentChecked`.

  _A component-only hook_.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngAfterViewChecked</td>
  <td markdown="1">
  Respond after Angular checks the component's views and child views.

  Called after the `ngAfterViewInit` and every subsequent `ngAfterContentChecked`.

  _A component-only hook_.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>ngOnDestroy</td>
  <td markdown="1">
  Cleanup just before Angular destroys the directive/component.
  Unsubscribe observables and detach event handlers to avoid memory leaks.

  Called _just before_ Angular destroys the directive/component.
  </td>
</tr>
</table>

<div id="other-lifecycle-hooks"></div>
## Other lifecycle hooks

Other Angular sub-systems may have their own lifecycle hooks apart from these component hooks.

The router, for instance, also has its own [router lifecycle
hooks](router/5) that allow us to tap into
specific moments in route navigation.
A parallel can be drawn between `ngOnInit` and `routerOnActivate`.  Both are
prefixed so as to avoid collision, and both run right when a component is
being initialized.

3rd party libraries might implement their hooks as well in order to give developers more
control over how these libraries are used.

<div id="the-sample"></div>
## Lifecycle exercises

The <live-example></live-example>
demonstrates the lifecycle hooks in action through a series of exercises
presented as components under the control of the root `AppComponent`.

They follow a common pattern:  a *parent* component serves as a test rig for
a *child* component that illustrates one or more of the lifecycle hook methods.

Here's a brief description of each exercise:

<table>
<col width="20%">
<col width="80%">
<tr>
  <th>Component</th>
  <th>Description</th>
</tr>
<tr style="vertical-align:top">
  <td><a href="#peek-a-boo">Peek-a-boo</a></td>
  <td markdown="1">
  Demonstrates every lifecycle hook.
  Each hook method writes to the on-screen log.
  </td>
</tr>
<tr style="vertical-align:top">
  <td><a href="#spy">Spy</a></td>
  <td markdown="1">
  Directives have lifecycle hooks too.
  A `SpyDirective` can log when the element it spies upon is
  created or destroyed using the `ngOnInit` and `ngOnDestroy` hooks.

  This example applies the `SpyDirective` to a `<div>` in an `ngFor` *hero* repeater
  managed by the parent `SpyComponent`.
  </td>
</tr>
<tr style="vertical-align:top">
  <td><a href="#onchanges">OnChanges</a></td>
  <td markdown="1">
  See how Angular calls the `ngOnChanges` hook with a `changes` object
  every time one of the component input properties changes.
  Shows how to interpret the `changes` object.
  </td>
</tr>
<tr style="vertical-align:top">
  <td><a href="#docheck">DoCheck</a></td>
  <td markdown="1">
  Implements an `ngDoCheck` method with custom change detection.
  See how often Angular calls this hook and watch it post changes to a log.
  </td>
</tr>
<tr style="vertical-align:top">
  <td><a href="#afterview">AfterView</a></td>
  <td markdown="1">
  Shows what Angular means by a *view*.
  Demonstrates the `ngAfterViewInit` and `ngAfterViewChecked` hooks.
  </td>
</tr>
<tr style="vertical-align:top">
  <td><a href="#aftercontent">AfterContent</a></td>
  <td markdown="1">
  Shows how to project external content into a component and
  how to distinguish projected content from a component's view children.
  Demonstrates the `ngAfterContentInit` and `ngAfterContentChecked` hooks.
  </td>
</tr>
<tr style="vertical-align:top">
  <td>Counter</td>
  <td markdown="1">
  Demonstrates a combination of a component and a directive
  each with its own hooks.

  In this example, a `CounterComponent` logs a change (via `ngOnChanges`)
  every time the parent component increments its input counter property.
  Meanwhile, the `SpyDirective` from the previous example is applied
  to the `CounterComponent` log where it watches log entries being created and destroyed.
  </td>
</tr>
</table>

The remainder of this chapter discusses selected exercises in further detail.

<div id="peek-a-boo"></div>
## Peek-a-boo: all hooks

The `PeekABooComponent` demonstrates all of the hooks in one component.

You would rarely, if ever, implement all of the interfaces like this.
The peek-a-boo exists to show how Angular calls the hooks in the expected order.

This snapshot reflects the state of the log after the user clicked the *Create...* button and then the *Destroy...* button.

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/peek-a-boo.png' %}" alt="Peek-a-boo">

The sequence of log messages follows the prescribed hook calling order:
`OnChanges`, `OnInit`, `DoCheck`&nbsp;(3x), `AfterContentInit`, `AfterContentChecked`&nbsp;(3x),
`AfterViewInit`, `AfterViewChecked`&nbsp;(3x), and `OnDestroy`.

<div class="l-sub-section" markdown="1">
  The constructor isn't an Angular hook *per se*.
  The log confirms that input properties (the `name` property in this case) have no assigned values at construction.
</div>

Had the user clicked the *Update Hero* button, the log would show another `OnChanges` and two more triplets of
`DoCheck`, `AfterContentChecked` and `AfterViewChecked`.
Clearly these three hooks fire a *often*. Keep the logic in these hooks as lean as possible!

The next examples focus on hook details.

<div id="spy"></div>
## Spying *OnInit* and *OnDestroy*

Go undercover with these two spy hooks to discover when an element is initialized or destroyed.

This is the perfect infiltration job for a directive.
The heroes will never know they're being watched.

<div class="l-sub-section" markdown="1">
  Kidding aside, pay attention to two key points:

  1. Angular calls hook methods for *directives* as well as components.<br><br>

  2. A spy directive can provide insight into a DOM object that you cannot change directly.
  Obviously you can't touch the implementation of a native `div`.
  You can't modify a third party component either.
  But you can watch both with a directive.
</div>

The sneaky spy directive is simple,  consisting almost entirely of `ngOnInit` and `ngOnDestroy` hooks
that log messages to the parent via an injected `LoggerService`.

<?code-excerpt "lib/src/spy_directive.dart" region="spy-directive"?>
```
  // Spy on any element to which it is applied.
  // Usage: <div mySpy>...</div>
  @Directive(selector: '[mySpy]')
  class SpyDirective implements OnInit, OnDestroy {
    final LoggerService _logger;

    SpyDirective(this._logger);

    ngOnInit() => _logIt('onInit');

    ngOnDestroy() => _logIt('onDestroy');

    _logIt(String msg) => _logger.log('Spy #${_nextId++} $msg');
  }
```

You can apply the spy to any native or component element and it'll be initialized and destroyed
at the same time as that element.
Here it is attached to the repeated hero `<div>`

<?code-excerpt "lib/src/spy_component.html" region="template"?>
```
  <div *ngFor="let hero of heroes" mySpy class="heroes">
    {!{hero}!}
  </div>
```

Each spy's birth and death marks the birth and death of the attached hero `<div>`
with an entry in the *Hook Log* as seen here:

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/spy-directive.gif' %}" alt="Spy Directive">

Adding a hero results in a new hero `<div>`. The spy's `ngOnInit` logs that event.

The *Reset* button clears the `heroes` list.
Angular removes all hero `<div>` elements from the DOM and destroys their spy directives at the same time.
The spy's `ngOnDestroy` method reports its last moments.

The `ngOnInit` and `ngOnDestroy` methods have more vital roles to play in real applications.

### OnInit

Use `ngOnInit` for two main reasons:
1. to perform complex initializations shortly after construction
1. to set up the component after Angular sets the input properties

Experienced developers agree that components should be cheap and safe to construct.

<div class="l-sub-section" markdown="1">
  Misko Hevery, Angular team lead,
  [explains why](http://misko.hevery.com/code-reviewers-guide/flaw-constructor-does-real-work/)
  you should avoid complex constructor logic.
</div>

Don't fetch data in a component constructor.
You shouldn't worry that a new component will try to contact a remote server when
created under test or before you decide to display it.
Constructors should do no more than set the initial local variables to simple values.

An `ngOnInit` is a good place for a component to fetch its initial data. The
[Tutorial](../tutorial/toh-pt4.html#oninit) and [HTTP](server-communication.html#oninit) chapter
show how.


Remember also that a directive's data-bound input properties are not set until _after construction_.
That's a problem if you need to initialize the directive based on those properties.
They'll have been set when `ngOninit` runs.

<div class="l-sub-section" markdown="1">
  The `ngOnChanges` method is your first opportunity to access those properties.
  Angular calls `ngOnChanges` before `ngOnInit` ... and many times after that.
  It only calls `ngOnInit` once.
</div>

You can count on Angular to call the `ngOnInit` method _soon_ after creating the component.
That's where the heavy initialization logic belongs.

### OnDestroy

Put cleanup logic in `ngOnDestroy`, the logic that *must* run before Angular destroys the directive.

This is the time to notify another part of the application that the component is going away.

This is the place to free resources that won't be garbage collected automatically.
Unsubscribe from observables and DOM events. Stop interval timers.
Unregister all callbacks that this directive registered with global or application services.
You risk memory leaks if you neglect to do so.

## OnChanges

Angular calls its `ngOnChanges` method whenever it detects changes to ***input properties*** of the component (or directive).
This example monitors the `OnChanges` hook.

<?code-excerpt "lib/src/on_changes_component.dart (ngOnChanges)" region="ng-on-changes" title?>
```
  ngOnChanges(Map<String, SimpleChange> changes) {
    changes.forEach((String propName, SimpleChange change) {
      String cur = JSON.encode(change.currentValue);
      String prev = change.previousValue == null
          ? "{}"
          : JSON.encode(change.previousValue);
      changeLog.add('$propName: currentValue = $cur, previousValue = $prev');
    });
  }
```

The `ngOnChanges` method takes an object that maps each changed property name to a
[SimpleChange](/api/angular2/angular2.core/SimpleChange-class.html) object holding the current and previous property values.
This hook iterates over the changed properties and logs them.

The example component, `OnChangesComponent`, has two input properties: `hero` and `power`.

<?code-excerpt "lib/src/on_changes_component.dart" region="inputs"?>
```
  @Input()
  Hero hero;
  @Input()
  String power;
```

The host `OnChangesParentComponent` binds to them like this:

<?code-excerpt "lib/src/on_changes_parent_component.html" region="on-changes"?>
```
  <on-changes [hero]="hero" [power]="power"></on-changes>
```

Here's the sample in action as the user makes changes.

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/on-changes-anim.gif' %}" alt="OnChanges">

The log entries appear as the string value of the *power* property changes.
But the `ngOnChanges` does not catch changes to `hero.name`
That's surprising at first.

Angular only calls the hook when the value of the input property changes.
The value of the `hero` property is the *reference to the hero object*.
Angular doesn't care that the hero's own `name` property changed.
The hero object *reference* didn't change so, from Angular's perspective, there is no change to report!

## DoCheck

Use the `DoCheck` hook to detect and act upon changes that Angular doesn't catch on its own.

<div class="l-sub-section" markdown="1">
  Use this method to detect a change that Angular overlooked.
</div>

The *DoCheck* sample extends the *OnChanges* sample with the following `ngDoCheck` hook:

<?code-excerpt "lib/src/do_check_component.dart (ngDoCheck)" region="ng-do-check" title?>
```
  ngDoCheck() {
    if (hero.name != oldHeroName) {
      changeDetected = true;
      changeLog.add(
          'DoCheck: Hero name changed to "${hero.name}" from "$oldHeroName"');
      oldHeroName = hero.name;
    }

    if (power != oldPower) {
      changeDetected = true;
      changeLog.add('DoCheck: Power changed to "$power" from "$oldPower"');
      oldPower = power;
    }

    if (changeDetected) {
      noChangeCount = 0;
    } else {
      // log that hook was called when there was no relevant change.
      var count = noChangeCount += 1;
      var noChangeMsg =
          'DoCheck called ${count}x when no change to hero or power';
      if (count == 1) {
        // add new "no change" message
        changeLog.add(noChangeMsg);
      } else {
        // update last "no change" message
        changeLog[changeLog.length - 1] = noChangeMsg;
      }
    }

    changeDetected = false;
  }
```

This code inspects certain _values-of-interest_, capturing and comparing their current state against previous values.
It writes a special message to the log when there are no substantive changes to the `hero` or the `power`
so you can see how often `DoCheck` is called. The results are illuminating:

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/do-check-anim.gif' %}" alt="DoCheck">

While the `ngDoCheck` hook can detect when the hero's `name` has changed, it has a frightful cost.
This hook is called with enormous frequency &mdash;
after _every_ change detection cycle no matter where the change occurred.
It's called over twenty times in this example before the user can do anything.

Most of these initial checks are triggered by Angular's first rendering of *unrelated data elsewhere on the page*.
Mere mousing into another input box triggers a call.
Relatively few calls reveal actual changes to pertinent data.
Clearly our implementation must be very lightweight or the user experience will suffer.

## AfterView

The *AfterView* sample explores the `AfterViewInit` and `AfterViewChecked` hooks that Angular calls
*after* it creates a component's child views.

Here's a child view that displays a hero's name in an input box:

<?code-excerpt "lib/src/after_view_component.dart (child view)" title?>
```
  @Component(
    selector: 'my-child-view',
    template: '<input [(ngModel)]="hero">',
    directives: const [COMMON_DIRECTIVES],
  )
  class ChildViewComponent {
    String hero = 'Magneta';
  }
```

The `AfterViewComponent` displays this child view *within its template*:

<?code-excerpt "lib/src/after_view_component.dart (template)" region="template" title?>
```
  template: '''
    <div>-- child view begins --</div>
      <my-child-view></my-child-view>
    <div>-- child view ends --</div>
    <p *ngIf="comment.isNotEmpty" class="comment">{!{comment}!}</p>''',
```

The following hooks take action based on changing values *within the child view*
which can only be reached by querying for the child view via the property decorated with
[@ViewChild](/api/angular2/angular2.core/ViewChild-class.html).

<?code-excerpt "lib/src/after_view_component.dart (class excerpts)" region="hooks" title?>
```
  class AfterViewComponent implements AfterViewChecked, AfterViewInit {
    var _prevHero = '';

    // Query for a VIEW child of type `ChildViewComponent`
    @ViewChild(ChildViewComponent)
    ChildViewComponent viewChild;

    ngAfterViewInit() {
      // viewChild is set after the view has been initialized
      _logIt('AfterViewInit');
      _doSomething();
    }

    ngAfterViewChecked() {
      // viewChild is updated after the view has been checked
      if (_prevHero == viewChild.hero) {
        _logIt('AfterViewChecked (no change)');
      } else {
        _prevHero = viewChild.hero;
        _logIt('AfterViewChecked');
        _doSomething();
      }
    }
    // ...
  }
```

<div id="wait-a-tick"></div>
### Abide by the unidirectional data flow rule

The `doSomething` method updates the screen when the hero name exceeds 10 characters.

<?code-excerpt "lib/src/after_view_component.dart (doSomething)" region="do-something" title?>
```
  // This surrogate for real business logic sets the `comment`
  void _doSomething() {
    var c = viewChild.hero.length > 10 ? "That's a long name" : '';
    if (c != comment) {
      // Wait a tick because the component's view has already been checked
      _logger.tick().then((_) {
        comment = c;
      });
    }
  }
```

Why does the `doSomething` method wait a tick before updating `comment`?

Angular's unidirectional data flow rule forbids updates to the view *after* it has been composed.
Both of these hooks fire _after_ the component's view has been composed.

Angular throws an error if the hook updates the component's data-bound `comment` property immediately (try it!).

The `LoggerService.tick()` postpones the log update
for one turn of the browser's update cycle ... and that's just long enough.

Here's *AfterView* in action

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/after-view-anim.gif' %}" alt="AfterView">

Notice that Angular frequently calls `AfterViewChecked`, often when there are no changes of interest.
Write lean hook methods to avoid performance problems.

## AfterContent

The *AfterContent* sample explores the `AfterContentInit` and `AfterContentChecked` hooks that Angular calls
*after* Angular projects external content into the component.

### Content projection

*Content projection* is a way to import HTML content from outside the component and insert that content
into the component's template in a designated spot.

<div class="l-sub-section" markdown="1">
  Angular 1 developers know this technique as *transclusion*.
</div>

Consider this variation on the [previous _AfterView_](#afterview) example.
This time, instead of including the child view within the template, it imports the content from
the `AfterContentComponent`'s parent. Here's the parent's template.

<?code-excerpt "lib/src/after_content_component.dart (template excerpt)" region="parent-template" title?>
```
  template: '''
    <div class="parent">
      <h2>AfterContent</h2>

      <div *ngIf="show">
        <after-content>
          <my-child></my-child>
        </after-content>
      </div>

      <h4>-- AfterContent Logs --</h4>
      <p><button (click)="reset()">Reset</button></p>
      <div *ngFor="let msg of logs">{!{msg}!}</div>
    </div>
    ''',
```

Notice that the `<my-child>` tag is tucked between the `<after-content>` tags.
Never put content between a component's element tags *unless you intend to project that content
into the component*.

Now look at the component's template:

<?code-excerpt "lib/src/after_content_component.dart (template)" region="template" title?>
```
  template: '''
    <div>-- projected content begins --</div>
      <ng-content></ng-content>
    <div>-- projected content ends --</div>
    <p *ngIf="comment.isNotEmpty" class="comment">{!{comment}!}</p>
    ''',
```

The `<ng-content>` tag is a *placeholder* for the external content.
It tells Angular where to insert that content.
In this case, the projected content is the `<my-child>` from the parent.

<img class="image-display" src="{% asset_path 'ng/devguide/lifecycle-hooks/projected-child-view.png' %}" width="262" alt="Projected Content">

<div class="l-sub-section" markdown="1">
  The tell-tale signs of *content projection* are (a) HTML between component element tags
  and (b) the presence of `<ng-content>` tags in the component's template.
</div>

### AfterContent hooks

*AfterContent* hooks are similar to the *AfterView* hooks.
The key difference is in the child component

* The *AfterView* hooks concern `ViewChildren`, the child components whose element tags
appear *within* the component's template.

* The *AfterContent* hooks concern `ContentChildren`, the child components that Angular
projected into the component.

The following *AfterContent* hooks take action based on changing values in a  *content child*
which can only be reached by querying for it via the property decorated with
[@ContentChild](/api/angular2/angular2.core/ContentChild-class.html).

<?code-excerpt "lib/src/after_content_component.dart (class excerpts)" region="hooks" title?>
```
  class AfterContentComponent implements AfterContentChecked, AfterContentInit {
    String _prevHero = '';
    String comment = '';

    // Query for a CONTENT child of type `ChildComponent`
    @ContentChild(ChildComponent)
    ChildComponent contentChild;

    ngAfterContentInit() {
      // contentChild is set after the content has been initialized
      _logIt('AfterContentInit');
      _doSomething();
    }

    ngAfterContentChecked() {
      // contentChild is updated after the content has been checked
      if (_prevHero == contentChild?.hero) {
        _logIt('AfterContentChecked (no change)');
      } else {
        _prevHero = contentChild?.hero;
        _logIt('AfterContentChecked');
        _doSomething();
      }
    }

    // ...
  }
```

<div id="no-unidirectional-flow-worries"></div>
### No unidirectional flow worries with _AfterContent..._

This component's `doSomething` method update's the component's data-bound `comment` property immediately.
There's no [need to wait](#wait-a-tick).

Recall that Angular calls both *AfterContent* hooks before calling either of the *AfterView* hooks.
Angular completes composition of the projected content *before* finishing the composition of this component's view.
There is a small window between the `AfterContent...` and `AfterView...` hooks to modify the host view.
