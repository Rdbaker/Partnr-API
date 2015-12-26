angular.module('partnr.users').factory('users', function($rootScope, $http, $log, principal) {
	return {
		get : function(id) {
			$log.debug("[USER] Sending GET request");

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'users/' + id,
				headers: principal.getHeaders()
			});
		},

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

		sendPasswordResetRequest : function(email) {
			$log.debug("[USER] Sending reset password request");
			$log.debug(email);

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'users/passwords/reset',
				headers: principal.getHeadersWithCsrf(),
				params: { "email" : email }
			});
		},

		resetPassword : function(token, password, confirmPassword) {
			$log.debug("[USER] Sending new password");

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'users/passwords/reset',
				headers: principal.getHeadersWithCsrf(),
				data: {
					"reset_password_token" : token,
					"password" : password,
					"password_confirmation" : confirmPassword
				}
			});
		}
	};
});