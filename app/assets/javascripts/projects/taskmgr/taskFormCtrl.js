angular.module('partnr.users.assets').controller('TaskFormController', function($scope, $state, $stateParams, $log, $q, $timeout, tasks, milestones, principal, modals, toaster) {
	$scope.task = {
		title: '',
		description: '',
		status: 'not_started',
		milestone: null,
		project: $stateParams.project_id
	};

	$scope.crudState = ($state.current.name.includes('create') ? 'create' : 'edit');
	$scope.loadComplete = false;
	$scope.formLoading = false;
	$scope.milestones = [];
	$scope.users = [];
	var loadSteps = 3;
	var loadStepsAchieved = 0;

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};

	if ($scope.crudState === 'edit') {
		tasks.get($stateParams.task_id).then(function(result) {
			$log.debug(result.data);
			$scope.task = result.data;
			$scope.task.milestone = ($scope.task.milestone ? $scope.task.milestone.id : null);
			$scope.task.user = ($scope.task.user ? $scope.task.user.id : null);
			doLoadStep();
		});
	} else {
		doLoadStep();
	}

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

	$scope.selectCategories = function() {
		console.log($scope.task.categories);
		modals.selectCategories($scope.task.categories, function(categories) {
			if (categories) {
				$scope.task.categories = categories;
			}
		});
	};

	$scope.createTask = function() {
		$scope.formLoading = true;

		if ($scope.task.description === '') {
			delete $scope.task.description;
		}

		if ($scope.task.milestone === null) {
			delete $scope.task.milestone;
		}

		tasks.create($scope.task).then(function(result) {
			$scope.formLoading = false;

			if (result.data.id) {
				$state.go('project_tasks', { project_id: $stateParams.project_id, v: 'task' });
			}
		}, creationFailCallback);
	};

	$scope.saveTask = function() {
		$scope.formLoading = true;

		tasks.update($scope.task).then(function(result) {
			$scope.formLoading = false;

			if (result.data.id) {
				$state.go('project_tasks');
			}
		});
	};

	$scope.delete = function() {
		modals.confirm("Are you sure you want to delete this task?", function(result) {
			if (result) {
				$scope.formLoading = true;
				tasks.delete($scope.task.id).then(function() {
					$scope.formLoading = false;
					$state.go('project_tasks');
				});
			}
		});
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