---
layout: angular
title: User Input
description: User input triggers DOM events. We listen to those events with event bindings that funnel updated values back into our components and models.
sideNavGroup: basic
prevpage:
  title: Displaying Data
  url: /angular/guide/displaying-data
nextpage:
  title: Forms
  url: /angular/guide/forms
---
<!-- FilePath: src/angular/guide/user-input.md -->
<?code-excerpt path-base="user-input"?>

When the user clicks a link, pushes a button, or enters text
we want to know about it. These user actions all raise DOM events.
In this chapter we learn to bind to those events using the Angular
event binding syntax.

Run the <live-example></live-example>.

## Binding to user input events

We can use [Angular event bindings](./template-syntax.html#event-binding)
to respond to [any DOM event](https://developer.mozilla.org/en-US/docs/Web/Events).

The syntax is simple. We surround the DOM event name with
parentheses and assign a quoted template statement to it.
As an example, here's an event binding that implements a click handler:

<?code-excerpt "lib/src/click_me_component.dart (click-me button)"?>
```html
  <button (click)="onClickMe()">Click me!</button>
```

<a id="click"></a>
The `(click)` to the left of the equal sign identifies the button's click event as the **target of the binding**.
The text within quotes on the right is the **template statement** in which we
respond to the click event by calling the component's `onClickMe` method. A [template statement](./template-syntax.html#template-statements) is a subset
of Dart with restrictions and a few added tricks.

When writing a binding we must be aware of a template statement's **execution context**.
The identifiers appearing within a statement belong to a specific context object.
That object is usually the Angular component that controls the template  ... which it definitely is
in this case because that snippet of HTML belongs to the following component:

<?code-excerpt "lib/src/click_me_component.dart (click-me component)" title?>
```
  @Component(
    selector: 'click-me',
    template: '''
      <button (click)="onClickMe()">Click me!</button>
      {!{clickMessage}!}
    ''',
  )
  class ClickMeComponent {
    String clickMessage = '';

    void onClickMe() => clickMessage = 'You are my hero!';
  }
```

When the user clicks the button, Angular calls the component's `onClickMe` method.

## Get user input from the $event object

We can bind to all kinds of events. Let's bind to the keyup event of an input box and replay
what the user types back onto the screen.

This time we'll (1) listen to an event and (2) grab the user's input.

<?code-excerpt "lib/src/keyup_components.dart (template v1)" region="key-up-component-1-template" title?>
```
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{!{values}!}</p>
  ''',
```

Angular makes an event object available in the **`$event`** variable,
which we pass to the component's `onKey()` method.
The user data we want is in that variable somewhere.

<div class="callout is-important" markdown="1">
  <header> $event vs. \$event</header>
  Templates in Dart files need a `\` in front of the `$`.
  If the template is in an HTML file, use `$event` instead of `\$event`.
</div>

<?code-excerpt "lib/src/keyup_components.dart (class v1)" region="key-up-component-1-class-no-type" title?>
```
  class KeyUpComponentV1 {
    String values = '';

    onKey(dynamic event) {
      values += event.target.value + ' | ';
    }
  }
```

The shape of the `$event` object is determined by whatever raises the event.
The `keyup` event comes from the DOM, so `$event` must be a [standard DOM event object](https://developer.mozilla.org/en-US/docs/Web/API/Event).
The `$event.target` gives us an
[`HTMLInputElement`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement), which
has a `value` property that contains our user input data.

The `onKey()` component method is where we extract the user's input
from the event object, adding that input to the list of user data that we're accumulating in the component's `values` property.
We then use [interpolation](./template-syntax.html#interpolation)
to display the accumulating `values` property back on screen.

Enter the letters "abc", and then backspace to remove them.
Here's what the UI displays:

```nocode
  a | ab | abc | ab | a | |
```

<img class="image-display" src="{% asset_path 'ng/devguide/user-input/keyup1-anim.gif' %}" alt="key up 1">

<a id="keyup1"></a>
<div class="l-sub-section" markdown="1">
  We declare the `$event` as a `dynamic` type, which means we've abandoned strong typing
  to simplify our code. We generally prefer the strong typing that Dart affords.
  We can rewrite the method, casting to HTML DOM objects like this.

<?code-excerpt "lib/src/keyup_components.dart (class v1 - strongly typed )" region="key-up-component-1-class" title?>
```
  class KeyUpComponentV1 {
    String values = '';

    onKey(KeyboardEvent event) {
      InputElement el = event.target;
      values += '${el.value}  | ';
    }
  }
```

  Strong typing reveals a serious problem with passing a DOM event into the method:
  too much awareness of template details, too little separation of concerns.

  We'll address this problem in our next try at processing user keystrokes.
</div>


## Get user input from a template reference variable

There's another way to get the user data without the `$event` variable.

Angular has a syntax feature called [**template reference variables**](./template-syntax.html#ref-vars).
These variables grant us direct access to an element.
We declare a template reference variable by preceding an identifier with a hash/pound character (#).

Here's an example of using a template reference variable
to implement a clever keystroke loopback in an ultra-simple template.

<?code-excerpt "lib/src/loop_back_component.dart" region="loop-back-component" title?>
```
  @Component(
    selector: 'loop-back',
    template: '''
      <input #box (keyup)="0">
      <p>{!{box.value}!}</p>
    ''',
  )
  class LoopBackComponent {}
```

We've declared a template reference variable named `box` on the `<input>` element.
The `box` variable is a reference to the `<input>` element itself, which means we can
grab the input element's `value` and display it
with interpolation between `<p>` tags.

The template is completely self contained. It doesn't bind to the component,
and the component does nothing.

Type in the input box, and watch the display update with each keystroke. *Voila!*

<img class="image-display" src="{% asset_path 'ng/devguide/user-input/keyup-loop-back-anim.gif' %}" alt="loop back">

<div class="l-sub-section" markdown="1">
  **This won't work at all unless we bind to an event**.

  Angular only updates the bindings (and therefore the screen)
  if we do something in response to asynchronous events such as keystrokes.

  That's why we bind the `keyup` event to a statement that does ... well, nothing.
  We're binding to the number 0, the shortest statement we can think of.
  That is all it takes to keep Angular happy. We said it would be clever!
</div>

That template reference variable is intriguing. It's clearly easier to get to the textbox with that
variable than to go through the `$event` object. Maybe we can rewrite our previous
keyup example so that it uses the variable to get the user's input. Let's give it a try.

<?code-excerpt "lib/src/keyup_components.dart (v2)" region="key-up-component-2" title?>
```
  @Component(
    selector: 'key-up2',
    template: '''
      <input #box (keyup)="onKey(box.value)">
      <p>{!{values}!}</p>
    ''',
  )
  class KeyUpComponentV2 {
    String values = '';
    onKey(value) => values += '$value | ';
  }
```

That sure seems easier.
An especially nice aspect of this approach is that our component code gets clean data values from the view.
It no longer requires knowledge of the `$event` and its structure.

<a id="key-event"></a>
## Key event filtering (with `key.enter`)

Perhaps we don't care about every keystroke.
Maybe we're only interested in the input box value when the user presses Enter, and we'd like to ignore all other keys.
When we bind to the `(keyup)` event, our event handling statement hears *every keystroke*.
We could filter the keys first, examining every `$event.keyCode`, and update the `values` property only if the key is Enter.

Angular can filter the key events for us. Angular has a special syntax for keyboard events.
We can listen for just the Enter key by binding to Angular's `keyup.enter` pseudo-event.

Only then do we update the component's `values` property. (In this example,
the update happens inside the event binding statement. A better practice
would be to put the update code in the component.)

<?code-excerpt "lib/src/keyup_components.dart (v3)" region="key-up-component-3" title?>
```
  @Component(
    selector: 'key-up3',
    template: '''
      <input #box (keyup.enter)="values=box.value">
      <p>{!{values}!}</p>
    ''',
  )
  class KeyUpComponentV3 {
    String values = '';
  }
```

Here's how it works.

<img class="image-display" src="{% asset_path 'ng/devguide/user-input/keyup3-anim.gif' %}" alt="key up 3">

## On blur

Our previous example won't transfer the current state of the input box if the user mouses away and clicks
elsewhere on the page. We update the component's `values` property only when the user presses Enter
while the focus is inside the input box.

Let's fix that by listening to the input box's blur event as well.

<?code-excerpt "lib/src/keyup_components.dart (v4)" region="key-up-component-4" title?>
```
  @Component(
    selector: 'key-up4',
    template: '''
      <input #box
        (keyup.enter)="values=box.value"
        (blur)="values=box.value">
      <p>{!{values}!}</p>
    ''',
  )
  class KeyUpComponentV4 {
    String values = '';
  }
```

## Put it all together

We learned how to [display data](./displaying-data.html) in the previous chapter.
We've acquired a small arsenal of event binding techniques in this chapter.

Let's put it all together in a micro-app
that can display a list of heroes and add new heroes to that list.
The user can add a hero by first typing in the input box and then
pressing Enter, clicking the Add button, or clicking elsewhere on the page.

<img class="image-display" src="{% asset_path 'ng/devguide/user-input/little-tour-anim.gif' %}" alt="Little Tour of Heroes">

Below is the "Little Tour of Heroes"  component.
We'll call out the highlights after we bask briefly in its minimalist glory.

<?code-excerpt "lib/src/little_tour_component.dart (little-tour)" title?>
```
  @Component(
    selector: 'little-tour',
    template: '''
      <input #newHero
        (keyup.enter)="addHero(newHero.value)"
        (blur)="addHero(newHero.value); newHero.value='' ">

      <button (click)="addHero(newHero.value)">Add</button>

      <ul><li *ngFor="let hero of heroes">{!{hero}!}</li></ul>
    ''',
    directives: const [COMMON_DIRECTIVES],
  )
  class LittleTourComponent {
    List<String> heroes = ['Windstorm', 'Bombasto', 'Magneta', 'Tornado'];

    void addHero(String newHero) {
      if (newHero?.length > 0) {
        heroes.add(newHero);
      }
    }
  }
```

We've seen almost everything here before. A few things are new or bear repeating.

### Use template variables to refer to elements

The `newHero` template variable refers to the `<input>` element.
We can use `newHero` from any sibling or child of the `<input>` element.

Getting the element from a template variable makes the button click handler
simpler. Without the variable, we'd have to use a fancy CSS selector
to find the input element.

### Pass values, not elements

We could have passed the `newHero` into the component's `addHero` method.

But that would require `addHero` to pick its way through the `<input>` DOM element,
something we learned to dislike in our first try at a [keyup component](#keyup1).

Instead, we grab the input box *value* and pass *that* to `addHero`.
The component knows nothing about HTML or the DOM, which is the way we like it.

### Keep template statements simple

We bound `(blur)` to *two* Dart statements.

We like the first one, which calls `addHero`.
We do not like the second one, which assigns an empty string to the input box value.

The second statement exists for a good reason. We have to clear the input box after adding the new hero to the list.
The component has no way to do that itself because it has no access to the
input box (our design choice).

Although the example *works*, we are rightly wary of Dart in HTML.
Template statements are powerful. We're supposed to use them responsibly.
Complex Dart in HTML is irresponsible.

Should we reconsider our reluctance to pass the input box into the component?

There should be a better third way. And there is, as we'll see when we learn about `NgModel` in the [Forms](forms.html) chapter.

## Source code

Here is all the code we talked about in this chapter.

<code-tabs>
  <?code-pane "lib/src/click_me_component.dart"?>
  <?code-pane "lib/src/keyup_components.dart"?>
  <?code-pane "lib/src/loop_back_component.dart"?>
  <?code-pane "lib/src/little_tour_component.dart"?>
</code-tabs>

## Summary

We've mastered the basic primitives for responding to user input and gestures.
As powerful as these primitives are, they are a bit clumsy for handling
large amounts of user input. We're operating down at the low level of events when
we should be writing two-way bindings between data entry fields and model properties.

Angular has a two-way binding called `NgModel`, which we'll learn about
in the `Forms` chapter.
