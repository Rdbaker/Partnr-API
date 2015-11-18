angular.module('partnr.users.assets').controller('ListNotificationsController', function($scope, $state, $stateParams, $log, notifications) {
	$scope.loadComplete = true;
	$scope.allNotifications = notifications.get();

	$scope.$on("notifications", function(event, notificationList) {
		$log.debug(notificationList);

		$scope.allNotifications = notificationList;
		$scope.readNotifications = angular.copy($scope.allNotifications);
		for (var i = 0; i < $scope.readNotifications.length; i++) {
			if ($scope.readNotifications[i].read == false) {
				notifications.setRead($scope.readNotifications[i].id);
			}
		}
	});
});