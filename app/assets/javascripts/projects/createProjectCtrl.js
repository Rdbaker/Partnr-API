angular.module('partnr.users.assets').controller('CreateProjectController', function($scope, $state, $log, $q, projects, roles, principal, toaster) {
	$scope.step = 1;
	$scope.project = {
		title: '',
		description: ''
	};

	$scope.ownerRole = { title: '' };
	$scope.roles = [{ title: '' }];
	$scope.loading = false;

	$scope.validateProject = function() {
		return ($scope.project.title.length > 0);
	}

	$scope.validateOwnerRole = function() {
		return $scope.validateRole($scope.ownerRole);
	}

	$scope.validateRole = function(role) {
		return (role.title.length > 0);
	}

	$scope.doProjectCreate = function() {
		if ($scope.validateProject()) {
			$scope.loading = true;
			projects.create($scope.project).then(function(result) {
				$scope.loading = false;
				$log.debug(result.data);
				if (result.data.id) {
					$scope.step += 1;
					$scope.project = result.data;
				} else {
					$log.debug("[PROJECT] Create error");
					if (result.data.error) { $log.debug(result.data.error); }
					toaster.error("Project could not be created. Please try again.");
				}
			});
		} else {
			toaster.error("Please enter a title.");
		}
	}

	$scope.processOwnerRole = function() {
		if ($scope.validateOwnerRole()) {
			$scope.loading = true;
			$scope.ownerRole.project = $scope.project.id;
			roles.create($scope.ownerRole).then(function(result) {
				$scope.loading = false;
				if (result.data.id) {
					$scope.ownerRole = result.data;
					$scope.ownerRole.user = principal.getUser().id;
					roles.update($scope.ownerRole).success(function(result) {
						$scope.step += 1;
					});
				} else {
					$log.debug("[PROJECT ROLE] Create error");
					if (result.data.error) { $log.debug(result.data.error); }
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
				curRole.project = $scope.project.id;
				cleanedRoles.push(curRole);
			}	
		}

		for (var i = 0; i < cleanedRoles.length; i++) {
			$scope.loading = true;
			roles.create(cleanedRoles[i]).then(function(result) {
				rolesProcessed += 1;

				if (rolesProcessed === cleanedRoles.length) {
					$scope.loading = false;
					$state.go('project_list');
					toaster.success('Project created!');
				}
			});
		}
	}
});