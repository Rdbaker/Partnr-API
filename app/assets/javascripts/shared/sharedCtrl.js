angular.module('partnr.core').controller('SharedController', function($scope, $state, $stateParams, $log, $q, notifications) {
	$scope.notifications = {};

	$scope.$on('auth', function(event, eventData) {
        if (eventData.status === "login_success") {
        	notifications.enablePolling();
        	notifications.poller(function(result) {
        		$scope.notifications = result;
                $log.debug($scope.notifications);
        	});
        } else if (eventData.status === "logout_success") {
        	notifications.disablePolling();
        	$scope.notifications = {};
        }
    });
});