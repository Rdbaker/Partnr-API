angular.module('partnr.auth', []);
angular.module('partnr.users', []);
angular.module('partnr.messaging', []);
angular.module('partnr.toaster', []);
angular.module('partnr', ['ui.router', 
  'ui.bootstrap', 'templates', 
  'partnr.auth', 'partnr.users', 'partnr.messaging',
  'partnr.toaster'
  ]).run(function ($state, $rootScope, $log, principal, authorization) {
   $rootScope.$state = $state; // application state
   $rootScope.apiRoute  = '/';
   $rootScope.version   = '0.3.1';

   $rootScope.$on('$stateChangeStart', function(e, toState, toParams, fromState, fromParams) {
      $log.debug("[STATE] State change occurring: " + toState.name);
      $rootScope.toState = toState;
      $rootScope.toStateParams = toParams;

      // authorize user before page access
      authorization.authorize();
   });
});
