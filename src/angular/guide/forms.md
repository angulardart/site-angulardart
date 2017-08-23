---
layout: angular
title: Forms
description: A form creates a cohesive, effective, and compelling data entry experience. An Angular form coordinates a set of data-bound user controls, tracks changes, validates input, and presents errors.
sideNavGroup: basic
prevpage:
  title: User Input
  url: /angular/guide/user-input
nextpage:
  title: Dependency Injection
  url: /angular/guide/dependency-injection
---
<!-- FilePath: src/angular/guide/forms.md -->
<?code-excerpt path-base="forms"?>
{{page.description}}

We’ve all used a form to log in, submit a help request, place an order, book a flight,
schedule a meeting, and perform countless other data entry tasks.
Forms are the mainstay of business applications.

Any seasoned web developer can slap together an HTML form with all the right tags.
It's more challenging to create a cohesive data entry experience that guides the
user efficiently and effectively through the workflow behind the form.

*That* takes design skills that are, to be frank, well out of scope for this guide.

It also takes framework support for
**two-way data binding, change tracking, validation, and error handling**
... which we shall cover in this guide on Angular forms.

We will build a simple form from scratch, one step at a time. Along the way we'll learn how to:

- Build an Angular form with a component and template
- Use `ngModel` to create two-way data bindings for reading and writing input control values
- Track state changes and the validity of form controls
- Provide visual feedback using special CSS classes that track the state of the controls
- Display validation errors to users and enable/disable form controls
- Share information across HTML elements using template reference variables

Run the <live-example></live-example>.

## Template-driven forms

Many of us will build forms by writing templates in the Angular [template syntax](./template-syntax.html) with
the form-specific directives and techniques described in this guide.

<div class="l-sub-section" markdown="1">
  That's not the only way to create a form but it's the way we'll cover in this guide.
</div>

We can build almost any form we need with an Angular template &mdash; login forms, contact forms, pretty much any business form.
We can lay out the controls creatively, bind them to data, specify validation rules and display validation errors,
conditionally enable or disable specific controls, trigger built-in visual feedback, and much more.

It will be pretty easy because Angular handles many of the repetitive, boilerplate tasks we'd
otherwise wrestle with ourselves.

We'll discuss and learn to build a template-driven form that looks like this:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/hero-form-1.png' %}" width="432" alt="Clean Form">

Here at the *Hero Employment Agency* we use this form to maintain personal information about heroes.
Every hero needs a job. It's our company mission to match the right hero with the right crisis!

Two of the three fields on this form are required. Required fields have a green bar on the left to make them easy to spot.

If we delete the hero name, the form displays a validation error in an attention-grabbing style:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/hero-form-2.png' %}" width="432" alt="Invalid, Name Required">

Note that the submit button is disabled, and the "required" bar to the left of the input control changed from green to red.

<div class="l-sub-section" markdown="1">
  We'll customize the colors and location of the "required" bar with standard CSS.
</div>

We'll build this form in small steps:

1. Create the `Hero` model class.
1. Create the component that controls the form.
1. Create a template with the initial form layout.
1. Bind data properties to each form control using the `ngModel` two-way data binding syntax.
1. Add an **ngControl** directive to each form input control.
1. Add custom CSS to provide visual feedback.
1. Show and hide validation error messages.
1. Handle form submission with **ngSubmit**.
1. Disable the form’s submit button until the form is valid.

## Setup

Follow the [setup](setup.html) instructions for creating a new project
named `angular_forms`.

## Create the Hero model class

As users enter form data, we'll capture their changes and update an instance of a model.
We can't lay out the form until we know what the model looks like.

A model can be as simple as a "property bag" that holds facts about a thing of application importance.
That describes well our `Hero` class with its three required fields (`id`, `name`, `power`)
and one optional field (`alterEgo`).

In the `lib` directory, create the following file with the given content:

<?code-excerpt "lib/src/hero.dart" title linenums?>
```
  class Hero {
    int id;
    String name, power, alterEgo;

    Hero(this.id, this.name, this.power, [this.alterEgo]);

    String toString() => '$id: $name ($alterEgo). Super power: $power';
  }
```

