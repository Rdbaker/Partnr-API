angular.module('partnr.messaging').factory('conversations', function($rootScope, $http, $log, principal) {
	return {
		list : function() {
			$log.debug('[CONVERSATION] Sending list request');

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'conversations',
				headers: principal.getHeaders()
			});
		},

		get : function(id) {
			$log.debug('[CONVERSATION] Sending get request for conversation ' + id);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'conversations/' + id,
				headers: principal.getHeaders()
			});
		},

		create : function(conversation) {
			$log.debug("[CONVERSATION] Sending create request");
			$log.debug(conversation);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'conversations',
				headers: principal.getHeaders(),
				data: conversation
			});
		},

		addMessage : function(id, message) {
			
		}
	};
});