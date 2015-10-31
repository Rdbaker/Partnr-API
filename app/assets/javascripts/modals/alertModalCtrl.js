angular.module('partnr.notify').controller('AlertModalController', function($scope, $modalInstance, $sce, title, message) {
    $scope.title = title;
    $scope.message = $sce.trustAsHtml(message);
    
    $scope.ok = function () {
        $modalInstance.close('ok');
    };
});