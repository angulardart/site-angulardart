---
layout: codelab
title: "Step 4: Add Expansion Panels and Tabs"
description: "[PENDING: summarize]."
snippet_img: images/piratemap.jpg

nextpage:
  url: /codelabs/angular2_components/what-next
  title: "What Next?"
prevpage:
  url: /codelabs/angular2_components/3-usebuttons
  title: "Step 3: Upgrade Buttons and Inputs"

header:
  css: ["/codelabs/ng2/darrrt.css"]
---

```
PENDING: fix description, snippet_img, css
```


## Step 4: Add Expansion Panels and Tabs

In this final step, you’ll use expansion panels and tabs to hide information until the user needs it. You’ll use these components:



*   \<material-expansionpanel> and \<material-expansionpanel-set>
*   \<material-tab> and \<material-tab-panel>

## Use \<material-expansionpanel> and \<material-expansionpanel-set>

Expansion panels are especially good for settings, so let’s use them in the custom \<settings-component>, implemented in lib/settings/settings_component.*.



1.  Edit the Dart file (**lib/settings/settings_component.dart**), adding the expansion panel directives:

\<code>...
directives: const [
  MaterialCheckboxComponent,
  \<strong>MaterialExpansionPanel,
  MaterialExpansionPanelSet,\</strong>
  ...
\</code>
1.  Edit the template file (\<strong>lib/settings/settings_component.html\</strong>) to change the enclosing \<div> element (the first and last lines of the file) to be a \<material-expansionpanel-set>.
1.  Convert the Wallet div into a \<material-expansionpanel> ([MaterialExpansionPanel]):
    1.  Change the \<div> element to \<material-expansionpanel>.
    1.  Move the title (h2 content) and summary content (p content) into the \<material-expansionpanel> \<strong>name\</strong> and \<strong>secondaryText\</strong> attributes, respectively.
    1.  Remove the buttons from the bottom of the panel, putting their event handling code into \<strong>(save)\</strong> and \<strong>(cancel)\</strong> bindings. Your code changes to the beginning of this file should look like this:


\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components18.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components18.png "image_tooltip")

1.  Test the app. The Wallet settings should look like this at first:

\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components19.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components19.png "image_tooltip")

When you expand the Wallet settings, they should look like this:

\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components20.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components20.png "image_tooltip")

When you change settings and click the SAVE button at bottom right, the new values should appear in the UI:

\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components21.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components21.png "image_tooltip")

1.  Once the app runs correctly, convert the two remaining major divs (Betting and Other) into material expansion panels.

That bit of work saved a lot of UI space:



\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components22.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components22.png "image_tooltip")


## Use \<material-tab> and \<material-tab-panel>

Now let’s save more by moving auxiliary text into separate tabs. This affects the main UI, implemented in lib/lottery_simulator.*. Tabs are already included in materialDirectives, so you don’t need to edit the Dart file.

Edit **lib/library_simulator.html**:



1.  After the end of the first div, add a \<material-tab-panel> tag.
1.  Put the closing tag of the \<material-tab-panel> at the end of the file.
1.  Just after the opening \<material-tab-panel> tag, add a \<material-tab> tag with the label set to “Simulation”.
1.  Close the \<material-tab-panel> near the bottom of the file, just before the \<div> containing the Help heading.

Your changes, so far, should look like this:

\<code>\<h1>Lottery Simulator\</h1>

\<div class="help">
  …
\</div>

\<strong>\<material-tab-panel>
  \<material-tab label="Simulation">\</strong>
    ...
  \<strong>\</material-tab>\</strong>
\<div>
  \<h2>Help\</h2>
  ...
\</div>
\<strong>\</material-tab-panel>\</strong>
\</code>
If you run the app now, the top of the UI should look like this:


\<p style="color: red; font-weight: bold">>>>> inline image link here (to images/AngularDart_Components23.png). Store image on your image server and adjust path/filename if necessary.\</p>


![alt_text](images/AngularDart_Components23.png "image_tooltip")

1.  Change the next two \<div>-\<h2> combinations into \<material-tabs>, with the labels “Help” and “About”.

The end of the file should look like this:


```
  \</material-tab>
  \<material-tab label="Help">
    \<help-component content="help">\</help-component>
  \</material-tab>
  \<material-tab label="About">
    \<help-component content="about">\</help-component>
  \</material-tab>
\</material-tab-panel>
```


Your app should now look exactly like the one you saw in the first page of this codelab.

Congratulations! You’ve converted a functional but ugly app into a svelte app that uses the next generation of AngularDart Components.

