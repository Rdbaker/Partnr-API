angular.module('partnr.core').controller('HomeController', function($scope, $state, $q, $log,
	principal, search, toaster, projects) {
	$scope.user = principal.getUser();
	$scope.searchQuery = '';
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

  $scope.processInput = function(e) {
    if(e.which === 13)
      $scope.doSearch();
  }

	projects.list().then(function(result) {
		$scope.projects = result.data;
		$scope.loadComplete = true;
	});

	$scope.doSearch = function() {
    $state.go('search', { q: $scope.searchQuery });
	};
});
