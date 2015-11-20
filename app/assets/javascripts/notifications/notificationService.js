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

	var processPollResult = function(result) {
		var old = notifications;
		notifications = result;

		for (var i = 0; i < notifications.length; i++) {
			notifications[i].parsedMessage = parse(notifications[i]);
		}

        $log.debug(notifications);

        if (angular.toJson(notifications) !== angular.toJson(old)) {
			$log.debug("[NOTIFICATIONS] new notifications");
        	$rootScope.$broadcast('notifications', notifications);
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

	var parse = function(notification) {
		var result = notification.message;

		for (var k in notification.notifier) {
			result = result.replace('{' + k + '}', notification.notifier[k].title);
		}

		return result;
	};

	$rootScope.$on('auth', function(event, eventData) {
        if (eventData.status === "login_success") {
        	enablePolling();
        	poller(processPollResult);
        } else if (eventData.status === "logout_success") {
        	disablePolling();
        	notifications = {};
        }
    });

	return {
		poller : poller,
		enablePolling : enablePolling,
		disablePolling : disablePolling,
		parse : parse,

		get : function() {
			return angular.copy(notifications);
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