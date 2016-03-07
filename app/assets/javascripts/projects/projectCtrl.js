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
	$log.debug('user');
	console.log($scope.user);
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	var doLoadStep = function() {
		loadStepsAchieved += 1;
		if (loadStepsAchieved === loadSteps) {
			$scope.loadComplete = true;
		}
	};

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
	
	$scope.$parent.getProjectWrapperInfo().then(function(result) {
		$log.debug(result);
		$scope.project = result.project;
		$scope.isOwner = result.isOwner;
		$scope.isMember = result.isMember;
		$scope.canPost = ($scope.user ? true : false);
		
		doLoadStep();
	});

	if ($scope.user) {
		$log.debug('got user');
		applications.list({'project' : $stateParams.id, 'user' : $scope.user.id}).then(function(result) {
			$log.debug(result.data);
			if (result.data.length > 0) {
				$scope.canApply = false;
			}

			doLoadStep();
		});
	} else {
		$scope.canApply = false;
		doLoadStep();
	}
});