It's an anemic model with few requirements and no behavior. Perfect for our demo.

The `alterEgo` is optional, so the constructor lets us omit it: note the
`[]` in `[this.alterEgo]`.

We can create a new hero like this:

<?code-excerpt "lib/src/hero_form_component.dart" region="SkyDog"?>
```
  var myHero = new Hero(
      42, 'SkyDog', 'Fetch any object at any distance', 'Leslie Rollover');
  print('My hero is ${myHero.name}.'); // "My hero is SkyDog."
```

## Create a form component

An Angular form has two parts: an HTML-based _template_ and a component _class_
to handle data and user interactions programmatically.
We begin with the class because it states, in brief, what the hero editor can do.

Create the following file with the given content:

<?code-excerpt "lib/src/hero_form_component.dart (v1)" title?>
```
  import 'package:angular2/angular2.dart';

  import 'hero.dart';

  const List<String> _powers = const [
    'Really Smart',
    'Super Flexible',
    'Super Hot',
    'Weather Changer'
  ];

  @Component(
    selector: 'hero-form',
    templateUrl: 'hero_form_component.html',
    directives: const [COMMON_DIRECTIVES],
  )
  class HeroFormComponent {
    List<String> get powers => _powers;
    Hero model = new Hero(18, 'Dr IQ', _powers[0], 'Chuck Overstreet');
    bool submitted = false;

    void onSubmit() {
      submitted = true;
    }

    // TODO: Remove this when we're done
    String get diagnostic => 'DIAGNOSTIC: $model';
  }
```

There’s nothing special about this component, nothing form-specific,
nothing to distinguish it from any component we've written before.

Understanding this component requires only the Angular concepts covered in previous guides.

