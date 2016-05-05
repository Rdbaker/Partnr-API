angular.module('partnr.users').directive('userCard', function($rootScope, $state) {
  return {
    restrict: 'AE',
    templateUrl: 'user/user_card.html',
    scope: {
      user: '='
    },
    link: function($scope, elem, attr, ctrl) {
      $scope.$state = $state;
    }
  };
});
