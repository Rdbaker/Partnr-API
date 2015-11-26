angular.module('partnr.users').controller('ResetPasswordController', function($scope, $state, $stateParams, $log, $q, users, principal, toaster) {
	$scope.token = $stateParams.reset_password_token;
	$scope.password = "";
	$scope.confirmPassword = "";
	$scope.submitted = false;
	$scope.invalidToken = false;
	$scope.loadComplete = true;

	$log.debug("Got token: " + $scope.token);

	$scope.validate = function() {
		return ($scope.password === $scope.confirmPassword);
	}

	$scope.doSubmit = function() {
		if ($scope.validate()) {
			$scope.loadComplete = false;
			users.resetPassword($scope.token, $scope.password, $scope.confirmPassword).then(function(result) {
				$scope.submitted = true;
				$scope.loadComplete = true;
			}, function(result) {
				$scope.loadComplete = true;
				$scope.invalidToken = true;
				$scope.submitted = true;
			});
		} else {
			toaster.error("Passwords do not match");
		}
	}
});