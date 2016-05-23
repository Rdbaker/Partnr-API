angular.module('partnr.users.assets').controller('ChatController', function($scope, $log, users, principal, conversations, $filter, $interval, $rootScope) {
	$scope.openConversation = {};
	$scope.users = [];
	$scope.messageLength = 1000;
	$scope.currentUserId = principal.getUser().id;
	$scope.step = 1;
	$scope.isChatActive = false;
	$scope.nextButtonTitle = "Start new Conversation";
	var selectedUserIds = [];

	var poll = function poll (callback) {
		conversations.list().then(function(result) {
			$scope.conversations = $filter('filter')(result.data, $scope.isAtLeastTwoAndNotCurrentUserFilter);
			for (i = 0; i < $scope.conversations.length; i++) {
				processUserNames($scope.conversations[i]);
			}
		});
	};
	poll();
	$interval(poll,$rootScope.pollDuration);

	$scope.$on('$destroy', function() {
		$log.debug("Cancelling message update requests");
		$interval.cancel(poll);
	});

	function processUserNames (conversation) {
		var displayableUsers = 1;
		conversation.users = $filter('filter')(conversation.users, $scope.isNotUserFilter);
		var usernameString = conversation.users[0].name;
		var concatString = ", ";
		for (var i = 1; i < conversation.users.length; i++) {
			if (conversation.users[i].name.length+concatString.length+usernameString.length < 27) {
				usernameString = conversation.users[i].name + concatString + usernameString;
				displayableUsers ++;
			}
		}
		conversation.namelist = usernameString;
		conversation.non_displayable_name_amount = conversation.users.length - displayableUsers;
	}

	$scope.goStepForward = function goStepForward(){
		$scope.step = $scope.step + 1;
		if ($scope.step === 2) {
			$scope.newMessage = "";
			users.getAllUsers().then(function(result) {
				$scope.users = result.data;
				$log.debug('[CHAT] Users: ', $scope.users);
			});
			$scope.nextButtonTitle = "Finish";
		}
		if ($scope.step === 3) {
			createConversation();
		}
	};

	$scope.isNextDisabled = function isNextDisabled() {
		if ($scope.step === 2 && $scope.newMessage.length < 1 && selectedUserIds.length > 0) {
			return true;
		} else {
			return false;
		}
	};

	$scope.goStepBack = function goStepBack(){
		$scope.step = $scope.step - 1;
		if ($scope.step === 1) {
			$scope.newMessage = "";
			$scope.nextButtonTitle = "Start new Conversation";
		}
	};

	$scope.isNotUserFilter = function isUserFilter (user) {
		//$log.debug('[CHAT] UserId: ', user.id);
		//$log.debug('[CHAT] UserId: ', $scope.currentUserId);
		return (user.id !== $scope.currentUserId);
	};

	$scope.isAtLeastTwoAndNotCurrentUserFilter = function isAtLeastTwoAndNotCurrentUserFilter (element) {	
		return !(element.users.length < 2 && !$scope.isNotUserFilter(element.users[0]));
	};



	$scope.activateChat = function activateChat (conversation) {
		$scope.isChatActive = true;
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
			$scope.openConversation.namelist = conversation.namelist;
			$scope.openConversation.non_displayable_name_amount = conversation.non_displayable_name_amount;
			conversations.changeIsRead(conversation.id, true).then(function(result){
				conversation.is_read = true;
			});
		});
	};

	$scope.deactivateChat = function activateChat (conversation) {
		$scope.isChatActive = false;
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
		});
	};

	$scope.sendMessage= function(event){
		if (event.keyCode === 13) {
			$log.debug('[CHAT] This is the sent message: ', $scope.message);
			conversations.addMessage($scope.openConversation.id, $scope.message);
			$scope.message = "";
			conversations.get($scope.openConversation.id).then(function(result) {
				$scope.openConversation = result.data;
			});
		}
	};

	$scope.returnDateFilter = function returnDateFilter (date){
		var todayDate = new Date();
		var messageDate = new Date(date);
		if (todayDate.setHours(0,0,0,0) == messageDate.setHours(0,0,0,0)) {
			return 'shortTime';
		} else {
			return 'short';
		}
	};

	$scope.checkLength = function checkLength (maxLength) {
		if ($scope.newMessage.length > maxLength) {
			$scope.newMessage = $scope.newMessage.substring(0, maxLength);
		}
	};

	$scope.sendMessage = function sendMessage(event) {
		if (event.keyCode === 13) {
			$scope.isMessageSubmitting = true;
			conversations.addMessage($scope.openConversation.id, $scope.newMessage).then(function(result) {
				$log.debug(result.data);
				$scope.newMessage = "";
				$scope.openConversation.messages.push(result.data);
				$scope.isMessageSubmitting = false;
			});
		}
	};

	$scope.selectUser = function selectUser (user) {
		var index = selectedUserIds.indexOf(user.id);
		user.selected ? user.selected = false : user.selected = true;
		if (index > -1) {
			selectedUserIds.splice(index, 1);

		} else {
			selectedUserIds.push(user.id);
		}
		$log.debug("[CHAT] selectedUserIds: ", selectedUserIds);
	};

	function createConversation() {
		var newConversation = {
			users: selectedUserIds,
			message: $scope.newMessage
		};
		conversations.create(newConversation).then(function(result) {
			$scope.openConversation = result.data;
			$scope.step = 1;
			$scope.nextButtonTitle = "Start new Conversation";
			$scope.newMessage = "";
			//$scope.activateChat(result)
		});

	}
});