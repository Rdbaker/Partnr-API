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
			principal.login($scope.email, $scope.password).then(function(loggedIn) {
				if (loggedIn) {
					var user = principal.getUser();
					if (user.last_login != null || user.last_login != undefined) {
						$state.go('home');
					} else {
						$state.go('profile_create');
					}
				}
				$scope.loading = false;
			});
		} else {
			toaster.warn("Please enter a valid email/password");
		}
	}
});