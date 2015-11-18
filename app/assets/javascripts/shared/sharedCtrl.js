angular.module('partnr.core').controller('SharedController', function($scope, $state, $stateParams, $log, $q, notifications) {
	$scope.newNotifications = {};

    $scope.$on('notifications', function() {
        $log.debug("NEW NOTIFICATIONS");
        $scope.newNotifications = notifications.getNew();
    });
});