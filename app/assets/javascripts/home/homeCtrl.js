angular.module('partnr').controller('HomeController', function($scope, $state, principal, toaster) {
	$scope.user = principal.getUser();

	$scope.doLogout = function() {
		principal.logout().then(function() {
			$state.go('login');
		});
	}
});