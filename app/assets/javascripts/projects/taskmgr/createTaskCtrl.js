angular.module('partnr.users.assets').controller('CreateTaskController', function($scope, $state, $stateParams, $log, $q, $timeout, tasks, milestones, principal, toaster) {
	$scope.task = {
		title: '',
		description: '',
		status: 'not_started',
		milestone: null,
		project: $stateParams.project_id
	};

	$scope.loadComplete = false;
	$scope.formLoading = false;
	$scope.milestones = [];
	$scope.users = [];
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};

	milestones.listByProject($stateParams.project_id).then(function(result) {
		$scope.milestones = result.data;
		doLoadStep();
	});

	$scope.$parent.getProjectWrapperInfo().then(function(result) {
		$log.debug(result);
		$scope.project = result.project;
		for (var i = 0; i < result.project.roles.length; i++) {
			var role = result.project.roles[i];
			if (role.user && role.user.id) {
				$scope.users.push(role.user);
			}
		};

		doLoadStep();
	});

	var creationFailCallback = function() {
		$scope.formLoading = false;
		toaster.error("Task could not be created. Please try again.");
	};

	$scope.createTask = function() {
		$scope.formLoading = true;

		if ($scope.task.description === '') {
			delete $scope.task.description;
		}

		if ($scope.task.milestone === null) {
			delete $scope.task.milestone;
		}

		console.log($scope.task);

		tasks.create($scope.task).then(function(result) {
			$scope.formLoading = false;

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