angular.module('partnr.feed').directive('feedActivity', function($rootScope, $state, routeUtils) {
  return {
    restrict: 'AE',
    templateUrl: 'feed/feed_activity.html',
    scope: {
      activity: '='
    },
    link: function($scope, elt, attr, ctrl) {
      $scope.$state = $state;

      $scope.resolveLink = function(a) {
        var subject_type = a.subject_type.toLowerCase();
        if(subject_type === "bmark")
          subject_type = "milestone";

        routeUtils.resolveEntityLinkAndGo(a.subject[subject_type].links.self, a);
      };
    }
  };
});
