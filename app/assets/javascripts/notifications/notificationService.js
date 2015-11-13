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
				callback(result);

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

		update : function(notification) {
			$log.debug("[NOTIFICATIONS] Sending update request");
			$log.debug(notification);

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'notifications/' + notification.id,
				headers: principal.getHeaders(),
				data: notification
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