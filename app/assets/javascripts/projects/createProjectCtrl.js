angular.module('partnr.users.assets').controller('CreateProjectController', function($scope, $state, $log, $q, projects, projectRoles, principal, toaster) {
	$scope.step = 1;
	$scope.project = {
		name: '',
		description: ''
	};

	$scope.ownerRole = { title: '' };
	$scope.roles = [{ title: '' }];

	$scope.validateProject = function() {
		return ($scope.project.name.length > 0);
	}

	$scope.validateOwnerRole = function() {
		return $scope.validateRole($scope.ownerRole);
	}

	$scope.validateRole = function(role) {
		return (role.title.length > 0);
	}

	$scope.doProjectCreate = function() {
		if ($scope.validateProject()) {
			projects.create($scope.project).success(function(data, status, headers, config) {
				if (data.id) {
					$scope.step += 1;
					$scope.project = data;
				} else {
					$log.debug("[PROJECT] Create error");
					if (data.error) { $log.debug(data.error); }
					toaster.error("Project could not be created. Please try again.");
				}
			});
		} else {
			toaster.error("Please enter a name.");
		}
	}

	$scope.processOwnerRole = function() {
		if ($scope.validateOwnerRole()) {
			$scope.ownerRole.project_id = $scope.project.id;
			projectRoles.create($scope.ownerRole).success(function(data, status, headers, config) {
				if (data.id) {
					$scope.ownerRole = data;
					$scope.ownerRole.user = principal.getUser().id;
					projectRoles.update($scope.ownerRole).success(function(data, status, headers, config) {
						$log.debug("[PROJECT ROLE] Created and Updated Role");
						$log.debug(data);
						$scope.step += 1;
					});
				} else {
					$log.debug("[PROJECT ROLE] Create error");
					if (data.error) { $log.debug(data.error); }
					toaster.error("Project role could not be created. Please try again.");
				}
			});
		} else {
			toaster.error("Please enter a title.");
		}
	}

	$scope.addRole = function() {
		$scope.roles.push({ title : '' });
	}

	$scope.processAdditionalRoles = function() {
		var cleanedRoles = [];
		var rolesProcessed = 0;

		for (var i = 0; i < $scope.roles.length; i++) {
			var curRole = $scope.roles[i];
			if ($scope.validateRole(curRole)) {
				curRole.project_id = $scope.project.id;
				cleanedRoles.push(curRole);
			}	
		}

		for (var i = 0; i < cleanedRoles.length; i++) {
			projectRoles.create(cleanedRoles[i]).success(function(data, status, headers, config) {
				rolesProcessed += 1;

				if (rolesProcessed === cleanedRoles.length) {
					$state.go('home');
				}
			});
		}
	}
});