angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects, principal, toaster) {
	$scope.project = {};
	$scope.isOwner = false;
	$scope.loadComplete = false;

	$scope.doDelete = function() {
		projects.delete($scope.project.id).then(function(result) {
			$state.go('project_list');
			toaster.success('Project deleted');
		});
	};
	
	projects.get($stateParams.id).then(function(result) {
		$log.debug(result.data);
		$scope.project = result.data;
		if (result.data.owner === principal.getUser().id) {
			$scope.isOwner = true;
		}
		$scope.loadComplete = true;
	});
});