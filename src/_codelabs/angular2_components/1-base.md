---
layout: codelab
title: "Step 1: Get to Know the Software"
description: "Get the base app for the code lab, and play with the AngularDart Component demo."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/angular2_components/2-easystart
  title: "Step 2: Start Using AngularDart Components"
prevpage:
  url: /codelabs/angular2_components
  title: "Code Lab: AngularDart Components"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

```
PENDING: fix snippet_img, css
Make <repo-name> a variable, so it'll be easy to update.
```

In this step, you’ll download the code for the app, and you’ll familiarize yourself with both the app and the components you’ll be adding to it.


## <i class="fa fa-money"> </i> Get the app code

Download the app’s code from the \<repo-name> GitHub repo using one of the following options:

<ol markdown="1">

<li markdown="1">
  Download the ZIP file, \<repo-name>-master.zip
  `[PENDING: link to the zip file]`.
  Unzip the ZIP file, which creates a directory called \<repo-name>-master.
</li>

<li> 
  <p> Clone the repo. For example, from the command line: </p>

{% prettify none %}
git clone https://github.com/dart-lang/<repo-name>.git
{% endprettify %}

<p> This creates a directory named <code>[PENDING: repo-name]</code>. </p>
</li>
</ol>


## <i class="fa fa-money"> </i> Get familiar with the base app

The base app—the app you’ll be starting from—is in the **1-base** directory.

<ol markdown="1">
<li>
  <p> Get the base app's dependencies. For example: </p>

{% prettify none %}
cd <repo-name>/1-base
pub get
{% endprettify %}
</li>

<li markdown="1">
Use the tools of your choice to run the base app.

For example, you could use `pub serve` and then visit `localhost:8080` in any modern web browser. Or you could use WebStorm to run the app in Dartium.
</li>

<li markdown="1">
Play with the base app. It works, but it’s not pretty. Consider these issues:

* The app doesn’t adhere to Google’s
  [material design guidelines](https://material.google.com).
* The buttons would be prettier and easier to understand if they had images.
* The user must scroll to see the whole UI.
* Settings are visible even when the user has no interest in changing them.
</li></ol>

### Custom components in the Lottery Simulator

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


```
[PENDING: add annotated screenshot? unfortunately, the UI is too long to display in full.]
```

## <i class="fa fa-money"> </i> Get familiar with AngularDart Components

Run the AngularDart Components demo: `[PENDING: URL]`.

<aside class="alert alert-info" markdown="1">
**Note:**
The AngularDart Components package is just a preview of some of the components that are in everyday use in Google apps. We plan to release many more components over time.
</aside>

Think about how AngularDart Components might improve the app. The rest of this code lab leads you through making the following changes:

*   Improving the progress bar by changing \<progress> to \<material-progress>.
*   Adding small, pre-packaged images by changing text to \<glyph> components.
*   Displaying small amounts of data in a more compelling way with \<acx-scorecard>.
*   Changing \<button> and button-like \<input> elements to specialized components:
    *   \<material-fab>
    *   \<material-toggle>
    *   \<material-checkbox>
    *   \<material-radio-group> and \<material-radio>
*   Reimplementing settings to use expansion panels, to hide controls until they’re needed:
    *   \<material-expansionpanel-set>
    *   \<material-expansionpanel>
*   Dividing the UI into three tabs—*Simulation, Help,* and *About*—by putting most of the UI into three \<material-tab> components inside a \<material-tab-panel>.
