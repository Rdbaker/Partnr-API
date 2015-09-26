angular.module('partnr.users.assets').factory('projects', function($rootScope, $http, $log, principal) {
	return {
		list : function() {
			$log.debug('[PROJECT] Sending list request');

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'projects',
				headers: principal.getHeaders()
			});
		},

		create : function(project) {
			$log.debug("[PROJECT] Sending Create request");

			project.owner = principal.getUser().id;
			$log.debug(project);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'projects',
				headers: principal.getHeaders(),
				data: project
			});
		}
	};
});