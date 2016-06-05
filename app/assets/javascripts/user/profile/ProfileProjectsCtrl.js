angular.module('partnr.users.assets').controller('ProfileProjectsController', function($scope, $rootScope, $state, $stateParams, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;

	$scope.$parent.getProfileWrapperInfo().then(function(result) {
		$log.debug(result);
		$scope.user = result;
		$scope.loadComplete = true;

		$log.debug(result);
	});
});