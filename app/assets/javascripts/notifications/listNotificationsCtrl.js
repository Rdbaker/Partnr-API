angular.module('partnr.users.assets').controller('ListNotificationsController', function($scope, $state, $stateParams, notifications) {
	$scope.loadComplete = true;

	$scope.$watch("notifications", function(newValue, oldValue) {
		$scope.readNotifications = angular.copy($scope.notifications);
		for (var i = 0; i < $scope.readNotifications.length; i++) {
			if ($scope.readNotifications[i].read == false) {
				notifications.setRead($scope.readNotifications[i].id);
			}
		}
	})
});