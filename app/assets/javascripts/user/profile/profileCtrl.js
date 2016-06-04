angular.module('partnr.users.assets').controller('ProfileController', function($scope, $rootScope, $state, $stateParams, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;
	$scope.userCategories = $rootScope.categories;

	users.get($stateParams.id).then(function(result) {
		$log.debug(result.data);
		$scope.user = result.data;
		$scope.loadComplete = true;

		$log.debug(result.data);
	});
});