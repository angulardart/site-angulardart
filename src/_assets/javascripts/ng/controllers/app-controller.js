angularIO.controller('AppCtrl', ['$timeout', function ($timeout) {
  // TRIGGER PRETTYPRINT AFTER DIGEST LOOP COMPLETE
  $timeout(prettyPrint, 1);
}]);
