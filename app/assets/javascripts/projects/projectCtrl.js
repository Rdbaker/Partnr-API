angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects,
	applications, comments, principal, toaster) {
	$scope.project = {};
	$scope.newComment = {
		content: "",
		project: null
	};
	$scope.isCommentSubmitting = false;
	$scope.canApply = false;
	$scope.isOwner = false;
	$scope.isMember = false;
	$scope.canPost = false;
	$scope.loadComplete = false;
	$scope.user = principal.getUser();
	var loadSteps = 1;
	var loadStepsAchieved = 0;

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};

	var hasRole = function(project, userId) {
		var hasRole = false;
		for (var i = 0; i < project.roles.length; i++) {
			hasRole |= (project.roles[i].user && project.roles[i].user.id === userId);
		};
		return hasRole;
	};

	$scope.doApply = function(role) {
		applications.create({ role : role }).then(function(result) {
			toaster.success('Request sent!');
      mixpanel.track($rootScope.env + ':project.application.create');
		});
		$scope.canApply = false;
	};

	$scope.getStatus = function() {
		var result = 'Not Started';
		switch($scope.project.status) {
			case 'not_started':
				result = "Not Started";
				break;
			case 'in_progress':
				result = "In Progress";
				break;
			case "complete":
				result = "Completed";
				break;
		}
		return result;
	};

	$scope.addComment = function() {
		$scope.isCommentSubmitting = true;
		$scope.newComment.project = $scope.project.id;
		if (comments.isValid($scope.newComment)) {
			comments.create($scope.newComment).then(function(result) {
				$log.debug(result.data);
				$scope.newComment.content = "";
				$scope.project.comments.push(result.data);
				$scope.isCommentSubmitting = false;
        mixpanel.track($rootScope.env + ':project.comment.create');
			});
		} else {
			$scope.isCommentSubmitting = false;
		}
	};

	$scope.deleteComment = function(comment) {
		comments.delete(comment.id).then(function(result) {
			$log.debug(result);
			var commentIndex = $scope.project.comments.indexOf(comment);
			$scope.project.comments.splice(commentIndex, 1);
      mixpanel.track($rootScope.env + ':project.comment.delete');
		});
	};

	$scope.$parent.getProjectWrapperInfo().then(function(result) {
		$log.debug(result);
		$scope.project = result.project;
		$scope.isOwner = result.isOwner;
		$scope.isMember = result.isMember;
		$scope.canPost = ($scope.user ? true : false);

		if ($scope.user) {
			$log.debug('got user');
			applications.list({'project' : $stateParams.project_id, 'user' : $scope.user.id}).then(function(result) {
				if (result.data.length > 0 || hasRole($scope.project, $scope.user.id)) {
					$scope.canApply = false;
				} else {
					$scope.canApply = true;
				}
			});
		} else {
			$scope.canApply = false;
		}

		doLoadStep();
	});
});
