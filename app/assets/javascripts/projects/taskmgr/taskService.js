angular.module('partnr.users.assets').factory('tasks', function($rootScope, $http, $log, principal) {
	return {
		get : function(id) {
			$log.debug('[TASK] Sending get request for task ' + id);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'tasks/' + id,
				headers: principal.getHeaders()
			});
		},

		listByProject : function(id) {
			$log.debug('[TASK] Getting list by project');
			$log.debug(id);

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'tasks',
				headers: principal.getHeaders(),
				params: { project: id }
			});
		},

		list : function() {
			$log.debug('[TASK] Sending list request');

			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'tasks',
				headers: principal.getHeaders()
			});
		},

		create : function(task) {
			$log.debug("[TASK] Sending create request");

			task.owner = principal.getUser().id;
			$log.debug(task);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'tasks',
				headers: principal.getHeaders(),
				data: task
			});
		},

		update : function(task) {
			$log.debug("[TASK] Sending update request");
			$log.debug(task);
			var taskToUpdate = angular.copy(task);

			if (taskToUpdate.skills.length === 0) delete taskToUpdate.skills;
			if (taskToUpdate.categories.length === 0) delete taskToUpdate.categories;

			// if (taskToUpdate.milestone == null) {
			// 	delete taskToUpdate.milestone;
			// } else 

			if (taskToUpdate.milestone.id) {
				taskToUpdate.milestone = taskToUpdate.milestone.id;
			}

			// if (taskToUpdate.user === null) {
			// 	delete taskToUpdate.user;
			// } else 

			if (taskToUpdate.user.id) {
				taskToUpdate.user = taskToUpdate.user.id;
			}

			return $http({
				method: 'PUT',
				url: $rootScope.apiRoute + 'tasks/' + taskToUpdate.id,
				headers: principal.getHeaders(),
				data: taskToUpdate
			});
		},

		delete : function(id) {
			$log.debug("[TASK] Sending delete request");

			return $http({
				method: 'DELETE',
				url: $rootScope.apiRoute + 'tasks/' + id,
				headers: principal.getHeaders()
			});
		}
	};
});
