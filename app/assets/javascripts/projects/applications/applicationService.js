angular.module('partnr.users.assets').factory('applications', function($rootScope, $http, $log, principal) {
	return {
		get : function(project_id, user_id) {
			$log.debug("[APPLICATION] Sending get request");
			$log.debug(project_id);
			$log.debug(user_id);

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'applications?user=' + user_id + '?project=' + project_id,
				headers: principal.getHeaders()
			});
		},

		create : function(application) {
			$log.debug("[APPLICATION] Sending create request");
			$log.debug(application);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'applications',
				headers: principal.getHeaders(),
				data: application
			});
		}
	};
});