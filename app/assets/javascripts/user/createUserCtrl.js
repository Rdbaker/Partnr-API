angular.module('partnr.users').controller('CreateUserController', function($scope, $state, $log, users) {
	$scope.acct = {};
	$scope.acct.email = "";
	$scope.acct.first_name = "";
	$scope.acct.last_name = "";
	$scope.acct.password = "";

	$scope.doAccountCreate = function() {
		users.create($scope.acct).then(function(data, status, headers, config) {
			$log.debug(status);
			$state.go('home');
		});
	}
});