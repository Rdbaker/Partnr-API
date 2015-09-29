angular.module('partnr.users.assets').factory('projects', function($rootScope, $http, $log, principal) {
	return {
		get : function(id) {
			$log.debug('[PROJECT] Sending get request for project ' + id);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'projects/' + id,
				headers: principal.getHeaders()
			});
		},

		list : function() {
			$log.debug('[PROJECT] Sending list request');

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'projects',
				headers: principal.getHeaders()
			});
		},

		create : function(project) {
			$log.debug("[PROJECT] Sending create request");

			project.owner = principal.getUser().id;
			$log.debug(project);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'projects',
				headers: principal.getHeaders(),
				data: project
			});
		},

		delete : function(id) {
			$log.debug("[PROJECT] Sending delete request");

			return $http({
				method: 'DELETE',
				url: $rootScope.apiRoute + 'projects/' + id,
				headers: principal.getHeaders()
			});
		}
	};
});