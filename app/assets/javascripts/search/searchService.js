angular.module('partnr.search').factory('search', function($rootScope, $http, $log, principal) {
	return {
		createNew : function() {
			return {
				keywords: "",
				result: {},
				queried: false 
			};
		},

		queryProjects : function(keywords) {
			$log.debug('[SEARCH] Sending get request for projects with keywords ' + keywords);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'projects',
				headers: principal.getHeaders(),
				params: { title: keywords }
			});
		},

		queryRoles : function(keywords) {
			$log.debug('[SEARCH] Sending get request for roles with keywords ' + keywords);

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'roles',
				headers: principal.getHeaders(),
				params: { title: keywords }
			});
		}
	};
});