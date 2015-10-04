angular.module('partnr.auth').controller('LoginController', function($scope, $log, $state, $q, principal, toaster) {
	$scope.email = '';
	$scope.password = '';
	$scope.loading = false;

	if (principal.isAuthenticated()) {
		$state.go('home');
	}

	$scope.doLogin = function() {
		if ($scope.email.length > 0 && $scope.password.length > 0) {
			$scope.loading = true;
			principal.login($scope.email, $scope.password).then(function(result) {
				$scope.loading = false;
				if (result) {
					$state.go('home');
				}
			});
		} else {
			toaster.warn("Please enter a valid email/password");
		}
	}
});