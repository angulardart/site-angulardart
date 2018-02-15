---
title: "Step 1: Get to Know the Software"
description: "Get the base app for the codelab, and play with the AngularDart Component demo."
nextpage:
  url: /codelabs/angular_components/2-starteasy
  title: "Step 2: Start Using AngularDart Components"
prevpage:
  url: /codelabs/angular_components
  title: "Codelab: AngularDart Components"
css: [ styles.css ]
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

The base app—the app you’ll be starting from—is in the **1-base** directory.

<ol markdown="1">
<li>
  <p> Get the base app's dependencies. For example: </p>

{% comment %}
html prettifying is better than bash here:
{% endcomment %}

{% prettify html %}
cd 1-base
pub get
{% endprettify %}
</li>

<li markdown="1">
Use the tools of your choice to run the base app.

For example, you could use `pub serve` and then visit [localhost:8080](http://localhost:8080){: .no-automatic-external}
in any modern web browser. Or you could use WebStorm to run the app in Dartium.
</li>

{% include dartium-2.0.html %}

<li markdown="1">
Play with the base app. It works, but it’s not pretty. Consider these issues:

* The app doesn’t adhere to Google’s
  [Material Design guidelines](https://material.google.com).
* The buttons would be prettier and easier to understand if they had images.
* The user must scroll to see the whole UI.
* Settings are visible even when the user has no interest in changing them.
</li></ol>

To fix the base app's UI issues,
you’ll need to modify most of its custom components.
The following table describes each of the custom components in the app.
You don't need implement any other custom components;
you'll just modify these ones to use AngularDart Components in place of
some of their vanilla HTML elements.

|--------------------------+------------------------------------------------|
| Custom component         | What it does                                   |
|--------------------------|------------------------------------------------|
| <nobr>&lt;lottery-simulator></nobr>  | As the root of the app’s Angular component hierarchy, contains all the other components. |
| <nobr>&lt;visualize-winnings></nobr> | Presents an attractive, animated view of lottery wins and losses. This is the only component you won’t need to change. |
| <nobr>&lt;stats-component></nobr>    | Textually presents lottery wins and losses. |
| <nobr>&lt;scores-component></nobr>   | Displays the results of betting and investing. |
| <nobr>&lt;settings-component></nobr> | Allows the user to change the app’s settings. |
| <nobr>&lt;help-component></nobr>     | Displays help content. |
{:.table .table-striped}


## <i class="far fa-money-bill-alt fa-sm"> </i> Get familiar with AngularDart Components

Run the [AngularDart Components demo.](/examples/lottery/4-final/)
Optionally, look at its [source code](https://github.com/dart-lang/angular_components_example).

<aside class="alert alert-info" markdown="1">
**Note:**
The AngularDart Components package is just a preview
of some of the components that are in everyday use in Google apps.
We plan to release many more components over time.
</aside>

Think about how AngularDart Components might improve the app. The rest of this codelab leads you through making the following changes:

*   Improving the progress bar by changing **\<progress>** to **\<material-progress>**.
*   Adding small, pre-packaged images by changing text to **\<material-icon>** components.
*   Displaying small amounts of data in a more compelling way with **\<acx-scorecard>**.
*   Changing **\<button>** and button-like **\<input>** elements to specialized components:
    *   **\<material-fab>**
    *   **\<material-toggle>**
    *   **\<material-checkbox>**
    *   **\<material-radio-group>** and **\<material-radio>**
*   Reimplementing settings to use expansion panels, to hide controls until they’re needed:
    *   **\<material-expansionpanel-set>**
    *   **\<material-expansionpanel>**
*   Dividing the UI into three tabs—*Simulation, Help,* and *About*—by putting most of the UI into three **\<material-tab>** components inside a **\<material-tab-panel>**.
