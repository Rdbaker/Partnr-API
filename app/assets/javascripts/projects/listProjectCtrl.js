angular.module('partnr.users.assets').controller('ListProjectController', function($scope, $state, $log, $q, projects, principal, toaster) {
	$scope.projects = [];
	$scope.loadComplete = false;
	
	$scope.getProjectStatus = function(status) {
		if (status === 'not_started') {
			return "Not Started";
		} else if (status === 'in_progress') {
			return "In Progress";
		} else {
			return "Complete";
		}
	}

	projects.list().then(function(result) {
		$scope.projects = result.data;
		$scope.loadComplete = true;
	});
});