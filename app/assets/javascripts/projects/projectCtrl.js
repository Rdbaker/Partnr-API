angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects, principal, toaster) {
	$scope.project = {};
	$scope.loadComplete = false;
	
	projects.get($stateParams.id).then(function(result) {
		$scope.project = result.data;
		$scope.loadComplete = true;
	});
});