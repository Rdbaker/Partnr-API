angular.module('partnr.feed').directive('feedActivity', function($rootScope, $state) {
  return {
    restrict: 'AE',
    templateUrl: 'feed/feed_activity.html',
    scope: {
      activity: '='
    },
    link: function($scope, elt, attr, ctrl) {
      $scope.$state = $state;
    }
  };
});
