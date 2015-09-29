angular.module('partnr.users.assets').controller('ListProjectController', function($scope, $state, $log, $q, projects, principal, toaster) {
	$scope.projects = [];
	$scope.loadComplete = false;
	
	projects.list().then(function(result) {
		$scope.projects = result.data;
		$scope.loadComplete = true;
	});
});