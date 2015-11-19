angular.module('partnr.core').controller('SharedController', function($scope, $state, $stateParams, $log, $q, notifications) {
	$scope.newNotifications = {};
    $scope.notificationsDropdownVisible = false;

    $scope.$on('notifications', function() {
        $scope.newNotifications = notifications.getNew();
    });

    $scope.toggleNotificationsDropdown = function() {
        $scope.notificationsDropdownVisible = !($scope.notificationsDropdownVisible);
    };
});