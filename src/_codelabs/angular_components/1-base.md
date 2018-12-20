---
layout: components
title: "Step 1: Get to Know the Software"
description: "Get the base app for the codelab, and play with the AngularDart Component demo."
nextpage:
  url: /codelabs/angular_components/2-starteasy
  title: "Step 2: Start Using AngularDart Components"
prevpage:
  url: /codelabs/angular_components
  title: "Codelab: AngularDart Components"
css: [styles.css]
---

In this step, you’ll download the code for the app, and you’ll familiarize yourself with both the app and the components you’ll be adding to it.

{% include_relative _run_example.md %}

## <i class="far fa-money-bill-alt fa-sm"> </i> Get the app code

All the code for this codelab is in the `angular-examples/lottery` GitHub repo.

1. Go to the [angular-examples/lottery repo page]({{site.ghNgEx}}/lottery/tree/{{site.branch}}).
2. Click **Clone or download**.
3. Get the code, either by cloning the repo
   {%- if site.branch != 'master' %} (`{{site.branch}}` branch){% endif %}
   or by clicking **Download ZIP**.

## <i class="far fa-money-bill-alt fa-sm"> </i> Get familiar with the base app

The base app—the app you’ll be starting from—is in the `1-base` directory.

 1. Get the base app's dependencies. For example:

    ```terminal
    > cd 1-base
    > pub get
    ```

 2. Use the tool of your choice to run the base app.

    For example, you could use `webdev` to [serve the app](/tools/webdev#serve),
    and then visit [localhost:8080](http://localhost:8080){: .no-automatic-external} in Chrome.

 3. Play with the base app. It works, but it’s not pretty. Consider these issues:

    * The app doesn’t adhere to Google’s
      [Material Design guidelines](https://material.google.com).
    * The buttons would be prettier and easier to understand if they had images.
    * The user must scroll to see the whole UI.
    * Settings are visible even when the user has no interest in changing them.

To fix the base app's UI issues,
you’ll need to modify most of its custom components.
The following table describes each of the custom components in the app.
You don't need implement any other custom components;
you'll just modify these ones to use AngularDart Components in place of
some of their vanilla HTML elements.

|--------------------------+------------------------------------------------|
| Custom component         | What it does                                   |
|--------------------------|------------------------------------------------|
| `<lottery-simulator>`{:.text-nowrap}  | As the root of the app’s Angular component hierarchy, contains all the other components. |
| `<visualize-winnings>`{:.text-nowrap} | Presents an attractive, animated view of lottery wins and losses. This is the only component you won’t need to change. |
| `<stats-component>`{:.text-nowrap}    | Textually presents lottery wins and losses. |
| `<scores-component>`{:.text-nowrap}   | Displays the results of betting and investing. |
| `<settings-component>`{:.text-nowrap} | Allows the user to change the app’s settings. |
| `<help-component>`{:.text-nowrap}     | Displays help content. |
{:.table .table-striped}

## <i class="far fa-money-bill-alt fa-sm"> </i> Get familiar with AngularDart Components

Play with the [AngularDart Gallery,]({{site.acx_gallery}})
which lists the AngularDart Components and has interactive examples
of using them.
Optionally, look at the gallery's
[source code.](https://github.com/dart-lang/angular_components_example)

Think about how AngularDart Components might improve the app.
The rest of this codelab leads you through making the following changes:

- Improving the progress bar by changing `<progress>` to `<material-progress>`.
- Adding small, pre-packaged images by changing text to `<material-icon>` components.
- Displaying small amounts of data in a more compelling way with `<acx-scorecard>`.
- Changing `<button>` and button-like `<input>` elements to specialized components:
    - `<material-fab>`
    - `<material-toggle>`
    - `<material-checkbox>`
    - `<material-radio-group>` and `<material-radio>`
- Reimplementing settings to use expansion panels, to hide controls until they’re needed:
    - `<material-expansionpanel-set>`
    - `<material-expansionpanel>`
- Dividing the UI into three tabs &mdash; **Simulation**, **Help**, and
  **About** &mdash; by putting most of the UI into three `<material-tab>`
  components inside a `<material-tab-panel>`.
