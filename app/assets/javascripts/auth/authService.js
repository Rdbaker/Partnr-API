angular.module('partnr.auth').factory('auth', function($rootScope, $http, $log) {
	var user = {};
	var authenticated = false;
	var csrfToken = null;

	function getCsrf() {
		var promise = $http.get($rootScope.apiRoute + 'api/users/sign_in')
		.success(function(data, status, headers, config) {
			if (data.csrfToken) {
				csrfToken = data.csrfToken;
				$log.debug('[AUTH] CSRF token acquired');
			}
		})
		.error(function(data, status, headers, config) {
			$log.error('[AUTH] CSRF request failure');
		});

		return promise;
	}

	return {
		login : function(email, password) {
			$log.debug('[AUTH] Inside login function');
			var promise = getCsrf().then($http({
					method: 'POST',
					url: $rootScope.apiRoute + 'api/users/sign_in',
					headers: { 
						'X-CSRF-Token' : csrfToken,
						'Content-Type': 'application/json' 
					},
					data: {
						'user' : {
							'email' : email,
							'password' : password,
						}
					}
				})
				.success(function(data, status, headers, config) {
					if (data.user && data.csrfToken) {
						user = data.user;
						csrfToken = data.csrfToken;
						authenticated = true;
						$log.debug('[AUTH] User authenticated');
						$log.debug(user);
					} else {
						$log.error('[AUTH] Log in failure')
					}
				})
				.error(function(data, status, headers, config) {
					$log.error('[AUTH] Log in failure');
				})
			);

			return promise;
		},

		logout : function() {
			return $http({
				method: 'DELETE',
				url: $rootScope.apiRoute + 'api/users/sign_out'
			}).success(function(data, status, headers, config) {
				user = {};
				authenticated = false;
				$log.debug('[AUTH] User signed out');
			});
		},
		
		getUser : function() {
			return user;
		},

		isAuthenticated : function() {
			return authenticated;
		}
	};
});