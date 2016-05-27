angular.module('partnr.users.assets').controller('ChatController', function($scope, $log, users, principal, conversations, $filter, $interval, $rootScope, $anchorScroll, $location,$element) {
	$scope.openConversation = {'messages':[]};
	$scope.messageLength = 1000;
	$scope.currentUserId = principal.getUser().id;
	$scope.step = 1;
	$scope.isChatActive = false;
	$scope.nextButtonTitle = "Start new Conversation";
	$scope.title = "Your Conversations";
	$scope.lessThanOneSelected = true;
	$scope.isChatWindowOpen = false;
	var selectedUserIds = [];
	var pollAllConversationsPromise;
	var pollOpenConversationPromise;
	var todayDate = new Date();
	var scrollBar = angular.element(document.querySelector('#active-chat'));
	$log.debug(scrollBar);

	//Filters

	$scope.isNotUserFilter = function isUserFilter (user) {
		return (user.id !== $scope.currentUserId);
	};

	$scope.isAtLeastTwoAndNotCurrentUserFilter = function isAtLeastTwoAndNotCurrentUserFilter (element) {	
		return !(element.users.length < 2 && !$scope.isNotUserFilter(element.users[0]));
	};

	$scope.returnDateFilter = function returnDateFilter (date){
		var messageDate = new Date(date);
		if (todayDate.setHours(0,0,0,0) == messageDate.setHours(0,0,0,0)) {
			return 'shortTime';
		} else {
			return 'short';
		}
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
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
			$scope.openConversation.namelist = conversation.namelist;
			$scope.openConversation.non_displayable_name_amount = conversation.non_displayable_name_amount;
			goToLatestMessage($scope.openConversation.messages[$scope.openConversation.messages.length-1]);
			$log.debug('[CHAT] open Conversation: ', $scope.openConversation);
			conversations.changeIsRead(conversation.id, true).then(function(result){
				conversation.is_read = true;
			});
			$scope.isChatActive = true;
		});
		pollOpenConversationPromise = $interval(pollOpenConversation,$rootScope.pollDuration,0,true, conversation);
	};

	$scope.deactivateChat = function deactivateChat (conversation) {
		$scope.isChatActive = false;
		$scope.openConversation = {};
		$interval.cancel(pollOpenConversationPromise);
	};

	function isAtBottomOfScrollbar () {
		var heightOfScrollbar = scrollBar[0].scrollHeight - scrollBar.height();
		var scrollBarPosition = scrollBar.scrollTop();
		return (heightOfScrollbar === scrollBarPosition);
	}

	
	//New Chat

	$scope.goStepForward = function goStepForward(){
		$scope.step = $scope.step + 1;
		if ($scope.step === 2) {
			$scope.title = "Select Chat Participants";
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

	$scope.goStepBack = function goStepBack(){
		$scope.step = $scope.step - 1;
		if ($scope.step === 1) {
			$scope.newMessage = "";
			$scope.nextButtonTitle = "Start new Conversation";
		}
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
			$scope.nextButtonTitle = "Start new Conversation";
			$log.debug('[CHAT] newly created conversation', result.data);
			$scope.activateChat(result.data);
		});

	}

	//scrolling

	function goToLatestMessage (message) {
		$log.debug('[CHAT] element', scrollBar.prop('scrollHeight'));
		scrollBar.scrollTop = scrollBar.scrollHeight;
		
		 // var newHash = 'message' + message.id;
		 // var oldHash = $location.hash();
		 // $log.debug('[CHAT] Jumping!', newHash, oldHash);
		 // $location.hash(newHash);
		 // $anchorScroll();
	}

	$scope.logPosition =  function () {
		$log.debug('[CHAT] scrollBarElement', $scope.scrollBarPosition);
		$log.debug('[CHAT] scrollBarPosition', $scope.scrollBarPosition.scrollTop());
		$log.debug('[CHAT] height', $scope.scrollBarPosition.height());
		$log.debug('[CHAT] height', $scope.scrollBarPosition[0].scrollHeight);
		$log.debug('[CHAT] true height', $scope.scrollBarPosition[0].scrollHeight - $scope.scrollBarPosition.height());
	};

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
				$log.debug(result.data);
				$scope.newMessage = "";
				$scope.openConversation.messages.push(result.data);
				$scope.isMessageSubmitting = false;
				if (isAtBottomOfScrollbarinitializeScrollbar()){
					goToLatestMessage(result.data);
				}
			});
		}
	};
});