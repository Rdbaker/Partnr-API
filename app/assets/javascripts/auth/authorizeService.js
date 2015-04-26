angular.module('partnr.auth').factory('authorization', function($rootScope, $state, $log, principal) {
  return {
    authorize: function() {
      return principal.identity()
        .then(function() {
          var isAuthenticated = principal.isAuthenticated();

          $log.debug("[AUTH] Authorizing...");
          $log.debug("[AUTH] Authenticated: " + isAuthenticated);
          $log.debug("[AUTH] Roles Required: ");
          if ($rootScope.toState.data.roles) {
            $log.debug($rootScope.toState.data.roles);
          } else {
            $log.debug('None');
          }

          if ($rootScope.toState.data.roles && 
            $rootScope.toState.data.roles.length > 0 && 
            !principal.hasAnyRole($rootScope.toState.data.roles)) {

            $log.debug("[AUTH] User is not authorized to view this page");
            
            if (isAuthenticated) {
                $log.debug("[AUTH] Redirecting user to restricted page");
                $state.go('login'); // restricted page in the future
            } else {
                $log.debug("[AUTH] Redirecting user to login page");
                $state.go('login');
            }
          } else {
            $log.debug("[AUTH] User is authorized to view this page");
          }
        });
    }
  };
});