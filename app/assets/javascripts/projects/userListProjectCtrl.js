angular.module('partnr.users.assets').controller('UserListProjectController', function($scope, $state, $log, $q, projects, principal, toaster) {
	$scope.projects = [];
	$scope.loadComplete = false;

	projects.listByUser(principal.getUser().id).then(function(result) {
		$scope.projects = result.data;
		$scope.loadComplete = true;
	});
});
