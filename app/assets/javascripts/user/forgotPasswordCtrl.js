angular.module('partnr.users').controller('ForgotPasswordController', function($scope, $state, $log, $q, users, principal, toaster) {
	$scope.email = "";
	$scope.submitted = false;
	$scope.loadComplete = true;

	$scope.validate = function() {
		return ($scope.email.length > 0);
	}

	$scope.doSubmit = function() {
		if ($scope.validate()) {
			$scope.loadComplete = false;
			users.resetPassword($scope.email).then(function(result) {
				$scope.submitted = true;
				$scope.loadComplete = true;
			});
		} else {
			toaster.error("Please ensure that you entered a valid email address");
		}
	}
});