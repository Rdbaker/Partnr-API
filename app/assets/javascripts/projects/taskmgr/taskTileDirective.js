angular.module('partnr.users.assets').directive('taskTile', function($rootScope, $state) {
    return {
        restrict: 'AE',
        templateUrl: 'projects/taskmgr/task_tile.html',
        scope: {
            task: '='
        },
        link: function($scope, elem, attr, ctrl) {
            $scope.$state = $state;
        }
    };
});