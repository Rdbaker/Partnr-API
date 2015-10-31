angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects, applications, principal, toaster) {
	$scope.project = {};
	$scope.canApply = true;
	$scope.isOwner = false;
	$scope.loadComplete = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	$scope.doApply = function(role) {
		applications.create({ role : role }).then(function(result) {
			toaster.success('Request sent!');
		});
		$scope.canApply = false;
	};

	$scope.getStatus = function() {
		var result = 'Not Started';
		switch($scope.project.status) {
			case 'not_started':
				result = "Not Started";
				break;
			case 'in_progress':
				result = "In Progress";
				break;
			case "complete":
				result = "Completed";
				break;
		}
		return result;
	};
	
	projects.get($stateParams.id).then(function(result) {
		$log.debug(result.data);
		$scope.project = result.data;
		if (result.data.owner.id === principal.getUser().id) {
			$scope.isOwner = true;
			$scope.canApply = false;
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

		doLoadStep();
	});

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};
});