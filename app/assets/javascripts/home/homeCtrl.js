angular.module('partnr.core').controller('HomeController', function($scope, $state, $q, $log,
	principal, search, toaster, projects) {
	$scope.user = principal.getUser();
	$scope.search = search.createNew();
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

	$scope.doSearch = function() {
		$q.all([
			search.queryProjects($scope.search.keywords),
			search.queryRoles($scope.search.keywords)
		]).then(function(result) {
			$scope.search.queried = true;
			$scope.search.result.projects = result[0].data;
			$scope.search.result.roles = result[1].data;
			$log.debug($scope.search);
		});
	};
});
