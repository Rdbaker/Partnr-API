angular.module('partnr.notify').controller('SelectCategoriesModalController', function($scope, $uibModalInstance, $filter, $log, selectedCategories) {
    $scope.max = 3;
    $scope.selected = [];

    if (selectedCategories) {
        for (var i = 0; i < selectedCategories.length; i++) {
            $scope.selected.push(selectedCategories[i]);
        }
    }

    $scope.$on('category::button::click', function(event, selectData) {
        var selectedIdx = $scope.selected.indexOf(selectData.category);

        if (selectedIdx === -1) {
            if ($scope.selected.length < $scope.max) {
                $scope.selected.push(selectData.category);
            }
        } else {
            $scope.selected.splice(selectedIdx, 1);
        }
    });

    $scope.ok = function () {
        $uibModalInstance.close($scope.selected);
    };

    $scope.reset = function() {
        $scope.selected = [];
    };

    $scope.cancel = function() {
        $uibModalInstance.close(false);
    };
});

