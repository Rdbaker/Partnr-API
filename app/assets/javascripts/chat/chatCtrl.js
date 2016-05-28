angular.module('partnr.messaging').controller('ChatController', function($scope, $log, users, principal, conversations, $filter, $interval, $rootScope, $anchorScroll, $location,$element) {
	$scope.openConversation = {'messages':[]};
	$scope.messageLength = 1000;
	$scope.currentUserId = principal.getUser().id;
	$scope.step = 1;
	$scope.isChatActive = false;
	$scope.title = "Your Conversations";
	$scope.nextButtonTitle = "Start new Chat";
	$scope.lessThanOneSelected = true;
	$scope.isChatWindowOpen = false;
	$scope.users = [];
	var selectedUserIds = [];
	var pollAllConversationsPromise;
	var pollOpenConversationPromise;

	//Filters

	$scope.isNotUserFilter = function isUserFilter (user) {
		return (user.id !== $scope.currentUserId);
	};

	$scope.isAtLeastTwoAndNotCurrentUserFilter = function isAtLeastTwoAndNotCurrentUserFilter (element) {	
		return !(element.users.length < 2 && !$scope.isNotUserFilter(element.users[0]));
	};

	//Polling

	function pollAllConversations (callback) {
		conversations.list().then(function(result) {
			$scope.conversations = $filter('filter')(result.data, $scope.isAtLeastTwoAndNotCurrentUserFilter);
			for (i = 0; i < $scope.conversations.length; i++) {
				processUserNames($scope.conversations[i]);
				$scope.conversations[i].date = new Date($scope.conversations[i].last_updated); 
			}
			$log.debug('[CHAT] pollAllConversations ', $scope.conversations);
		});
	}
	pollAllConversations();
	pollAllConversationsPromise = $interval(pollAllConversations,$rootScope.pollDuration);

	function processUserNames (conversation) {
		var displayableUsers = 1;
		conversation.users = $filter('filter')(conversation.users, $scope.isNotUserFilter);
		var usernameString = conversation.users[0].name;
		var searchableString = conversation.users[0].name;
		var concatString = ", ";
		for (var i = 1; i < conversation.users.length; i++) {
			if (conversation.users[i].name.length+concatString.length+usernameString.length < 27) {
				usernameString = conversation.users[i].name + concatString + usernameString;
				displayableUsers ++;
			}
			searchableString = searchableString + " " + conversation.users[i].name;

		}
		conversation.namelist = usernameString;
		conversation.allconversationparticipantsstring = searchableString;
		conversation.non_displayable_name_amount = conversation.users.length - displayableUsers;
	}


	function pollOpenConversation (conversation) {
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
			$scope.openConversation.namelist = conversation.namelist;
			$scope.openConversation.non_displayable_name_amount = conversation.non_displayable_name_amount;
			if (!$scope.openConversation.is_read) {
				conversations.changeIsRead(conversation.id, true).then(function(result){
					conversation.is_read = true;
				});
			}
		});
	}

	//Activation/Deactivation of Chat

	$scope.activateChat = function activateChat (conversation) {
		$scope.isChatActive = true;
		$scope.title = conversation.namelist;
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
			$scope.openConversation.namelist = conversation.namelist;
			$scope.openConversation.non_displayable_name_amount = conversation.non_displayable_name_amount;
			$scope.title = $scope.openConversation.namelist;
			$log.debug('[CHAT] open Conversation: ', $scope.openConversation);
			conversations.changeIsRead(conversation.id, true).then(function(result){
				conversation.is_read = true;
			});
		});
		$interval.cancel(pollAllConversationsPromise);
		pollOpenConversationPromise = $interval(pollOpenConversation,$rootScope.pollDuration,0,true, conversation);
	};

	//New Chat

	$scope.goStepForward = function goStepForward($event){
		$event.stopPropagation();
		$scope.step = $scope.step + 1;
		if ($scope.step === 2) {
			$scope.title = "Select Chat Participants";
			$scope.newMessage = "";
			users.getAllUsers().then(function(result) {
				$scope.users = result.data;
			});
			$scope.nextButtonTitle = "Finish";
		}
		if ($scope.step === 3) {
			createConversation();
		}
	};

	$scope.goStepBack = function goStepBack($event){
		$event.stopPropagation();
		if ($scope.isChatActive) {
			$scope.isChatActive = false;
			$scope.openConversation = {};
			$interval.cancel(pollOpenConversationPromise);
			pollAllConversations();
			pollAllConversationsPromise = $interval(pollAllConversations,$rootScope.pollDuration);
		} else {
			$scope.step = $scope.step - 1;
			if ($scope.step === 1) {
				$scope.newMessage = "";
				$scope.nextButtonTitle = "Start new Chat";
				selectedUserIds = [];
				$scope.users = [];
			}
		}
		$scope.title = "Your Conversations";
	};

	$scope.isNextDisabled = function isNextDisabled() {
		if ($scope.step === 2 && ($scope.newMessage.length < 1 || $scope.lessThanOneSelected)) {
			return true;
		} else {
			return false;
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
		(selectedUserIds.length < 1) ? $scope.lessThanOneSelected = true : $scope.lessThanOneSelected = false;
		$log.debug("[CHAT] selectedUserIds: ", selectedUserIds);
	};

	function createConversation() {
		var newConversation = {
			users: selectedUserIds,
			message: $scope.newMessage
		};
		conversations.create(newConversation).then(function(result) {
			$scope.step = 1;
			$scope.newMessage = "";
			$scope.nextButtonTitle = "Start new Chat";
			$log.debug('[CHAT] newly created conversation', result.data);
			$scope.activateChat(result.data);
		});

	}

	//Send Message

	$scope.checkLength = function checkLength (maxLength) {
		if ($scope.newMessage.length > maxLength) {
			$scope.newMessage = $scope.newMessage.substring(0, maxLength);
		}
	};

	$scope.sendMessage = function sendMessage(event) {
		if (event.keyCode === 13) {
			$scope.isMessageSubmitting = true;
			conversations.addMessage($scope.openConversation.id, $scope.newMessage).then(function(result) {
				$scope.newMessage = "";
				$scope.openConversation.messages.push(result.data);
				$scope.isMessageSubmitting = false;
			});
		}
	};
});