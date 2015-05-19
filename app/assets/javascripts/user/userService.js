angular.module('partnr.users').factory('users', function($rootScope, $http, $log, principal) {
	return {
		create : function(acct) {
			return principal.getCsrf().then(function(csrf) {
				$log.debug(acct);
				return $http({
					method: 'POST',
					url: $rootScope.apiRoute + 'api/users',
					headers: {
						'X-CSRF-Token' : csrf,
						'Content-Type' : 'application/json'
					},
					data: { "user" : acct }
				});
			});
		}
	};
});