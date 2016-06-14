angular.module('partnr.users.assets').controller('ProfileSkillsController', function($scope, $rootScope, $state, $stateParams, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;
	$scope.totalScore = 0;

	$scope.$parent.getProfileWrapperInfo().then(function(result) {
		$scope.user = result;

		for (var i = 0; i < $scope.user.resolvedCategories.length; i++) {
			$scope.totalScore += $scope.user.resolvedCategories[i].skillscore;
		}

		$scope.loadComplete = true;
	});
});