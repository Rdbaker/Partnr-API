angular.module('partnr').controller('HomeController', function($scope, $state, principal) {
	
	$scope.doLogout = function() {
		principal.logout().then(function() {
			$state.go('login');
		});
	}
});