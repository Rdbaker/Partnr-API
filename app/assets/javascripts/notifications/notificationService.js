angular.module('partnr.notify').factory('notifications', function($rootScope, $http, $log, $timeout, principal) {
	var polling = false;
	var notifications = {};

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

	var enablePolling = function() {
		$log.debug("[NOTIFICATIONS] polling enabled");
		polling = true;
	};

	var disablePolling = function() {
		$log.debug("[NOTIFICATIONS] polling disabled");
		polling = false;
	};

	$rootScope.$on('auth', function(event, eventData) {
        if (eventData.status === "login_success") {
        	enablePolling();
        	poller(function(result) {
        		var old = notifications;
        		notifications = result;
                $log.debug(notifications);

                if (JSON.stringify(notifications) !== JSON.stringify(old)) {
                	$rootScope.$broadcast('notifications', notifications);
                }
        	});
        } else if (eventData.status === "logout_success") {
        	disablePolling();
        	notifications = {};
        }
    });

	return {
		poller : poller,
		enablePolling : enablePolling,
		disablePolling : disablePolling,

		get : function() {
			return notifications;
		},

		getNew : function() {
			return notifications.filter(function(n) {
				return !(n.read);
			});
		},

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
		}
	};
});