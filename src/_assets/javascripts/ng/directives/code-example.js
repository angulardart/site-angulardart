/*
* Code Example Directive
*
* Formats codes examples and prevents
* Angular code from being processed.
*/

angularIO.directive('codeExample', function() {
  return {
    restrict: 'E',

    compile: function(tElement, attrs) {
      var html = (attrs.escape === "html") ? _.escape(tElement.html()) : tElement.html();
      var classes = 'prettyprint ' + (attrs.format || '') +
          (attrs.language ? ' lang-' + attrs.language : '') +
          (attrs.showcase === 'true' ? ' is-showcase' : '');
      var template =
        '<copy-container>' +
          '<pre class="' + classes + '">' +
            '<code ng-non-bindable>' + html + '</code>' +
          '</pre>' +
        '</copy-container>';

      // UPDATE ELEMENT WITH NEW TEMPLATE
      tElement.html(template);
      tElement.removeAttr('data-webdev-raw');

      // RETURN ELEMENT
      return function(scope, element, attrs) {};
    }
  };
});
