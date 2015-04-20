angular.module('partnr.auth').controller('LoginController', function($scope, $log, auth) {
	$scope.email = '';
	$scope.password = '';

	$scope.doLogin = function() {
		if ($scope.email.length > 0 && $scope.password.length > 0) {
			auth.login($scope.email, $scope.password).then(function() {
				console.log("logged in");
			});
		}
	}
});