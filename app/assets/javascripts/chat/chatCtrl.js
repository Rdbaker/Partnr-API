angular.module('partnr.users.assets').controller('ChatController', function($scope, $log, users, principal, conversations, $filter) {
	$scope.openConversation = {};
	$scope.users = [];
	$scope.messageLength = 1000;
	$scope.currentUserId = principal.getUser().id;
	$scope.step = 1;
	$scope.isChatActive = false;
	$scope.nextButtonTitle = "Start new Conversation";
	var selectedUserIds = [];
	var currentDate = Date.now;


	conversations.list().then(function(result) {
		$scope.conversations = result.data;
		$log.debug("[CHAT] conversations: ", $scope.conversations);
	});

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
	};

	$scope.notUserFilter = function notUserFilter (user) {
		return (user.id !== $scope.currentUserId);
	};

	$scope.isAtLeastTwoAndNotCurrentUserFilter = function isAtLeastTwoAndNotCurrentUserFilter (element) {
		return !(element.users.length < 2 && $scope.notUserFilter(element.users[0]));
	};

	

	$scope.activateChat = function activateChat (conversation) {
		$scope.isChatActive = true;
		conversations.get(conversation.id).then(function(result) {
			$scope.openConversation = result.data;
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
		var todayDate = $filter('date')(date, 'longDate');
		var messageDate = $filter('date')(date, 'longDate');
		if (todayDate === messageDate) {
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

	$scope.selectUser = function selectUser(user) {
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