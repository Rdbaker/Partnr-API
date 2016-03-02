angular.module('partnr.users.assets').controller('ProjectWrapperController', function($scope, $state, $stateParams, $log, $q, principal, projects) {
	$scope.loadComplete = false;
	$scope.isMember = false;
	$scope.isOwner = false;
	$scope.canApply = false;
	$scope.projectId = $stateParams.project_id;
	$scope.project = null;

	console.log($stateParams);
	
	$scope.getProject = function(project) {
		return $scope.project;
	};

	$scope.getIsMember = function() {
		return $scope.isMember;
	};

	$scope.getIsOwner = function() {
		return $scope.isOwner;
	};

	$scope.getCanApply = function() {
		return $scope.canApply;
	};

	$scope.initialize = function() {
		var deferred = $q.defer();

		projects.get($stateParams.project_id).then(function(result) {
			$log.debug(result.data);
			$scope.project = result.data;
			if (result.data.owner.id === principal.getUser().id) {
				$scope.isOwner = true;
				$scope.isMember = true;
				$scope.canApply = false;
			}

			for (var i = 0; i < result.data.roles.length; i++) {
				if (result.data.roles[i].user != null) {
					if (result.data.roles[i].user.id === principal.getUser().id) {
						$scope.canApply = false;
						$scope.isMember = true;
						break;
					}
				}
			}

			$scope.loadComplete = true;
			deferred.resolve({ 
				project: $scope.project, 
				isOwner: $scope.isOwner,
				isMember: $scope.isMember, 
				canApply: $scope.canApply
			});
		});

		return deferred.promise;
	};	

	$scope.getProjectWrapperInfo = function() {
		var deferred = $q.defer();
		if ($scope.project !== null) {
			deferred.resolve({
				project: $scope.project, 
				isOwner: $scope.isOwner,
				isMember: $scope.isMember, 
				canApply: $scope.canApply
			});
		} else {
			$scope.initialize().then(function(result) {
				deferred.resolve(result);
			});
		}
		return deferred.promise;
	};

	$scope.initialize();
});