angular.module('partnr.auth').controller('LoginController', function($scope, $log, $state, $q, principal) {
	$scope.email = '';
	$scope.password = '';
	
	if (principal.isAuthenticated()) {
		$state.go('home');
	}

	$scope.doLogin = function() {
		if ($scope.email.length > 0 && $scope.password.length > 0) {
			principal.login($scope.email, $scope.password).then(function() {
				if (principal.isAuthenticated()) {
					$state.go('home');
				}
			});
		}
	}
});