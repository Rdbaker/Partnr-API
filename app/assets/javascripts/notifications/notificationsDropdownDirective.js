angular.module('partnr.notify').directive('notificationsDropdown', function($rootScope, routeUtils, notifications) {
    return {
        restrict: 'AE',
        templateUrl: 'notifications/notifications_dropdown.html',
        link: function($scope, elem, attr, ctrl) {
            $scope.notifications = notifications.get();

            $scope.$on('notifications', function(event, notifications) {
                $scope.notifications = notifications;
            });
        }
    };
});