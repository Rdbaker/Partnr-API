angular.module('partnr.notify').directive('notificationsDropdown', function($rootScope, $state, $log, routeUtils, notifications) {
    return {
        restrict: 'AE',
        templateUrl: 'notifications/notifications_dropdown.html',
        scope: {
            visible: '=',
            doDropdownChange: '&'
        },
        link: function($scope, elem, attr, ctrl) {
            $scope.dropdownLimit = 10;
            $scope.notifications = notifications.get();
            $scope.hasBeenOpened = false;
            $scope.routeUtils = routeUtils;

            $scope.$on('notifications', function(event, notifications) {
                $scope.notifications = notifications;
            });

            $scope.$watch('visible', function() {
                if ($scope.visible) {
                    $scope.hasBeenOpened = true;
                }

                if (!$scope.visible && $scope.hasBeenOpened) {
                    $log.debug('setting read');
                    $scope.readNotifications = angular.copy($scope.notifications);

                    var totalRead = ($scope.readNotifications.length > $scope.dropdownLimit 
                        ? $scope.dropdownLimit : $scope.readNotifications.length);
                    for (var i = 0; i < totalRead; i++) {
                        if ($scope.readNotifications[i].read == false) {
                            notifications.setRead($scope.readNotifications[i].id);
                        }
                    }
                }
            });

            $scope.doViewMore = function() {
                $state.go('notification_list');
                $scope.doDropdownChange();
            };

            $scope.resolveLink = function(n) {
                routeUtils.resolveEntityLinkAndGo(n.links.notifier, n, notifications.linkParamResolveStrategy);
                $scope.doDropdownChange();
            };
        }
    };
});