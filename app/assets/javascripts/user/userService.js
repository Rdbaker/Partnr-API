angular.module('partnr.users').factory('users', function($rootScope, $http, $log, principal) {
	return {
		create : function(acct) {
			$log.debug("[USER] Sending Create request");
			$log.debug(acct);

			
			return $http({
				method: 'POST',
				url: '/api/users',
				headers: principal.getHeadersWithCsrf(),
				data: { "user" : acct }
			});
		},

		resetPassword : function(email) {
			$log.debug("[USER] Sending reset password request");
			$log.debug(email);

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'users/passwords/reset',
				headers: principal.getHeadersWithCsrf(),
				params: { "email" : email }
			});
		}
	};
});