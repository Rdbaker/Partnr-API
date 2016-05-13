angular.module('partnr.feed').factory('feeds', function($rootScope, $http, $log, principal) {
  return {
    list: function(page) {
      return $http({
        method: 'GET',
        url: $rootScope.apiRoute + 'feeds',
        params: { page: page },
        headers: principal.getHeaders()
      });
    }
  }
});
