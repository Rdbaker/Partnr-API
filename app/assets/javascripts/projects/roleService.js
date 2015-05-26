angular.module('partnr.users.assets').factory('projectRoles', function($rootScope, $http, $log, principal) {
	return {
		create : function(role) {
			$log.debug("[PROJECT ROLE] Sending Create request");
			$log.debug(role);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'roles',
				headers: principal.getHeaders(),
				data: role
			});
		},

		update : function(role) {
			$log.debug("[PROJECT ROLE] Sending update request");
			$log.debug(role);

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'roles/' + role.id,
				headers: principal.getHeaders(),
				data: role
			})
		}
	};
});