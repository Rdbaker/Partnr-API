angular.module('partnr.users.assets').directive('categoriesList', function($rootScope, $state) {
    return {
        restrict: 'AE',
        templateUrl: 'skills/list_categories.html',
        scope: {
            options: '='
        },
        link: function($scope, elem, attr, ctrl) {
            
        }
    };
});