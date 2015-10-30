angular.module('partnr.users.assets').controller('OwnerListProjectController', function($scope, $state, $log, $q, projects, principal, toaster) {
	$scope.projects = [];
	$scope.loadComplete = false;
	
	projects.listByOwner(principal.getUser().id).then(function(result) {
		$scope.projects = result.data;
		$scope.loadComplete = true;
	});
});