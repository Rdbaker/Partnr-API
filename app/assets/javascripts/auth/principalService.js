angular.module('partnr.auth').factory('principal', function($rootScope, $http, $log, $q) {
	var user          = undefined;
	var authenticated = false;
	var csrfToken     = undefined;

	function fetchCsrf() {
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

	function getCsrf() {
		if (csrfToken) {
			return csrfToken;
		} else {
			fetchCsrf().then(function() {
				return csrfToken;
			});
		}
	}

	return {
		identity : function() {
			/* This function will ultimately load user data from cookies or 
			   redirect to login function in some way
			*/
			var deferred = $q.defer();
			deferred.resolve(user);
			return deferred.promise;
		},

		getHeaders : function() {
			return {
				'X-CSRF-Token' : getCsrf(),
				'Content-Type' : 'application/json'
			};
		},

		login : function(email, password) {
			$log.debug('[AUTH] About to log in...');
			var promise = fetchCsrf().then(function() {
				var request = {
					'user' : {
						'email' : email,
						'password' : password,
						'authenticity_token' : csrfToken
					}
				};

				$log.debug(request);

				return $http({
					method: 'POST',
					url: $rootScope.apiRoute + 'api/users/sign_in',
					headers: {
						'X-CSRF-Token' : getCsrf(),
						'Content-Type' : 'application/json'
					},
					data: request
				})
				.success(function(data, status, headers, config) {
					if (data.user && data.csrfToken) {
						user = data.user;

						/** FOR NOW, ALL USERS ARE SUPERUSERS **/
						user.roles = [ 'Admin' ];
						/** REMOVE FOR ROLE-BASED AUTH **/

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
			});

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

		hasUser : function() {
			return angular.isDefined(user);
		},
		
		getUser : function() {
			return user;
		},

		hasRole : function(role) {
			if (!authenticated || !user.roles) return false;

			return user.roles.indexOf(role) != -1;
		},

		hasAnyRole : function(roles) {
			if (!authenticated || !user.roles) return false;

	        for (var i = 0; i < roles.length; i++) {
	          if (this.hasRole(roles[i])) return true;
	        }

	        return false;
		},

		isAuthenticated : function() {
			return authenticated;
		}
	};
});