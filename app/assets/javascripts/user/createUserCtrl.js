angular.module('partnr.users').controller('CreateUserController', function($scope, $state, $log, $q, users, principal) {
	$scope.acct = {
		email : "",
		first_name: "",
		last_name: "",
		password: ""
	};

	if (principal.isAuthenticated()) {
		$state.go('home');
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
				console.log(data);
				if (data.id) {
					$state.go('login');
				} else {
					$log.debug("[USER] Create error");
					if (data.error) { $log.debug(data.error); }
				}
			});
		}
	}
});