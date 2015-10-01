angular.module('partnr.users.assets').controller('ApplicationController', function($scope, $state, $stateParams, $log, $q, projects, roles, principal, toaster) {
	$scope.role = {};
	$scope.loadComplete = false;

	roles.get($stateParams.role_id).then(function(result) {
		$log.debug(result.data);
		$scope.role = result.data;
		$scope.loadComplete = true;
	})
});