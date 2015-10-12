angular.module('partnr.users.assets').controller('EditProjectController', function($scope, $state, $stateParams, $log, $q, projects, applications, principal, toaster) {
	$scope.project = {
		status: 'not_started'
	};
	$scope.isOwner = false;
	$scope.loadComplete = false;
	
	projects.get($stateParams.project_id).then(function(result) {
		$log.debug(result.data);
		$scope.project = result.data;

		$log.debug(result.data);
		if (result.data.owner.id === principal.getUser().id) {
			$scope.isOwner = true;
		}

		$scope.loadComplete = true;
	});

	$scope.doSave = function() {
		var preparedProject = angular.copy($scope.project);
		delete preparedProject.owner;
		
		projects.update(preparedProject).then(function(result) {
			$log.debug(result);
			if (result.data) {
				toaster.success("Project updated!");
				$state.go('project', {id : $scope.project.id});
			}
		});
	};
});