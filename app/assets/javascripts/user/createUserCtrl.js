angular.module('partnr.users').controller('CreateUserController', function($scope, $state, $log, $q, users, principal, toaster) {
	$scope.acct = {
		email : "",
		first_name: "",
		last_name: "",
		password: ""
	};

	if (principal.isAuthenticated()) {
		$state.go('home.feed');
	}


	$scope.validate = function() {
		var result = ($scope.acct.email.length > 0 &&
			$scope.acct.first_name.length > 0 &&
			$scope.acct.last_name.length > 0 &&
			$scope.acct.password.length > 0);
		return result;
	}

	$scope.doCreateUser = function() {
		if ($scope.validate()) {
			users.create($scope.acct).success(function(data, status, headers, config) {
				$log.debug(data);
				if (data.id) {
					$state.go('login');
				} else {
					$log.debug("[USER] Create error");
					if (data.error) { $log.debug(data.error); }
					toaster.error("User could not be created.");
				}
			});
		} else {
			toaster.error("Please ensure that you entered data in all of the fields");
		}
	}
});
