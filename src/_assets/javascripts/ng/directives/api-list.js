/*eslint no-unused-vars: "angularIO" */

/* {% raw %}
* API List & Filter Directive
*
* A page displaying all of the angular API methods available
* including a filter that can hide/show methods bases on filter
* settings.
*/

angularIO.directive('apiList', function () {
  var PKG_KEY = 'package';
  var QUERY_KEY = 'query';
  var TYPE_KEY = 'type';
  var STATUS_KEY = 'status';

  return {
    restrict: 'E',
    template:
      '<p>' +
      '  This page lists API from libraries in the {{$ctrl.pkgList}} packages. ' +
      '  Other libraries commonly used by Dart web apps include ' +
      '  <a href="https://api.dartlang.org">Dart SDK libraries</a> such as ' +
      '  <a href="https://api.dartlang.org/stable/dart-async">dart:async</a>, ' +
      '  <a href="https://api.dartlang.org/stable/dart-core">dart:core</a>, and ' +
      '  <a href="https://api.dartlang.org/stable/dart-html">dart:html</a>. ' +
      '  <a href="/guides/web-programming">More information.</a>' +
      '</p>' +
      '<div ng-cloak="ng-cloak" class="l-flex-wrap banner is-plain api-filter">' +
      '  <div class="form-select-menu" ng-if="!$ctrl.isForDart">' +
      '    <button ng-repeat="status in $ctrl.statuses" ng-if="$ctrl.status === status.matches[0]" class="form-select-button" ng-click="$ctrl.toggleMenu(\'status\')"><strong>Status:</strong>{{status.title}}</button>'+
      '    <button class="form-select-button is-default" ng-if="$ctrl.status === null" ng-click="$ctrl.toggleMenu(\'status\')"><strong>Status: All</strong></button>'+
      '    <ul class="form-select-dropdown" ng-class="{ visible: $ctrl.showMenu[\'status\'] === true }">' +
      '      <li ng-class="{ active: !$ctrl.status }" ng-click="$ctrl.clear(\'status\')">All</li>' +
      '      <li ng-repeat="status in $ctrl.statuses" ng-class="{ active: $ctrl.status === status }" ng-click="$ctrl.set(status, \'status\')">{{status.title}}</li>' +
      '    </ul>' +
      '    <div class="overlay" ng-class="{ visible: $ctrl.showMenu[\'status\'] === true }" ng-click="$ctrl.toggleMenu(\'status\')"></div>' +
      '  </div>' +
      '        ' +
      '  <div class="form-select-menu wide">' +
      '    <button ng-repeat="pkg in $ctrl.packages" ng-if="$ctrl.pkg === pkg" class="form-select-button wide" ng-click="$ctrl.toggleMenu(\'pkg\')"><strong>Packages:</strong>{{pkg}}</button>'+
      '    <button class="form-select-button is-default wide" ng-if="$ctrl.pkg === null" ng-click="$ctrl.toggleMenu(\'pkg\')"><strong>Packages: All</strong></button>'+
      '    <ul class="form-select-dropdown wide" ng-class="{ visible: $ctrl.showMenu[\'pkg\'] === true }">' +
      '      <li ng-class="{ active: !$ctrl.pkg }" ng-click="$ctrl.clear(\'pkg\')">All</li>' +
      '      <li ng-repeat="pkg in $ctrl.packages" ng-class="{ active: $ctrl.pkg === pkg }" ng-click="$ctrl.set(pkg, \'pkg\')">{{pkg}}</li>' +
      '    </ul>' +
      '    <div class="overlay" ng-class="{ visible: $ctrl.showMenu[\'pkg\'] === true }" ng-click="$ctrl.toggleMenu(\'pkg\')"></div>' +
      '  </div>' +
      '        ' +
      '  <div class="form-select-menu">' +
      '    <button ng-repeat="type in $ctrl.types" ng-if="$ctrl.type === type.matches[0]" class="form-select-button has-symbol" ng-click="$ctrl.toggleMenu(\'type\')"><strong>Type:</strong><span class="symbol {{type.cssClass}}" ng-if="type.cssClass !== \'stable\'" ></span>{{type.title}}</button>'+
      '    <button class="form-select-button is-default" ng-if="$ctrl.type === null" ng-click="$ctrl.toggleMenu(\'type\')"><strong>Type: All</strong></button>'+
      '    <ul class="form-select-dropdown" ng-class="{ visible: $ctrl.showMenu[\'type\'] === true }">' +
      '      <li ng-class="{ active: !$ctrl.type }" ng-click="$ctrl.clear(\'type\')">All</li>' +
      '      <li ng-repeat="type in $ctrl.types" ng-class="{ active: $ctrl.type === type }" ng-click="$ctrl.set(type, \'type\')"><span class="symbol {{type.cssClass}}"></span>{{type.title}}</li>' +
      '    </ul>' +
      '    <div class="overlay" ng-class="{ visible: $ctrl.showMenu[\'type\'] === true }" ng-click="$ctrl.toggleMenu(\'type\')"></div>' +
      '  </div>' +
      '        ' +
      '  <div class="form-search">' +
      '    <i class="material-icons">search</i>' +
      '    <input placeholder="Filter" ng-model="$ctrl.query" ng-model-options="{updateOn: \'default blur\', debounce: {\'default\': 350, \'blur\': 0}}">' +
      '  </div>' +
      '</div>' +
      '      ' +
      '<article class="l-content-small docs-content">' +
      '  <div ng-repeat="section in $ctrl.groupedSections" ng-if="$ctrl.filterSections(section)" ng-cloak="ng-cloak">' +
      '    <h2>' +
      '      <a ng-href="{{section.href}}" target="_blank" rel="noopener">' +
      '        {{section.title}}&nbsp;&nbsp' +
      '      </a>' +
      '      <span class="api-doc-code" ng-if="section.showImport">' +
      '        import&nbsp;\'package:{{section.pkg}}/{{section.title}}.dart\';' +
      '      </span>' +
      '    </h2>' +
      '    <ul class="api-list">' +
      '      <li ng-repeat="item in section.items" ng-show="item.show" class="api-item">' +
      '        <a ng-href="{{section.itemHrefBase}}/{{item.path}}" target="_blank" rel="noopener"><span class="symbol {{item.docType}}"></span>{{item.title}}</a>' +
      '      </li>' +
      '    </ul>' +
      '  </div>' +
      '</article>',
    controllerAs: '$ctrl',
    controller: ['$scope', '$attrs', '$http', '$location', function($scope, $attrs, $http, $location) {
      // DEFAULT VALUES
      var $ctrl = this;
      $ctrl.showMenu = { /* menuName -> bool */ };
      $ctrl.status = null;
      $ctrl.pkg = null;
      $ctrl.query = null;
      $ctrl.type = null;
      $ctrl.groupedSections = [];


      // API TYPES
      $ctrl.types = [
        { cssClass: 'directive', title: 'Directive', matches: ['directive'] },
        { cssClass: 'pipe', title: 'Pipe', matches: ['pipe'] },
        { cssClass: 'decorator', title: 'Decorator', matches: ['decorator'] },
        { cssClass: 'class', title: 'Class', matches: ['class'] },
        { cssClass: 'interface', title: 'Interface', matches: ['interface'] },
        { cssClass: 'function', title: 'Function', matches: ['function'] },
        { cssClass: 'enum', title: 'Enum', matches: ['enum'] },
        { cssClass: 'const', title: 'Const', matches: ['const', 'constant'] },
        { cssClass: 'typedef', title: 'Typedef', matches: ['typedef'] },
        { cssClass: 'var', title: 'Var', matches: ['var', 'let'] }
      ];

      // STATUSES
      $ctrl.statuses = [
        { cssClass: 'stable', title: 'Stable', matches: ['stable']},
        { cssClass: 'deprecated', title: 'Deprecated', matches: ['deprecated']},
        { cssClass: 'experimental', title: 'Experimental', matches: ['experimental']},
        { cssClass: 'security', title: 'Security Risk', matches: ['security']}
      ];


      // SET FILTER VALUES
      getFilterValues();


      // GRAB DATA FOR SECTIONS
      $http.get($attrs.src).then(function(response) {
        $ctrl.sections =  response.data;
        var pkgsMap = Object.create(null);

        $ctrl.groupedSections = Object.keys($ctrl.sections).sort().map(function(pkgLib) {
          var p = pkgLib.split('/');
          var pkg = p.length == 1 ? 'angular2' : p[0];
          var title = p[1] || p[0];
          var isSdkLib = title.startsWith('dart:');
          var lib = isSdkLib ? title.replace('dart:', 'dart-') : title;
          pkgsMap[isSdkLib ? 'Dart SDK' : pkg] = 1;
          var libPage = lib + '/' + lib + '-library';
          var href = isSdkLib
            ? 'https://api.dartlang.org/stable/' + libPage + '.html'
            : '/api/' + pkg + '/' + libPage;
          var itemHrefBase = isSdkLib ? 'https://api.dartlang.org/stable' : '/api/' + pkg;
          return {
            pkg: pkg,
            href: href,
            title: title,
            lib: lib,
            showImport: !isSdkLib,
            itemHrefBase: itemHrefBase,
            items: $ctrl.sections[pkgLib] };
        });
        var pkgs = Object.keys(pkgsMap);
        $ctrl.packages = pkgs;
        var and = pkgs.length > 2 ? ', and ' : ' and ';
        $ctrl.pkgList = pkgs.slice(0, pkgs.length - 1).join(', ') + and + pkgs[pkgs.length - 1];
        if ($ctrl.packages && $ctrl.packages.indexOf($ctrl.pkg) < 0) $ctrl.pkg = null
      });


      // SET SELECTED VALUE FROM MENUS/FORM
      $ctrl.set = function(item, kind) {
        var value = (item && item.matches) ? item.matches[0] : null;
        $ctrl[kind] = kind === 'pkg' ? item : value;
        $ctrl.toggleMenu(kind);
      }


      // CLEAR SELECTED VALUE FROM MENUS/FORM
      $ctrl.clear = function (kind) {
        $ctrl[kind] = null;
        $ctrl.toggleMenu(kind);
      };


      // TOGGLE MENU
      $ctrl.toggleMenu = function(kind) {
        $ctrl.showMenu[kind] = !$ctrl.showMenu[kind];
      }


      // UPDATE VALUES IF DART API
      var isForDart = $attrs.lang === 'dart';
      if (isForDart) {
        $ctrl.isForDart = true;
        $ctrl.statuses = [];
        $ctrl.types = $ctrl.types.filter(function (t) {
          return t.cssClass.match(/^(class|const|function|typedef|var)$/);
        });
      }


      // SET URL WITH VALUES
      $scope.$watchGroup(
        [
          function() { return $ctrl.pkg; },
          function() { return $ctrl.query; },
          function() { return $ctrl.type; },
          function() { return $ctrl.status; },
          function() { return $ctrl.sections; }
        ],

        function() {
          var queryURL = $ctrl.query ? $ctrl.query.toLowerCase() : null;
          $location.search(PKG_KEY, $ctrl.pkg || null);
          $location.search(QUERY_KEY, queryURL);
          $location.search(STATUS_KEY, $ctrl.status || null);
          $location.search(TYPE_KEY, $ctrl.type || null);
        }
      );


      // GET VALUES FROM URL
      function getFilterValues() {
        var urlParams =  $location.search();
        var pkg = urlParams[PKG_KEY] || null;
        if ($ctrl.packages && $ctrl.packages.indexOf(pkg) < 0) pkg = null

        $ctrl.pkg = pkg;
        $ctrl.status = urlParams[STATUS_KEY] || null;
        $ctrl.query = urlParams[QUERY_KEY] || null;;
        $ctrl.type = urlParams[TYPE_KEY] || null;;
      }


      // CHECK IF IT'S A CONSTANT TYPE
      function isConst(item) {
        return item.docType === 'const' || item.docType === 'constant';
      }

      // FILTER SECTION & ITEMS LOOP
      $ctrl.filterSections = function(section) {
        var showSection = false;

        section.items.forEach(function(item) {
          item.show = false;
          if (!statusSelected(item) || !queryEntered(section, item)) return true;
          if ($ctrl.pkg && (!item.href.startsWith($ctrl.pkg) || item.href.startsWith($ctrl.pkg + '_'))) return true;
          if ($ctrl.type === null || $ctrl.type === item.docType || $ctrl.type === 'const' && isConst(item)) {
            showSection = item.show = true;
          }
        });

        return showSection;
      }


      // CHECK FOR QUERY
      function queryEntered(section, item) {
        var isVisible = false;

        // CHECK IF QUERY MATCH SECTION OR ITEM
        var query = ($ctrl.query || '').toLowerCase();
        var matchesSection = $ctrl.query === '' || $ctrl.query === null || section.title.toLowerCase().indexOf($ctrl.query.toLowerCase()) !== -1;
        var matchesTitle = !query || item.title.toLowerCase().indexOf(query) !== -1;

        // FILTER BY QUERY
        if(matchesTitle || matchesSection) {
          isVisible = true;
        }

        return isVisible;
      }


      // CHECK IF AN API ITEM IS VISIBLE BY STATUS
      function statusSelected(item) {
        var status = item.stability;
        var insecure = item.secure === 'false' ? false : true;
        var isVisible = false;

        if($ctrl.status === null) {
          isVisible = true;
        }

        if(status === $ctrl.status) {
          isVisible = true;
        }

        if(($ctrl.status === 'security') && insecure) {
          isVisible = true;
        }

        return isVisible;
      };
    }]
  };
});
// {% endraw %}
