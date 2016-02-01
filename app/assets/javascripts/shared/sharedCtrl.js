angular.module('partnr.core').controller('SharedController', function($scope, $state, $stateParams, $log, $q, notifications, routeUtils, principal) {
    $scope.newNotifications = {};
	$scope.allNotifications = {};

    $scope.$on('notifications', function(event, updatedNotifications) {
        $scope.allNotifications = updatedNotifications;
        $scope.newNotifications = notifications.getNew();
    });

    $scope.doLogout = function() {
        principal.logout().then(function() {
            $state.go('login');
        });
    };

    $scope.doViewProfile = function() {
        $state.go('profile', { id : principal.getUser().id });
    };

    $scope.resolveLink = function(n) {
        routeUtils.resolveEntityLinkAndGo(n.links.notifier, n, notifications.linkParamResolveStrategy);
    };

    $scope.setRead = function(open) {
        if (!open) {
            $log.debug('setting read');
            $scope.readNotifications = angular.copy($scope.allNotifications);

            var totalRead = ($scope.readNotifications.length > 10 ? 10 : $scope.readNotifications.length);
            for (var i = 0; i < totalRead; i++) {
                if ($scope.readNotifications[i].read == false) {
                    notifications.setRead($scope.readNotifications[i].id);
                }
            }
        }
    };
});