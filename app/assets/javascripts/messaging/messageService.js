angular.module('partnr.messaging').factory('messages', function($rootScope, $http) {
	return {
		get : function() {
			return $http.get($rootScope.apiRoute + 'messages');
		}
	};
})