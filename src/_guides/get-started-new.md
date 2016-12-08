---
layout: guide
title: "Get Started"
description: "A guide to get you quickly writing web apps in AngularDart."
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## 1. Install the Dart SDK

 Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

<ul class="tabs__top-bar">
    <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
    <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
    <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>
<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">

With [Chocolatey](https://chocolatey.org/), 
installing Dart is a matter of two commands.

{% prettify shell %}
choco install dart-sdk
choco install dartium
{% endprettify %}

{% comment %}
TODO: we need to make this work here: needs js from site-www

js:
- url: /install/archive/assets/install.js
defer: true

The current stable version is
<span class="editor-build-rev-stable">[calculating]</span>.
{% endcomment %}
Another option is using the
[unofficial install wizard](http://www.gekorm.com/dart-windows/) 
or [downloading](https://www.dartlang.org/install/archive) Dart manually.

TODO: add the wizard's screenshot

</div>
<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">

TODO: make this more readable.

{% prettify shell %}
# Enable HTTPS for apt.
sudo apt-get update
sudo apt-get install apt-transport-https
# Get the Google Linux package signing key.
sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
# Set up the location of the stable repository.
sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
sudo apt-get update
# Install the SDK.
sudo apt-get install dart
{% endprettify %}
  
</div>
<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">

With [Homebrew](http://brew.sh/),
installing Dart is easy.

{% prettify shell %}
brew tap dart-lang/dart
brew install dart --with-content-shell --with-dartium
{% endprettify %}

Another option is [downloading Dart manually](/install/archive).
   
</div>