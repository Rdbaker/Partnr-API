angular.module('partnr.users.assets').directive('pnConnBtn', function(connections) {
  return {
    restrict: 'AE',
    template: "<div ng-include='contentUrl'></div>",
    scope: {
      connection_status: '=connectionStatus',
      userId: '=userId'
    },
    link: function($scope, elem) {
      if(!$scope.connection_status)
        $scope.connection_status = 'connect';

      $scope.contentUrl = 'shared/connection/connection_' + $scope.connection_status + '_btn.html';

      $scope.sendRequest = function() {
        connections.create($scope.userId).then(function(res) {
          $scope.contentUrl = 'shared/connection/connection_requested_btn.html';
        });
      };

      $scope.deleteConnection = function() {
        connections.deleteByUser($scope.userId).then(function(res) {
          $scope.contentUrl = 'shared/connection/connection_connect_btn.html';
        });
      };

      $scope.approveRequest = function() {
        connections.updateByUser($scope.userId, 'accepted').then(function(res) {
          $scope.contentUrl = 'shared/connection/connection_connected_btn.html';
        });
      };
    }
  }
});
