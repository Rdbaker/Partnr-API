angular.module('partnr.core').controller('SharedController', function($scope, $state, $stateParams, $log, $q, notifications, routeUtils) {
	$scope.newNotifications = {};
	$scope.allNotifications = {};
    $scope.notificationsDropdownVisible = false;

    $scope.$on('notifications', function(event, updatedNotifications) {
    	$scope.allNotifications = updatedNotifications;
        $scope.newNotifications = notifications.getNew();
    });

    $scope.toggleNotificationsDropdown = function() {
        $scope.notificationsDropdownVisible = !($scope.notificationsDropdownVisible);
    };
});