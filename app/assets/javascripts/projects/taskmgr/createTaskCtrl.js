angular.module('partnr.users.assets').controller('CreateTaskController', function($scope, $state, $stateParams, $log, $q, $timeout, tasks, milestones, principal, toaster) {
	$scope.task = {
		title: '',
		description: '',
		status: 'not_started',
		milestone: null,
		project: $stateParams.project_id
	};

	$scope.loadComplete = false;
	$scope.loading = false;
	$scope.milestones = [];

	milestones.listByProject($stateParams.project_id).then(function(result) {
		$scope.loadComplete = true;
		$scope.milestones = result.data;
	});

	var creationFailCallback = function() {
		$scope.loading = false;
		toaster.error("Task could not be created. Please try again.");
	};

	$scope.createTask = function() {
		$scope.loading = true;

		if ($scope.task.description === '') {
			delete $scope.task.description;
		}

		if ($scope.task.milestone === null) {
			delete $scope.task.milestone;
		}

		console.log($scope.task);

		tasks.create($scope.task).then(function(result) {
			$scope.loading = false;

			if (result.data.id) {
				$state.go('project_taskmgr', { project_id: $stateParams.project_id, v: 'task' });
			}
		}, creationFailCallback);
	};

	$scope.reset = function() {
		$scope.task = {
			title: '',
			description: '',
			status: 'not_started',
			milestone: null,
			project: $stateParams.project_id
		};
	};
});