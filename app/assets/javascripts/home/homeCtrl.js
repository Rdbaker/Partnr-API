angular.module('partnr.core').controller('HomeController', function($scope, $state, $q, $log,
	principal, search, toaster) {
	
	$scope.user = principal.getUser();
	$scope.search = search.createNew();

	$scope.doLogout = function() {
		principal.logout().then(function() {
			$state.go('login');
		});
	};

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