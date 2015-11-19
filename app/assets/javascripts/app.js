angular.module('partnr.auth', []);
angular.module('partnr.users', []);
angular.module('partnr.messaging', []);
angular.module('partnr.notify', []);
angular.module('partnr.users.assets', []);
angular.module('partnr.core', ['ui.router',
  'ui.bootstrap', 'templates',
  'partnr.auth', 'partnr.users', 'partnr.messaging',
  'partnr.notify', 'partnr.users.assets'
  ]).run(function ($state, $rootScope, $log, $window, $location, principal, authorization) {
   principal.fetchCsrf();
   $rootScope.$state = $state; // application state
   $rootScope.apiRoute  = '/api/v1/';
   $rootScope.version   = '0.3.8';
   var bypassAuthCheck = false;

   $rootScope.isLoggedIn = function() {
      return principal.isAuthenticated();
   };

   $rootScope.$on('$stateChangeStart', function(e, toState, toParams, fromState, fromParams) {
      if (bypassAuthCheck) {
        bypassAuthCheck = false;
        return;
      };

      e.preventDefault();
      $log.debug("[STATE] State change occurring: " + toState.name);
      bypassAuthCheck = true;
      $rootScope.toState = toState;
      $rootScope.toParams = toParams;

      authorization.authorize().then(function(authorized) {
        if (authorized) {
          if ($state.current.name == toState) {
            bypassAuthCheck = false;
          } else {
            $state.go(toState, toParams);
          }
        } else {
          if ($state.current.name == 'login') {
            bypassAuthCheck = false;
          } else {
            $state.go('login');
          }
        }
      });
   });

   $rootScope.$on('$stateChangeSuccess', function(event) {
    if (!$window.ga)
      return;

    $window.ga('send', 'pageview', { page: $location.url() });
   });
});
