angular.module('partnr.auth').factory('principal', function($rootScope, $http, $log, $q) {
	var identityPrechecked = false;

	var user          = undefined;
	var authenticated = false;
	var csrfToken     = undefined;

	function fetchCsrf() {
		/* Gets the csrf token from the user */
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
		/* returns a csrfToken by returning the value or sending a
		   request to the server */
		var deferred = $q.defer();
		if (csrfToken) {
			deferred.resolve(csrfToken);
		} else {
			fetchCsrf().then(function() {
				deferred.resolve(csrfToken);
			});
		}
		$log.debug(csrfToken);
		return deferred.promise;
	}

	function getHeaders() {
		return getCsrf().then(function(csrf) {
			return {
				'X-CSRF-Token' : csrf,
				'Content-Type' : 'application/json'
			};
		});
	}

	function authenticate(dataUser, dataCsrfToken) {
		/* Set all user data */
		user = dataUser;

		/** FOR NOW, ALL USERS ARE SUPERUSERS **/
		user.roles = [ 'Admin' ];
		/** REMOVE FOR ROLE-BASED AUTH **/

		csrfToken = dataCsrfToken;
		authenticated = true;
		$log.debug('[AUTH] User authenticated');
		$log.debug(user);
	}

	return {
		getCsrf : getCsrf,
		getHeaders : getHeaders,
		identity : function(force) {
			/* This function will check for an existing session and
			   if so, a request will check the validity of that session
			   and store the resulting user value if it's still valid
			*/
			var deferred = $q.defer();
			if (!user && !identityPrechecked || force) {
				$log.debug('[AUTH] Checking if user session exists');
				$http({
					method: 'GET',
					url: $rootScope.apiRoute + 'api/users/sign_in'
				}).success(function(data, status, headers, config) {
					if (data.user && data.csrfToken) {
						$log.debug('[AUTH] Cookie valid, storing user data');
						authenticate(data.user, data.csrfToken);
						identityPrechecked = true;
						deferred.resolve(user);
					} else {
						$log.debug('[AUTH] No preset user');
						identityPrechecked = true;
						deferred.resolve();
					}
				})
				.error(function(data, status, headers, config) {
					$log.error('[AUTH] Request to server failed');
					identityPrechecked = true;
					deferred.resolve();
				})
			} else {
				deferred.resolve();
			}

			return deferred.promise;
		},

		login : function(email, password) {
			/* Send login request to server */
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
					headers: getHeaders(),
					data: request
				})
				.success(function(data, status, headers, config) {
					if (data.user && data.csrfToken) {
						authenticate(data.user, data.csrfToken);
					} else {
						$log.error('[AUTH] Log in failure')
					}
				})
				.error(function(data, status, headers, config) {
					$log.error('[AUTH] Log in failure');
				});
			});

			return promise;
		},

		logout : function() {
			/* Send logout request to server */
			$log.debug('[AUTH] Logging out...');
			return $http({
				method: 'DELETE',
				headers: {
					'X-CSRF-Token' : getHeaders(),
					'Content-Type' : 'application/json'
				},
				url: $rootScope.apiRoute + 'api/users/sign_out'
			}).success(function(data, status, headers, config) {
				user = {};
				authenticated = false;
				$log.debug('[AUTH] User signed out');
			}).error(function(data, status, headers, config) {
				$log.error('[AUTH] Log out error');
			});
		},

		hasUser : function() {
			return angular.isDefined(user);
		},
		
		getUser : function() {
			return user;
		},

		hasRole : function(role) {
			/* checks to see if a user has a specified role */
			if (!authenticated || !user.roles) return false;

			return user.roles.indexOf(role) != -1;
		},

		hasAnyRole : function(roles) {
			/* checks to see if a user has any of the specified roles */
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