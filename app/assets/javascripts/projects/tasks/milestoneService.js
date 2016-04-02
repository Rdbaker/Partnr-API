angular.module('partnr.users.assets').factory('milestones', function($rootScope, $http, $log, principal) {
	return {
		get : function(id) {
			$log.debug('[MILESTONE] Sending get request for milestone ' + id);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'milestones/' + id,
				headers: principal.getHeaders()
			});
		},

		// listByUser : function(id) {
		// 	$log.debug('[MILESTONE] Sending list for user');
		// 	$log.debug(id);

		// 	return $http({
		// 		method: 'GET',
		// 		url: $rootScope.apiRoute + 'milestones',
		// 		headers: principal.getHeaders(),
		// 		params: { user: id }
		// 	});
		// },

		list : function() {
			$log.debug('[MILESTONE] Sending list request');

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'milestones',
				headers: principal.getHeaders()
			});
		},

		create : function(milestone) {
			$log.debug("[MILESTONE] Sending create request");

			milestone.owner = principal.getUser().id;
			$log.debug(milestone);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'milestones',
				headers: principal.getHeaders(),
				data: milestone
			});
		},

		update : function(milestone) {
			$log.debug("[MILESTONE] Sending update request");
			$log.debug(milestone);

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'milestones/' + milestone.id,
				headers: principal.getHeaders(),
				data: milestone
			});
		},

		delete : function(id) {
			$log.debug("[MILESTONE] Sending delete request");

			return $http({
				method: 'DELETE',
				url: $rootScope.apiRoute + 'milestones/' + id,
				headers: principal.getHeaders()
			});
		}
	};
});
