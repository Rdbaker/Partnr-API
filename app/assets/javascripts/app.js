angular.module('partnr.messaging', []);
angular.module('partnr.auth', []);
angular.module('partnr', ['ui.router', 'ui.bootstrap', 'templates', 'partnr.messaging', 'partnr.auth']).run(function ($state, $rootScope, $log, auth) {
   $rootScope.$state = $state;
   $rootScope.apiRoute  = 'http://dev-partnr.herokuapp.com/';
   $rootScope.csrfToken = '';
   $rootScope.version   = '0.3.0';

   $rootScope.$on('$stateChangeStart', function(e, toState, toParams, fromState, fromParams) {
        var isLogin = toState.name === "login";
       
        if(isLogin){
           return;
        }

        if(auth.isAuthenticated() === false) {
            e.preventDefault();
            $state.go('login');
        }
    });
});;