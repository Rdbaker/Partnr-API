angular.module('partnr.users.assets').directive('skillCategoryEditor', function($rootScope, $state, skills) {
    return {
        restrict: 'AE',
        templateUrl: 'skills/skill_category_editor.html',
        scope: {
            categories: '=',
            skills: '='
        },
        link: function($scope, elem, attr, ctrl) {
            $scope.skillCategoryMap = [];

            if ($scope.skills) {
                // prepare skills for display to the tag list and map skills to a category
                for (var idx = 0; idx < $scope.skills.length; idx++) {
                    $scope.skills[idx].text = $scope.skills[idx].title;

                    if ($scope.skills[idx].category
                        && $scope.skills[idx].category.id) {
                        if ($scope.skillCategoryMap[$scope.skills[idx].category.id] === undefined) {
                            $scope.skillCategoryMap[$scope.skills[idx].category.id] = [ $scope.skills[idx] ];
                        } else {
                            $scope.skillCategoryMap[$scope.skills[idx].category.id].push($scope.skills[idx]);
                        }
                    }
                }
            }
        }
    };
});