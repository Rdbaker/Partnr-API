angular.module('partnr.users.assets').factory('projects', function($rootScope, $http, $log, principal) {
	return {
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