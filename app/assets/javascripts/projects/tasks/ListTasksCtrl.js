angular.module('partnr.users.assets').controller('ListTasksController', function($scope, $state, $stateParams, $log, $q, projects, milestones, tasks, principal, toaster) {
	$scope.project = {};
	$scope.tasks = [];
	$scope.milestones = [];
	$scope.viewingEntity = 'Milestones';

	$scope.loadComplete = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	milestones.listByProject($stateParams.project_id).then(function(result) {
		$scope.milestones = result.data;
		doLoadStep();
	});

	tasks.listByProject($stateParams.project_id).then(function(result) {
		$scope.tasks = result.data;
		doLoadStep();
	});

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved >= loadSteps) {
			$scope.loadComplete = true;
		}
	};
});
