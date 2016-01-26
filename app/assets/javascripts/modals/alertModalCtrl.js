angular.module('partnr.notify').controller('AlertModalController', function($scope, $uibModalInstance, $sce, title, message) {
    $scope.title = title;
    $scope.message = $sce.trustAsHtml(message);
    
    $scope.ok = function () {
        $uibModalInstance.close('ok');
    };
});
