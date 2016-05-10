angular.module('partnr.users.assets').controller('MilestoneFormController', function($scope, $state, $stateParams, $log, $q, $timeout, milestones, principal, toaster) {
	$scope.milestone = {
		title: '',
		due_date: '',
		project: $stateParams.project_id
	};

	$scope.crudState = ($state.current.name.includes('create') ? 'create' : 'edit');
	$scope.loadComplete = true;
	$scope.formLoading = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};

	if ($scope.crudState === 'edit') {
		milestones.get($stateParams.milestone_id).then(function(result) {
			$log.debug(result.data);
			$scope.milestone = result.data;
		});
	} else {
		doLoadStep();
	}

	var creationFailCallback = function() {
		$scope.formLoading = false;
		toaster.error("Milestone could not be created. Please try again.");
	};

	$scope.createMilestone = function() {
		$scope.formLoading = true;

		if ($scope.milestone.due_date === '') {
			delete $scope.milestone.due_date;
		}

		milestones.create($scope.milestone).then(function(result) {
			$scope.formLoading = false;

			if (result.data.id) {
				$state.go('project_taskmgr', { project_id: $stateParams.project_id });
			}
		}, creationFailCallback);
	};

	$scope.reset = function() {
		$scope.milestone.title = '';
		$scope.milestone.due_date = '';
	};
});