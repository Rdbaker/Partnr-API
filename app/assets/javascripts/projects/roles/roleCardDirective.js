angular.module('partnr.users.assets').directive('roleCard', function($rootScope, $state) {
    return {
        restrict: 'AE',
        templateUrl: 'projects/roles/role_card.html',
        scope: {
            role: '='
        },
        link: function($scope, elem, attr, ctrl) {
            $scope.$state = $state;
        }
    };
});