1. The code imports the main Angular library, and the `Hero` model we just created.
1. The `@Component` selector value of "hero-form" means we can drop this form in a parent template with a `<hero-form>` tag.
1. The `templateUrl` property points to a separate file for the template HTML.
1. We defined dummy data for `model` and `powers`, as befits a demo.
Down the road, we can inject a data service to get and save real data
or perhaps expose these properties as
[inputs and outputs](./template-syntax.html#inputs-outputs) for binding to a
parent component. None of this concerns us now and these future changes won't affect our form.
1. We threw in a `diagnostic` property to return a string describing our model.
It'll help us see what we're doing during our development; we've left ourselves a cleanup note to discard it later.

## Revise *app_component.dart*

`AppComponent` is the application's root component. It will host our new `HeroFormComponent`.

Replace the contents of the starter app version with the following:

<?code-excerpt "lib/app_component.dart" title?>
```
  import 'package:angular2/angular2.dart';

  import 'src/hero_form_component.dart';

  @Component(
    selector: 'my-app',
    template: '<hero-form></hero-form>',
    directives: const [HeroFormComponent],
  )
  class AppComponent {}
```

## Create an initial HTML form template

Create the new template file with the following contents:

<?code-excerpt "lib/src/hero_form_component_1.html (start)" title?>
```
  <div class="container">
    <h1>Hero Form</h1>
    <form>
      <div class="form-group">
        <label for="name">Name</label>
        <input type="text" class="form-control" id="name" required>
      </div>
      <div class="form-group">
        <label for="alterEgo">Alter Ego</label>
        <input type="text" class="form-control" id="alterEgo">
      </div>
      <button type="submit" class="btn btn-default">Submit</button>
    </form>
  </div>
```

That is plain old HTML 5. We're presenting two of the `Hero` fields, `name` and `alterEgo`, and
opening them up for user input in input boxes.

The *Name* `<input>` control has the HTML5 `required` attribute;
the *Alter Ego* `<input>` control does not because `alterEgo` is optional.

We've got a *Submit* button at the bottom with some classes on it for styling.

**We are not using Angular yet**. There are no bindings, no extra directives, just layout.

The `container`, `form-group`, `form-control`, and `btn` classes
come from [Twitter Bootstrap](http://getbootstrap.com/css/). Purely cosmetic.
We're using Bootstrap to give the form a little style!

<div class="callout is-important" markdown="1">
  <header>Angular forms do not require a style library</header>
  Angular makes no use of the `container`, `form-group`, `form-control`, and `btn` classes or
  the styles of any external library. Angular apps can use any CSS library, or none at all.
</div>

Let's add the stylesheet. Open `index.html` and add the following link to the `<head>`:

<?code-excerpt "web/index.html (bootstrap)" title?>
```
  <link rel="stylesheet"
        href="https://unpkg.com/bootstrap@3.3.7/dist/css/bootstrap.min.css">
```

## Add powers with _*ngFor_

Our hero must choose one super power from a fixed list of Agency-approved powers.
We maintain that list internally (in `HeroFormComponent`).

We'll add a `select` to our
form and bind the options to the `powers` list using `ngFor`,
a technique seen previously in the [Displaying Data](./displaying-data.html) guide.

Add the following HTML *immediately below* the *Alter Ego* group:

<?code-excerpt "lib/src/hero_form_component_1.html (powers)" title?>
```
  <div class="form-group">
    <label for="power">Hero Power</label>
    <select class="form-control" id="power" required>
      <option *ngFor="let p of powers" [value]="p">{!{p}!}</option>
    </select>
  </div>
```

This code repeats the `<option>` tag for each power in the list of powers.
The `p` template input variable is a different power in each iteration;
we display its name using the interpolation syntax.

<a id="ngModel"></a>
## Two-way data binding with _ngModel_

Running the app right now would be disappointing.

<img class="image-display" src="{% asset_path 'ng/devguide/forms/hero-form-3.png' %}" width="432" alt="Early form with no binding">

We don't see hero data because we are not binding to the `Hero` yet.
We know how to do that from earlier guides.
[Displaying Data](./displaying-data.html) taught us property binding.
[User Input](./user-input.html) showed us how to listen for DOM events with an
event binding and how to update a component property with the displayed value.

Now we need to display, listen, and extract at the same time.

We could use the techniques we already know, but
instead we'll introduce something new: the `[(ngModel)]` syntax, which
makes binding the form to the model super easy.

Find the `<input>` tag for *Name* and update it like this:

<?code-excerpt "lib/src/hero_form_component_2.html (name)" title?>
```
  <input type="text" class="form-control" id="name" required
         [(ngModel)]="model.name"
         ngControl="name">
  TODO: remove this: {!{model.name}!}
```

<div class="l-sub-section" markdown="1">
  We added a diagnostic interpolation after the input tag
  so we can see what we're doing.
  We left ourselves a note to throw it away when we're done.
</div>

Focus on the binding syntax: `[(ngModel)]="..."`.

If we run the app right now and started typing in the *Name* input box,
adding and deleting characters, we'd see them appearing and disappearing
from the interpolated text.
At some point it might look like this.

<img class="image-display" src="{% asset_path 'ng/devguide/forms/ng-model-in-action.png' %}" width="432" alt="ngModel in action">

The diagnostic is evidence that values really are flowing from the input box to the model and
back again.

<div class="l-sub-section" markdown="1">
  That's **two-way data binding**!
  For more information about `[(ngModel)]` and two-way data bindings, see
  the [Template Syntax](template-syntax.html#ngModel) page.
</div>

Notice that we also added an `ngControl` directive to our `<input>` tag and set it to "name"
which makes sense for the hero's name. Any unique value will do, but using a descriptive name is helpful.
Defining an `ngControl` directive is a requirement when using `[(ngModel)]` in combination with a form.

<div class="l-sub-section" markdown="1">
  Internally Angular creates `NgFormControl` instances and
  registers them with an `NgForm` directive that Angular attached to the `<form>` tag.
  Each `NgFormControl` is registered under the name we assigned to the `ngControl` directive.
  We'll talk about `NgForm` [later in this guide](#ngForm).
</div>

Let's add similar `[(ngModel)]` bindings and `ngControl` directives to *Alter Ego* and *Hero Power*.
We'll ditch the input box binding message
and add a new binding (at the top) to the component's `diagnostic` property.
Then we can confirm that two-way data binding works *for the entire hero model*.

After revision, the core of our form should look like this:

<?code-excerpt "lib/src/hero_form_component_3.html (controls)" title?>
```
  {!{diagnostic}!}
  <div class="form-group">
    <label for="name">Name</label>
    <input type="text" class="form-control" id="name" required
           [(ngModel)]="model.name"
           ngControl="name">
  </div>
  <div class="form-group">
    <label for="alterEgo">Alter Ego</label>
    <input type="text" class="form-control" id="alterEgo"
           [(ngModel)]="model.alterEgo"
           ngControl="alterEgo">
  </div>
  <div class="form-group">
    <label for="power">Hero Power</label>
    <select class="form-control" id="power" required
            [(ngModel)]="model.power"
            ngControl="power">
      <option *ngFor="let p of powers" [value]="p">{!{p}!}</option>
    </select>
  </div>
```

<div class="l-sub-section" markdown="1">
  - Each input element has an `id` property that is used by the `label` element's `for` attribute
  to match the label to its input control.
  - Each input element has a `ngControl` directive that is required by Angular forms to register the control with the form.
</div>

If we run the app now and changed every hero model property, the form might display like this:

<img class="image-display" src="images/ng-model-in-action-2.png" width="532" alt="ngModel in action">

The diagnostic near the top of the form
confirms that all of our changes are reflected in the model.

**Delete** the `{!{diagnostic}!}` binding at the top as it has served its purpose.

## Track control state and validity

A form isn't just about data binding. We'd also like to know the state of the controls in our form.
Each control in an Angular form tracks its own state and makes it available for inspection
through the following field members, as documented in the
[NgControl](/api/angular2/angular2/NgControl-class.html) API:

- `dirty` / `pristine` indicate whether the control's **value has changed**
- `touched` / `untouched` indicate whether the control has been **visited**
- `valid` reflects the control value's **validity**

## CSS classes reflecting control state

Often, a control's state is used to set CSS classes of the corresponding form element.
We can leverage those class names to change the appearance of the control.
For our demo, we'll use the following CSS classes:

<table>
  <tr><th>State                       </th><th>Class if true           </th><th>Class if false</th></tr>
  <tr><td>Control has been visited    </td><td><code>ng-touched</code> </td><td><code>ng-untouched</code></td></tr>
  <tr><td>Control's value has changed </td><td><code>ng-dirty</code>   </td><td><code>ng-pristine</code></td></tr>
  <tr><td>Control's value is valid    </td><td><code>ng-valid</code>   </td><td><code>ng-invalid</code></td></tr>
</table>

<div class="l-sub-section" markdown="1">
  These are the CSS classes used by the now deprecated
  [NgControlStatus](/api/angular2/angular2/NgControlStatus-class.html) class.
  We'll be using them in our demo. **Feel free to use these or other CSS classes.**
</div>

We'll use the following method to set a control's state-dependent CSS class names:

<?code-excerpt "lib/src/hero_form_component.dart (controlStateClasses)" title?>
```
  /// Returns a map of CSS class names representing the state of [control].
  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };
  // TODO: does this map need to be cached?
```

We'll add a [template reference variable](./template-syntax.html#ref-vars) named `name`
to the _Name_ `<input>` tag, and use it as an argument to `controlStateClasses`.
We'll use the map value returned by this method to bind to the
`NgClass` directive &mdash; read more about this directive and its alternatives in the
[template syntax](./template-syntax.html#ngClass) guide.

Let's temporarily add a [template reference variable](./template-syntax.html#ref-vars) named `spy`
to the _Name_ `<input>` tag and use it to display the input's CSS classes.

<?code-excerpt "lib/src/hero_form_component_4.html (name)" title?>
```
  <input type="text" class="form-control" id="name" required
         [(ngModel)]="model.name"
         #name="ngForm" [ngClass]="controlStateClasses(name)"
         #spy
         ngControl="name">
  TODO: remove this: {!{spy.className}!}
```

<div class="l-sub-section" markdown="1">
  The `spy` [template reference variable](./template-syntax.html#ref-vars) gets bound to the
  `<input>` DOM element, whereas the `name` variable (through the `#name="ngForm"` syntax)
  gets bound to the [NgModel](/api/angular2/angular2/NgModel-class.html)
  associated with the input element.

  Why "ngForm"?  A [Directive](/api/angular2/angular2.core/Directive-class)'s
  [exportAs](/api/angular2/angular2.core/Directive/exportAs) property tells Angular
  how to link the reference variable to the directive. We set `name` to "ngForm"
  because the [ngModel](/api/angular2/angular2/NgModel-class.html)
  directive's `exportAs` property is "ngForm".
</div>

Now run the app, and look at the _Name_ input box.
Follow the next four steps *precisely*:

1. Look but don't touch.
1. Click inside the name box, then click outside it.
1. Add slashes to the end of the name.
1. Erase the name.

The actions and effects are as follows:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/control-state-transitions-anim.gif' %}"  alt="Control State Transition">

We should see the following transitions and class names:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/ng-control-class-changes.png' %}" width="532" alt="Control state transitions">

{% comment %} Keep the textual form for now, in case we decide to drop the figure.
  The classes are displayed as follows:

  1. `form-control ng-untouched ng-valid ng-pristine` (initial state)
  1. `form-control ng-valid ng-pristine ng-touched` (after clicking)
  1. `form-control ng-valid ng-touched ng-dirty` (after changing)
  1. `form-control ng-touched ng-dirty ng-invalid` (after erasing)
{% endcomment %}

The `ng-valid`/`ng-invalid` pair is the most interesting to us, because we want to send a
strong visual signal when the values are invalid. We also want to mark required fields.
To create such visual feedback, let's add definitions for the `ng-*` CSS classes.

**Delete** the `#spy` template reference variable and the `TODO` as they have served their purpose.

## Add custom CSS for visual feedback

We can mark required fields and invalid data at the same time with a colored bar
on the left of the input box:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/validity-required-indicator.png' %}" width="432" alt="Invalid Form">

{% comment %} TODO: consider associating the CSS with a component {% endcomment %}
We achieve this effect by adding these class definitions to a new `forms.css` file:

<?code-excerpt "web/forms.css" title?>
```
  .ng-valid[required] {
    border-left: 5px solid #42A948; /* green */
  }

  .ng-invalid {
    border-left: 5px solid #a94442; /* red */
  }
```

Update the `<head>` of `index.html` to include this style sheet:

<?code-excerpt "web/index.html (styles)" title?>
```
  <link rel="stylesheet" href="styles.css">
  <link rel="stylesheet" href="forms.css">
```

## Show and hide validation error messages

We can do better. The _Name_ input box is required and clearing it turns the bar red.
That says *something* is wrong but we don't know *what* is wrong or what to do about it.
We can leverage the control's state to reveal a helpful message.

Here's the way it should look when the user deletes the name:

<img class="image-display" src="{% asset_path 'ng/devguide/forms/name-required-error.png' %}" width="432" alt="Name required">

To achieve this effect we extend the `<input>` tag with
the "*is required*" message in a nearby `<div>` which we'll display only if the control is invalid.

Here's an example of adding an error message to the _name_ input box:

<?code-excerpt "lib/src/hero_form_component.html (excerpt)" region="name-with-error-msg" title?>
```
  <label for="name">Name</label>
  <input type="text" class="form-control" id="name" required
         [(ngModel)]="model.name"
         #name="ngForm" [ngClass]="controlStateClasses(name)"
         ngControl="name">
  <div [hidden]="name.valid || name.pristine" class="alert alert-danger">
    Name is required
  </div>
```

We control visibility of the name error message by binding properties of the `name`
control to the message `<div>` element's `hidden` property.

<?code-excerpt "lib/src/hero_form_component.html" region="hidden-error-msg"?>
```
  <div [hidden]="name.valid || name.pristine" class="alert alert-danger">
    Name is required
  </div>
```

In this example, we hide the message when the control is valid or pristine;
pristine means the user hasn't changed the value since it was displayed in this form.

This user experience is the developer's choice. Some folks want to see the message at all times.
If we ignore the `pristine` state, we would hide the message only when the value is valid.
If we arrive in this component with a new (blank) hero or an invalid hero,
we'll see the error message immediately, before we've done anything.

Some folks find that behavior disconcerting.
They only want to see the message when the user makes an invalid change.
Hiding the message while the control is "pristine" achieves that goal.
{% comment %} TODO: re-introduce this sentence once the New Hero feature is added (see next TODO below)
  We'll see the significance of this choice when we [add a new hero](#new-hero) to the form.
{% endcomment %}
The hero *Alter Ego* is optional so we can leave that be.

Hero *Power* selection is required.
We can add the same kind of error handling to the `<select>` if we  want,
but it's not imperative because the selection box already constrains the
power to valid values.

{% comment %}
  //- TODO: the following is in the TS version of the page; consider adding it.
  //-  We'd like to add a new hero in this form.
  //-  We place a "New Hero" button at the bottom of the form and bind its click event to a `newHero` component method.
  //-
  //-+makeExample('forms/ts/app/hero-form.component.html',
  //-  'new-hero-button-no-reset',
  //-  'app/hero-form.component.html (New Hero button)')
  //-
  //-+makeExample('forms/ts/app/hero-form.component.ts',
  //-  'new-hero',
  //-  'app/hero-form.component.ts (New Hero method)')(format=".")

  Run the application again, click the *New Hero* button, and the form clears.
  The *required* bars to the left of the input box are red, indicating invalid `name` and `power` properties.
  That's understandable as these are required fields.
  The error messages are hidden because the form is pristine; we haven't changed anything yet.

  Enter a name and click *New Hero* again.
  The app displays a **_Name is required_** error message!
  We don't want error messages when we create a new (empty) hero.
  Why are we getting one now?

  Inspecting the element in the browser tools reveals that the *name* input box is _no longer pristine_.
  The form remembers that we entered a name before clicking *New Hero*.
  Replacing the hero object *did not restore the pristine state* of the form controls.

  We have to clear all of the flags imperatively which we can do
  by calling the form's `reset()` method after calling the `newHero()` method.

  //-+makeExample('forms/ts/app/hero-form.component.html', 'new-hero-button-form-reset', 'app/hero-form.component.html (Reset the form)')

  Now clicking "New Hero" both resets the form and its control flags.
{% endcomment %}

## Submit the form with _ngSubmit_

The user should be able to submit this form after filling it in.
The Submit button at the bottom of the form
does nothing on its own, but it will
trigger a form submit because of its type (`type="submit"`).

A "form submit" is useless at the moment.
To make it useful, bind the form's `ngSubmit` event property
to the hero form component's `onSubmit()` method:

<?code-excerpt "lib/src/hero_form_component.html (ngSubmit)"?>
```
  <form (ngSubmit)="onSubmit()" #heroForm="ngForm">
```

We slipped in something extra there at the end!  We defined a
template reference variable, **`#heroForm`**, and initialized it with the value "ngForm".

The variable `heroForm` is now a reference to the `NgForm` directive that governs the form as a whole.

<a id="ngForm"></a>
<div class="l-sub-section" markdown="1">
### The _NgForm_ directive

  What `NgForm` directive?
  We didn't add an [NgForm](/api/angular2/angular2/NgForm-class) directive!

  Angular did. Angular creates and attaches an `NgForm` directive to the `<form>` tag automatically.

  The `NgForm` directive supplements the `form` element with additional features.
  It holds the controls we created for the elements with `ngModel` and `ngControl` directives,
  and monitors their properties including their validity.
  It also has its own `valid` property which is true only _if every contained control_ is valid.
</div>

We'll bind the form's overall validity via
the `heroForm` variable to the button's `disabled` property
using an event binding. Here's the code:

<?code-excerpt "lib/src/hero_form_component.html" region="submit-button"?>
```
  <button type="submit" class="btn btn-default"
          [disabled]="!heroForm.form.valid">Submit</button>
```

If we run the application now, we find that the button is enabled
&mdash; although it doesn't do anything useful yet.

Now if we delete the Name, we violate the "required" rule, which
is duly noted in the error message.
The Submit button is also disabled.

Not impressed?  Think about it for a moment. What would we have to do to
wire the button's enable/disabled state to the form's validity without Angular's help?

For us, it was as simple as:

1. Define a template reference variable on the (enhanced) form element.
2. Refer to that variable in a button many lines away.

## Toggle two form regions (extra credit)

Submitting the form isn't terribly dramatic at the moment.

<div class="l-sub-section" markdown="1">
  An unsurprising observation for a demo. To be honest,
  jazzing it up won't teach us anything new about forms.
  But this is an opportunity to exercise some of our newly won
  binding skills.
  If you aren't interested, go ahead and skip to this guide's conclusion.
</div>

Let's do something more strikingly visual.
Let's hide the data entry area and display something else.

Start by wrapping the form in a `<div>` and bind
its `hidden` property to the `HeroFormComponent.submitted` property.

<?code-excerpt "lib/src/hero_form_component.html (excerpt)" region="edit-div" title?>
```
  <div [hidden]="submitted">
    <h1>Hero Form</h1>
    <form (ngSubmit)="onSubmit()" #heroForm="ngForm">
    </form>
  </div>
```

The main form is visible from the start because the
`submitted` property is false until we submit the form,
as this fragment from the `HeroFormComponent` shows:

<?code-excerpt "lib/src/hero_form_component.dart (submitted)" title?>
```
  bool submitted = false;

  void onSubmit() {
    submitted = true;
  }
```

When we click the Submit button, the `submitted` flag becomes true and the form disappears
as planned.

Now the app needs to show something else while the form is in the submitted state.
Add the following HTML below the `<div>` wrapper we just wrote:

<?code-excerpt "lib/src/hero_form_component.html (submitted)" title?>
```
  <div [hidden]="!submitted">
    <h2>You submitted the following:</h2>
    <div class="row">
      <div class="col-xs-3">Name</div>
      <div class="col-xs-9  pull-left">{!{ model.name }!}</div>
    </div>
    <div class="row">
      <div class="col-xs-3">Alter Ego</div>
      <div class="col-xs-9 pull-left">{!{ model.alterEgo }!}</div>
    </div>
    <div class="row">
      <div class="col-xs-3">Power</div>
      <div class="col-xs-9 pull-left">{!{ model.power }!}</div>
    </div>
    <br>
    <button class="btn btn-default" (click)="submitted=false">Edit</button>
  </div>
```

There's our hero again, displayed read-only with interpolation bindings.
This `<div>` appears only while the component is in the submitted state.

The HTML includes an _Edit_ button whose click event is bound to an expression
that clears the `submitted` flag.

When we click the _Edit_ button, this block disappears and the editable form reappears.

That's as much drama as we can muster for now.

## Conclusion

The Angular form discussed in this guide takes advantage of the following
framework features to provide support for data modification, validation, and more:

- An Angular HTML form template.
- A form component class with an `@Component` annotation.
- Handling form submission by binding to the `NgForm.ngSubmit` event property.
- Template reference variables such as `#heroForm` and `#name`.
- `[(ngModel)]` syntax for two-way data binding.
- The `ngControl` directive for validation and form element change tracking.
- The reference variable’s `valid` property on input controls to check if a control is valid and show/hide error messages.
- Controlling the submit button's enabled state by binding to `NgForm` validity.
- Custom CSS classes that provide visual feedback to users about invalid controls.

Our final project folder structure should look like this:

<div class="ul-filetree" markdown="1">
- angular_forms
  - lib
    - app_component.dart
    - src
      - hero.dart
      - hero_form_component.dart
      - hero_form_component.html
  - web
    - forms.css
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

Here’s the code for the final version of the application:

<code-tabs>
  <?code-pane "lib/app_component.dart"?>
  <?code-pane "lib/src/hero.dart"?>
  <?code-pane "lib/src/hero_form_component.dart" region="final"?>
  <?code-pane "lib/src/hero_form_component.html"?>
  <?code-pane "web/forms.css"?>
  <?code-pane "web/index.html"?>
  <?code-pane "web/main.dart"?>
</code-tabs>
