angular.module('partnr.users.assets').controller('ProjectController', function($scope, $state, $stateParams, $log, $q, projects, 
	applications, comments, principal, toaster) {
	
	$scope.project = {};
	$scope.newComment = {
		content: "",
		project: null
	};
	$scope.isCommentSubmitting = false;
	$scope.canApply = true;
	$scope.isOwner = false;
	$scope.isMember = false;
	$scope.loadComplete = false;
	$scope.user = principal.getUser();
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	$scope.doApply = function(role) {
		applications.create({ role : role }).then(function(result) {
			toaster.success('Request sent!');
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
		});
	};
	
	projects.get($stateParams.id).then(function(result) {
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

		doLoadStep();
	});

	if ($scope.user) {		
		applications.list({'project' : $stateParams.id, 'user' : $scope.user.id}).then(function(result) {
			$log.debug(result.data);
			if (result.data.length > 0) {
				$scope.canApply = false;
			}

			doLoadStep();
		});
	}

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};
});