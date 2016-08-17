angular.module('partnr.auth', []);
angular.module('partnr.users', []);
angular.module('partnr.messaging', []);
angular.module('partnr.notify', []);
angular.module('partnr.search', []);
angular.module('partnr.feed', []);
angular.module('partnr.users.assets', []);
angular.module('partnr.core', ['ui.router', 'angular-inview',
  'ui.bootstrap', 'templates', 'wu.masonry', 'ngTagsInput', 'ngSanitize',
  'partnr.auth', 'partnr.users', 'partnr.messaging',
  'partnr.notify', 'partnr.search', 'partnr.users.assets',
  'partnr.feed'
  ]).run(function ($state, $rootScope, $log, $window, $location, principal, authorization, skills) {

   /**
    * Set basic app-level variables and manage state changes
    */
   principal.fetchCsrf();
   $rootScope.$state = $state; // application state
   $rootScope.apiVersion = "v1";
   $rootScope.apiRoute  = '/api/' + $rootScope.apiVersion + '/';
   $rootScope.version   = '1.2.2';
   $rootScope.pollDuration = 10000;
   $rootScope.toastDuration = 8000;
   if(window.location.host === "app.partnr-up.com") {
    $rootScope.env = 'PRD';
   } else if(window.location.host === "dev.partnr-up.com") {
    $rootScope.env = 'DEV';
   } else {
    $rootScope.env = 'LCL';
   }
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

   /**
    * Load skill categories
    */
    $rootScope.categories = [];
    skills.listCategories().then(function(result) {
      if (result.data) {
        $rootScope.categories = result.data;

        for (var i = 0; i < $rootScope.categories.length; i++) {
          $rootScope.categories[i].color_rgb = skills.hexToRgb($rootScope.categories[i].color_hex);
        }

        $log.debug(result.data);
      }
    });


    /**
     * Create the feature gate
     */
    $rootScope.featureGate = {
      profile: {
        msgBtn: false
      }
    };
});
