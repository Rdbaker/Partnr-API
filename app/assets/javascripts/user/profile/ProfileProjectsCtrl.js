angular.module('partnr.users.assets').controller('ProfileProjectsController', function($scope, $rootScope, $state, $stateParams, $log, toaster, feeds) {
	$scope.loadComplete = false;
	$scope.user = null;
  $scope.activities = [];

	$scope.$parent.getProfileWrapperInfo().then(function(result) {
		$log.debug(result);
		$scope.user = result;
    feeds.listUserActivity($scope.user.id).then(function(activity) {
      $scope.activities.push(activity);
      $scope.loadComplete = true;
    });
	});
});
