angular.module('partnr.auth').factory('principal', function($rootScope, $http, $log, $q, toaster) {
	var identityPrechecked = false;

	var user          = undefined;
	var authenticated = false;
	var csrfToken     = undefined;

	function fetchCsrf() {
		/* Gets the csrf token from the user */
		var promise = $http.get('/api/users/sign_in')
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
		var csrf = undefined;

		if (csrfToken) {
			csrf = csrfToken;
		} else {
			fetchCsrf().then(function() {
				csrf = csrfToken;
			});
		}
		$log.debug("CSRF requested:");
		$log.debug(csrf);
		return csrf;
	}

	function setCsrf(csrf) {
		csrfToken = csrf;
	}

	function getHeaders() {
		return {
			'X-CSRF-Token' : getCsrf(),
			'Content-Type' : 'application/json'
		};
	}

	function authenticate(dataUser) {
		/* Set all user data */
		user = dataUser;

		/** FOR NOW, ALL USERS ARE SUPERUSERS **/
		user.roles = [ 'Admin' ];
		/** REMOVE FOR ROLE-BASED AUTH **/

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
			$log.debug('[AUTH] Identity Pre-checked: ' + identityPrechecked);
			var deferred = $q.defer();
			if (!user && !identityPrechecked || force) {
				$log.debug('[AUTH] Checking if user session exists');
				$http({
					method: 'GET',
					url: $rootScope.apiRoute + 'users/me'
				}).success(function(data, status, headers, config) {
					if (data.email) {
						$log.debug('[AUTH] Cookie valid, storing user data');
						getCsrf();
						authenticate(data);
						identityPrechecked = true;
						deferred.resolve(user);
					} else {
						$log.debug('[AUTH] No preset user');
						deferred.resolve();
					}
				})
				.error(function(data, status, headers, config) {
					$log.error('[AUTH] Request to server failed');
					deferred.resolve();
				})
			} else {
				deferred.resolve();
			}

			identityPrechecked = true;
			return deferred.promise;
		},

		login : function(email, password) {
			/* Send login request to server */
			$log.debug('[AUTH] About to log in...');
			var deferred = $q.defer();

			fetchCsrf().then(function() {
				var request = {
					'user' : {
						'email' : email,
						'password' : password
					}
				};

				$log.debug(getHeaders());
				$log.debug(request);

				return $http({
					method: 'POST',
					url: '/api/users/sign_in',
					headers: {
						'X-CSRF-Token' : getCsrf(),
						'Content-Type' : 'application/json'
					},
					data: request
				})
				.success(function(data, status, headers, config) {
					if (data.user) {
						fetchCsrf();
						authenticate(data.user);
						deferred.resolve(true);
					} else {
						$log.error('[AUTH] Log in failure')
						toaster.error("Invalid email/password");
						deferred.resolve(false);
					}
				})
				.error(function(data, status, headers, config) {
		            $log.error('[AUTH] Log in failure')
		            toaster.error("Invalid email/password");
		            deferred.resolve(false);
				});
			});

			return deferred.promise;
		},

		logout : function() {
			/* Send logout request to server */
			$log.debug('[AUTH] Logging out...');
			$log.debug(getHeaders());
			return $http({
				method: 'DELETE',
				headers: {
					'X-CSRF-Token' : getCsrf(),
					'Content-Type' : 'application/json'
				},
				url: '/api/users/sign_out'
			}).success(function(data, status, headers, config) {
				user = {};
				authenticated = false;
				identityPrechecked = false;
				csrfToken = undefined;
				$log.debug('[AUTH] User signed out');
			}).error(function(data, status, headers, config) {
				$log.error('[AUTH] Log out error');
				toaster.error("Could not connect to server");
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
