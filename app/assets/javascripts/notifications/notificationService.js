angular.module('partnr.notify').factory('notifications', function($rootScope, $http, $log, $timeout, principal) {
	var polling = false;

	var poller = function(callback) {
		if (polling) {
			$log.debug("[NOTIFICATIONS] Sending Get request");
			
			$http({
				method: 'GET',
				url: $rootScope.apiRoute + 'notifications',
				headers: principal.getHeaders()
			}).then(function(result) {
				callback(result.data);

				if (polling) {
					$timeout(function() {
						poller(callback);
					}, 10000);
				}
			});
		}
	};

	return {
		poller : poller,

		setRead : function(id) {
			$log.debug("[NOTIFICATIONS] Sending read request");
			$log.debug(id);

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'notifications/' + id,
				headers: principal.getHeaders(),
				data: {
					read: true
				}
			});
		},

		enablePolling : function() {
			$log.debug("[NOTIFICATIONS] polling enabled");
			polling = true;
		},

		disablePolling : function() {
			$log.debug("[NOTIFICATIONS] polling disabled");
			polling = false;
		}
	};
});