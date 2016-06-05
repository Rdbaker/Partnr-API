angular.module('partnr.users.assets').controller('ProfileWrapperController', function($scope, $rootScope, $state, $q, $stateParams, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;
	$scope.userCategories = $rootScope.categories;

	$scope.initialize = function() {
		var deferred = $q.defer();
		users.get($stateParams.id).then(function(result) {
			$log.debug(result.data);
			$scope.user = result.data;
			$scope.loadComplete = true;

			$log.debug(result.data);
			deferred.resolve($scope.user);
		});

		return deferred.promise;
	};

	$scope.getProfileWrapperInfo = function() {
		var deferred = $q.defer();

		if ($scope.user !== null) {
			deferred.resolve($scope.user);
		} else {
			$scope.initialize().then(function(result) {
				deferred.resolve(result);
			});
		}
		return deferred.promise;
	};

	$scope.initialize();
});