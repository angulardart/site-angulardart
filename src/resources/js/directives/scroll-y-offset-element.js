angularIO.directive('scrollYOffsetElement', ['$anchorScroll', function($anchorScroll) {
  return function(scope, element) {
    // 2017-03-27 link target offsets are handled via CSS for all angular and non-angular pages.
    $anchorScroll.yOffset = 0; // element;
  };
}]);