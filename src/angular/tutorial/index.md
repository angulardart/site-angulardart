---
layout: angular
title: "Tutorial: Tour of Heroes"
description: The Tour of Heroes tutorial takes you through the steps of creating an Angular application in Dart.
prevpage:
  title: Documentation Overview
  url: /angular/guide
nextpage:
  title: The Starter App
  url: /angular/tutorial/toh-pt0
---
The grand plan for this tutorial is to build an app that helps a staffing agency manage its stable of heroes.

The Tour of Heroes app covers the core fundamentals of Angular. You'll build a basic app that
has many of the features you'd expect to find in a full-blown, data-driven app: acquiring and displaying
a list of heroes, editing a selected hero's detail, and navigating among different
views of heroic data. You'll learn the following:

  - Use built-in directives to show and hide elements and display lists of hero data.
  - Create components to display hero details and show an array of heroes.
  - Use one-way data binding for read-only data.
  - Add editable fields to update a model with two-way data binding.
  - Bind component methods to user events, like keystrokes and clicks.
  - Enable users to select a hero from a master list and edit that hero in the details view.
  - Format data with pipes.
  - Create a shared service to assemble the heroes.
  - Use routing to navigate among different views and their components.

You'll learn enough core Angular to get started and gain confidence that
Angular can do whatever you need it to do.
You'll cover a lot of ground at an introductory level, and you'll find many links
to pages with greater depth.

When you're done with this tutorial, the app will look like this <live-example name="toh-6"></live-example>.

## The end game

Here's a visual idea of where this tutorial leads, beginning with the "Dashboard"
view and the most heroic heroes:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/heroes-dashboard-1.png' %}" alt="Output of heroes dashboard">

You can click the two links above the dashboard ("Dashboard" and "Heroes")
to navigate between this Dashboard view and a Heroes view.

If you click the dashboard hero "Magneta," the router opens a "Hero Details" view
where you can change the hero's name.

<img class="image-display" src="{% asset_path 'ng/devguide/toh/hero-details-1.png' %}" alt="Details of hero in app">

Clicking the "Back" button returns you to the Dashboard.
Links at the top take you to either of the main views.
If you click "Heroes," the app displays the "Heroes" master list view.

<img class="image-display" src="{% asset_path 'ng/devguide/toh/heroes-list-2.png' %}" alt="Output of heroes list app">

When you click a different hero name, the read-only mini detail beneath the list reflects the new choice.

You can click the "View Details" button to drill into the editable details of the selected hero.

The following diagram captures all of the navigation options.

<img class="image-display" src="{% asset_path 'ng/devguide/toh/nav-diagram.png' %}" alt="View navigations">

Here's the app in action:

<img class="image-display" src="{% asset_path 'ng/devguide/toh/toh-anim.gif' %}" alt="Tour of Heroes in Action">

## Up next

You'll build the Tour of Heroes app, step by step.
Each step is motivated with a requirement that you've likely
met in many applications. Everything has a reason.

Along the way, you'll become familiar with many of the core fundamentals of Angular.
