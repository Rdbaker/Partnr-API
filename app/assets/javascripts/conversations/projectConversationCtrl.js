angular.module('partnr.messaging').controller('ProjectConversationController', function($scope, $stateParams, $log, toaster, conversations) {
	$scope.conversation = {};
	$scope.isMessageSubmitting = false;
	$scope.newMessage = "";
	$scope.loadComplete = false;

	conversations.getByProject($stateParams.project_id).then(function(result) {
		$log.debug(result.data);
		$scope.loadComplete = true;
		if (result.data.id) {
			$scope.conversation = result.data;
		} else {
			toaster.error("Oops... Project chat wasn't initialized properly...");
		}
	});

	$scope.sendMessage = function() {
		$scope.isMessageSubmitting = true;

		conversations.addMessage($scope.conversation.id, $scope.newMessage).then(function(result) {
			$log.debug(result.data);
			$scope.newMessage = "";
			$scope.conversation.messages.push(result.data);
			$scope.isMessageSubmitting = false;
		});
	};
});