angular.module('partnr.notify').controller('ConfirmModalController', function($scope, $sce, $uibModalInstance, message) {
    $scope.message = $sce.trustAsHtml(message);
    
    $scope.yes = function () {
        $uibModalInstance.close(true);
    };

    $scope.no = function() {
        $uibModalInstance.close(false);
    };

    $scope.cancel = function() {
        $uibModalInstance.close(false);
    };
});
