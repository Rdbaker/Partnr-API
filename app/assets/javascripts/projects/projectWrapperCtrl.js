angular.module('partnr.users.assets').controller('ProjectWrapperController', function($scope, $state, $stateParams, $log) {
	$scope.loadComplete = false;
	$scope.isMember = false;
	$scope.isOwner = false;
	$scope.projectId = $stateParams.id;

	console.log($scope.projectId);

	$scope.setLoadComplete = function(complete) {
		$scope.loadComplete = complete;
	};

	$scope.setAsMember = function() {
		$scope.isMember = true;
	};

	$scope.setAsOwner = function() {
		$scope.isOwner = true;
		$scope.isMember = true;
	};
});