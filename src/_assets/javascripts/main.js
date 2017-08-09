//= require vendor/jquery-3.1.1.min
//= require bootstrap
//= require _utilities
//= require _search
//= require vendor/code-prettify/prettify
//= require vendor/code-prettify/lang-dart
//= require vendor/code-prettify/lang-yaml

var condensedHeaderHeight = 50;
var tocToSidenavDiff = 50;

function fixNav() {
  var t = $(document).scrollTop(),
    f = $("#page-footer").offset().top,
    h = window.innerHeight,
    // space between scroll position and top of the footer
    whenAtBottom = f - t,
    mh = Math.min(h, whenAtBottom) - condensedHeaderHeight;
  $("#sidenav").css({maxHeight: mh});
  $("#toc").css({maxHeight: mh - tocToSidenavDiff});
}

// When a user scrolls to 50px add class  condensed-header to body
$(window).scroll(function () {
  fixNav();
  var currentScreenPosition = $(document).scrollTop();
  if (currentScreenPosition > 50) {
    $('body').addClass('fixed_nav');
  } else {
    $('body').removeClass('fixed_nav');
  }
});

function setupFrontpageFootnotes() {
  function highlightFootnote() {
    var footnote = $('#code-display');
    footnote.removeClass('blink');
    footnote.addClass('blink');
    window.setTimeout(function () {
      footnote.removeClass('blink');
    }, 1000);
  }

  var footnotesParagraph = $('#code-display p');
  var allFrontpageHighlights = $('.frontpage-highlight');

  allFrontpageHighlights.click(function () {
    var text = $(this).data('text');
    footnotesParagraph.text(text);
    allFrontpageHighlights.removeClass('selected');
    $(this).addClass('selected');
    highlightFootnote();
  });
}

function setupSidenav() {
  $('#sidenav i').on('click', function (e) {
    e.stopPropagation();
    $(this).parent('li').toggleClass('active');
  });
}

function setupTableOfContents() {
  // TOC: Table of Contents
  $('.toc-entry').not('.toc-h2').remove();
  $('.section-nav').addClass('nav').css({opacity: 1});

  $('body').scrollspy({
    offset: 100,
    target: '#toc'
  });

  // $('#toc').on('activate.bs.scrollspy', function () {
  //   // do something…
  // });
}

function setupLocalAnchors() {
  $('#toc a[href*="#"]').on('click', function (e) {
    var h = $(this).attr('href'),
      p = window.location.pathname;
    if (h.includes(p)) {
      e.preventDefault();
      var target = $(this.hash);
      var hash = this.hash;
      if (target.length == 0) {
        target = $('a[name="' + this.hash.substr(1) + '"]');
      }
      if (target.length == 0) {
        target = $('html');
      }
      $('html, body').animate(
        {scrollTop: target.offset().top - 70},
        500,
        function () {
          location.hash = hash;
        });
      // Mark as active
      // $('a[href^="#"]').parent('li').removeClass('active');
      $(this).parent('li').addClass('active');
    }
  });
}

function setupMobileNavigation() {
  $('#menu-toggle').on('click', function (e) {
    e.stopPropagation();
    $("body").toggleClass('open_menu');
  });

  $("#page-content").on('click', function () {
    if ($('body').hasClass('open_menu')) {
      $('body').removeClass("open_menu");
    }
  });
}

function setupTabs() {
  var tabs = $('.tabs__top-bar li');
  var tabContents = $('.tabs__content');

  function clearTabsCurrent() {
    tabs.removeClass('current');
    tabContents.removeClass('current');
  }

  tabs.click(function () {
    clearTabsCurrent();

    var tab_id = $(this).attr('data-tab');

    $(this).addClass('current');
    $("#" + tab_id).addClass('current');
  });

  // The following selects the correct default tab in /guides/get-started
  function selectOperatingSystemInTabs(osName) {
    clearTabsCurrent();

    $("li[data-tab='tab-sdk-install-" + osName + "']").addClass('current');
    $('#tab-sdk-install-' + osName).addClass('current');
  }

  if (window.navigator.userAgent.indexOf("Mac") != -1) {
    selectOperatingSystemInTabs('mac');
  } else if (window.navigator.userAgent.indexOf("Linux") != -1 &&
             window.navigator.userAgent.indexOf("Android") == -1) {
    // Doesn't auto-select the Linux tab when on Android.
    selectOperatingSystemInTabs('linux');
  }
}

$(document).ready(function () {
  // set heights for navigation elements
  fixNav();
  $(window).smartresize(function () {
    fixNav();
  });

  // Initiate Syntax Highlighting
  prettyPrint();

  setupFrontpageFootnotes();
  setupSidenav();
  setupTableOfContents();
  setupLocalAnchors();
  setupMobileNavigation();
  setupTabs();

  // Popovers
  $('[data-toggle="popover"], .dart-popover').popover();

  // Add external link indicators
  $('a[href^="http"], a[target="_blank"]').not('.no-automatic-external')
    .addClass('external');
});

