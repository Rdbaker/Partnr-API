angular.module('partnr.users.assets').directive('categoryButton', function($rootScope, $state, skills) {
    return {
        restrict: 'AE',
        templateUrl: 'skills/category_button.html',
        scope: {
            category: '='
        },
        link: function($scope, elem, attr, ctrl) {
            $scope.selected = false;

            $scope.selectToggle = function() {
            	$scope.selected = !$scope.selected;
            }

            $scope.buttonBackground = function() {
            	var rgb = skills.hexToRgb($scope.category.color_hex);
            	return "rgba(" + rgb.r + ", " + rgb.g + ", " + rgb.b + ", 0.6)";
            }
        }
    };
});