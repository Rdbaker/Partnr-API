angular.module('partnr.toaster').directive('toasts', function($rootScope, toaster) {
    return {
        restrict: 'AE',
        templateUrl: 'toaster/toasts.html',
        link: function($scope, elem, attr, ctrl) {
            $scope.toasts = toaster.getToasts();

            $scope.$on('toast', function(event, toast) {
                $scope.toasts = toaster.getToasts();
            });

            $scope.closeAlert = function(index) {
                $scope.toasts.splice(index, 1);
            }
        }
    };
});