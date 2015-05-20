describe('loginCtrl', function() {
	beforeEach(module('partnr'));

	var $rootScope, $state, $controller, $httpBackend;

	beforeEach(inject(function(_$rootScope_, _$state_, _$controller_, _$httpBackend_) {
		$rootScope = _$rootScope_;
		$state = _$state_;
		$controller = _$controller_;
		$httpBackend = _$httpBackend_;
	}));

	describe('doLogin', function() {
		it('will go to the home page when a user logs in', function() {
			var $scope = {
				email : 'tylerstonephoto@gmail.com',
				password : 'password'
			};
			var controller = $controller('LoginController', { $scope: $scope });
			var authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
				.respond({ 
					"user" : { 
						"first_name" : "Tyler", 
						"last_name" : "Stone" 
					}, 
					"csrfToken" : "54239" 
				});

			$scope.doLogin().then(function() {
				expect($state.current.name).to.be.equal('home');
			});
		});

		it('will not go to the home page when a user does not get logged in', function() {
			var $scope = {
				email : 'dog',
				password : 'password'
			};
			var controller = $controller('LoginController', { $scope: $scope });
			var authRequestHandler = $httpBackend.when('POST', $rootScope.apiRoute + 'api/users/sign_in')
				.respond({ 
					"error": "401"
				});

			$scope.doLogin().then(function() {
				expect($state.current.name).to.be.equal('login');
			});
		});
	});
});
