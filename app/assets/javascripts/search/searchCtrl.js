angular.module('partnr.search').controller('SearchController', function($scope, $state, $stateParams, $q, $log,
  principal, search, toaster) {
  $scope.user = principal.getUser();
  $log.debug($scope.user);
  $scope.projects = [];
  $scope.roles = [];
  $scope.users = [];
  $scope.skills = [];
  $scope.query = "asdf";
  $scope.loadComplete = false;

  $scope.doSearch = function() {
    $stateParams.q = $scope.query;
    search.query($scope.query)
      .then(function(res) {
        $scope.projects = res.projects;
        $scope.roles = res.roles;
        $scope.users = res.users;
        $scope.skills = res.skills;
      });
  }


  if($stateParams.q !== undefined) {
    $scope.query = "asdf";
    $scope.doSearch();
  }

});
