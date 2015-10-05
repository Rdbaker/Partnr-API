angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects, applications, principal, toaster) {
	$scope.project = {};
	$scope.canApply = true;
	$scope.isOwner = false;
	$scope.loadComplete = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	$scope.doDelete = function() {
		projects.delete($scope.project.id).then(function(result) {
			$state.go('project_list');
			toaster.success('Project deleted');
		});
	};

	$scope.doApply = function(role) {
		applications.create({ role : role }).then(function(result) {
			toaster.success('Request sent!');
		});
		$scope.canApply = false;
	};
	
	projects.get($stateParams.id).then(function(result) {
		$log.debug(result.data);
		$scope.project = result.data;
		if (result.data.owner === principal.getUser().id) {
			$scope.isOwner = true;
		}

		for (var i = 0; i < result.data.roles.length; i++) {
			if (result.data.roles[i].user != null) {
				if (result.data.roles[i].user.id === principal.getUser().id) {
					$scope.canApply = false;
					break;
				}
			}
		}

		doLoadStep();
	});

	applications.list({'project' : $stateParams.id, 'user' : principal.getUser().id}).then(function(result) {
		$log.debug(result.data);
		if (result.data.length > 0) {
			$scope.canApply = false;
		}
	});

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};
});