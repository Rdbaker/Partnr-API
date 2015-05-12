angular.module('partnr.messaging').controller('MessageController', function($scope, messages) {
	$scope.messages = messages.get();
});