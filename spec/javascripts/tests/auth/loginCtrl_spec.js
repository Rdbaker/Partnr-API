describe('loginCtrl', function() {
	beforeEach(module('partnr'));

	var $state, $controller;

	beforeEach(inject(function(_$state_, _$controller_) {
		$state = _$state_;
		$controller = _$controller_;
	}));

	describe('doLogin', function() {
		it('will go to the home page when a user logs in', function() {
			var $scope = {
				email : 'tylerstonephoto@gmail.com',
				password : 'password'
			};
			var controller = $controller('LoginController', { $scope: $scope });
			
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
			
			$scope.doLogin().then(function() {
				expect($state.current.name).to.be.equal('login');
			});
		});
	});
});
