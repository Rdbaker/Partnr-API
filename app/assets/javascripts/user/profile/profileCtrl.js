angular.module('partnr.users.assets').controller('ProfileController', function($scope, $state, $stateParams, $log, toaster, users, principal) {
	$scope.loadComplete = false;
	$scope.user = null;
	$scope.currentUser = principal.getUser();

	users.get($stateParams.id).then(function(result) {
		$log.debug(result.data);
		$scope.user = result.data;
		$scope.loadComplete = true;
    $scope.$broadcast('user.updated', $scope.user);
	});
});
