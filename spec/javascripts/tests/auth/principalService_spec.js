describe('principal', function() {
	beforeEach(module('partnr'));

	var principal, $httpBackend, authRequestHandler;

	beforeEach(inject(function(_principal_, _$rootScope_, _$httpBackend_) {
		principal = _principal_;
		$rootScope = _$rootScope_;
		$httpBackend = _$httpBackend_;

		authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
			.respond({
				"csrfToken" : "54239" 
			});
		authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
			.respond({
				"user" : { "first_name" : "Tyler", "last_name" : "Stone" },
				"csrfToken" : "4321"
			});
	}));

	describe('getHeaders', function() {
		it('will have a csrf token', function() {
			var headers = principal.getHeaders();
			expect(headers['X-CSRF-TOKEN']).to.be.defined;
		});

		it('will always have a csrf token', function() {
			var headers = principal.getHeaders();
			//recall headers from variable now that csrf request processed
			headers = principal.getHeaders();

			expect(headers['X-CSRF-TOKEN']).to.be.defined;
		});
	});

	describe('login', function() {
		it('will not authenticate invalid user', function() {
			authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
				.respond({
					"error" : "401" 
				});

			principal.login('dummyUser', 'dummyPassword').then(function() {
				expect(principal.isAuthenticated()).to.be.equal(false);
			});
		});

		it('will authenticate a valid user', function() {
			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
				.respond({
					"user" : { "first_name" : "Tyler", "last_name" : "Stone" },
					"csrfToken" : "5432" 
				});

				expect(principal.isAuthenticated()).to.be.equal(true);
			});
		});
	});

	describe('logout', function() {
		it('will successfully log out a user', function() {
			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				principal.logout().then(function() {
					authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_out')
						.respond({
							"success" : "204"
						});

					expect(principal.isAuthenticated()).to.be.equal(false);
				});
			});
		});
	});

	describe('hasRole', function() {
		//roles are pretty basic right now, everybody only has admin

		it('will return true when passed a role that a user has', function() {

			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				expect(principal.hasRole('Admin')).to.be.equal(true);
			});
		});

		it('will return false when an invalid role is passed', function() {
			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				expect(principal.hasRole('Dog')).to.be.equal(false);
			});
		});
	});

	describe('hasAnyRole', function() {
		it('will return true if a user has any of the passed roles', function() {
			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				expect(principal.hasAnyRole(['Admin', 'Dog'])).to.be.equal(true);
			});
		});

		it('will return false if a user does not have any of the passed roles', function() {
			principal.login('tylerstonephoto@gmail.com', 'password').then(function() {
				expect(principal.hasAnyRole(['Cat', 'Dog'])).to.be.equal(false);
			});
		});
	});

});