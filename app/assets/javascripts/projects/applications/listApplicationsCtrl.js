angular.module('partnr.users.assets').controller('ListApplicationsController', function($scope, $state, $stateParams, $log, $q, projects, applications, principal, toaster) {
	$scope.project = {};
	$scope.applications = [];

	$scope.loadComplete = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	applications.list({'project' : $stateParams.project_id}).then(function(result) {
		$scope.applications = result.data;
		doLoadStep();
	});

	projects.get($stateParams.project_id).then(function(result) {
		$scope.project = result.data;
		doLoadStep();
	});

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};
});