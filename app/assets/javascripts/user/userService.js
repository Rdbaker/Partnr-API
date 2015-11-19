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
		}
	};
});