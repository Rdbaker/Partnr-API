angular.module('partnr.auth').controller('LoginController', function($scope, $log, principal) {
	$scope.email = '';
	$scope.password = '';

	$scope.doLogin = function() {
		if ($scope.email.length > 0 && $scope.password.length > 0) {
			principal.login($scope.email, $scope.password).then(function() {
				console.log("check log in here");
			});
		}
	}
});