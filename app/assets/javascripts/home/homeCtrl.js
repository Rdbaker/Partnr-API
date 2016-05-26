angular.module('partnr.core').controller('HomeController', function($scope, $state, $q, $log,
	principal, search, toaster, projects) {
	$scope.user = principal.getUser();
	$scope.searchQuery = '';

  $scope.processInput = function(e) {
    if(e.which === 13)
      $scope.doSearch();
  }

  $scope.doSearch = function() {
    $state.go('search', { q: $scope.searchQuery });
	};
});
