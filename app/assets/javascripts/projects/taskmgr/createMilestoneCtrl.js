angular.module('partnr.users.assets').controller('CreateMilestoneController', function($scope, $state, $stateParams, $log, $q, $timeout, milestones, principal, toaster) {
	$scope.milestone = {
		title: '',
		due_date: '',
		project: $stateParams.project_id
	};

	$scope.loading = false;

	var creationFailCallback = function() {
		$scope.loading = false;
		toaster.error("Milestone could not be created. Please try again.");
	};

	$scope.createMilestone = function() {
		$scope.loading = true;

		if ($scope.milestone.due_date === '') {
			delete $scope.milestone.due_date;
		}

		milestones.create($scope.milestone).then(function(result) {
			$scope.loading = false;

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