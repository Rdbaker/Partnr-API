angular.module('partnr.users.assets').controller('ProfileWrapperController', function($scope, $rootScope, $state, $q, $stateParams, $filter, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;

	$scope.initialize = function() {
		var deferred = $q.defer();
		users.get($stateParams.id).then(function(result) {
			$scope.user = result.data;
			$scope.loadComplete = true;

			$log.debug($scope.user);
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