angular.module('partnr.users.assets').controller('ProfileWrapperController', function($scope, $rootScope, $state, $q, $stateParams, $filter, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;

	$scope.initialize = function() {
		var deferred = $q.defer();
		users.get($stateParams.id).then(function(result) {
			$scope.user = result.data;
			$scope.user.resolvedCategories = [];

			for (var cat in $scope.user.skillscore.categories) {
				var category = $filter('filter')($rootScope.categories, { title: cat });

				if (category) {
					var userCategory = angular.copy(category[0]);
					userCategory.skillscore = $scope.user.skillscore.categories[cat];
					$scope.user.resolvedCategories.push(userCategory);
				} else {
					$log.error("Error: Category resolution returned null");
				}
			}

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