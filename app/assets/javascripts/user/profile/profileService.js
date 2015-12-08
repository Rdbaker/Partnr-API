angular.module('partnr.users.assets').factory('profiles', function($rootScope, $http, $log, principal) {
	return {
		get : function(id) {
			$log.debug('[PROFILE] Sending get request for project ' + id);
			return $http({
				method: 'GET',
				url: $rootScope.apiRoute + 'projects/' + id,
				headers: principal.getHeaders()
			});
		},

		addLocation : function(location) {
			$log.debug("[PROFILE] Sending location create request");
			$log.debug(location);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'profiles/location',
				headers: principal.getHeaders(),
				data: { "geo_string" : location }
			});
		},

		addSchool : function(school) {
			$log.debug("[PROFILE] Sending school create request");
			$log.debug(school);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'profiles/school',
				headers: principal.getHeaders(),
				data: school
			});
		},

		addSkill : function(skill) {
			$log.debug("[PROFILE] Sending skill create request");
			$log.debug(skill);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'profiles/skill',
				headers: principal.getHeaders(),
				data: skill
			});
		},

		addPosition : function(position) {
			$log.debug("[PROFILE] Sending position create request");
			$log.debug(position);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'profiles/position',
				headers: principal.getHeaders(),
				data: position
			});
		},

		addInterest : function(interest) {
			$log.debug("[PROFILE] Sending interest create request");
			$log.debug(interest);

			return $http({
				method: 'POST',
				url: $rootScope.apiRoute + 'profiles/interests',
				headers: principal.getHeaders(),
				data: interest
			});
		},

		isValidLocation : function(location) {
			return (location.length > 0);
		},

		isValidSchool : function(school) {
			return (school.school_name.length > 0 && 
				school.grad_year.length > 0 && 
				school.grad_year.length <= 4);
		},

		isValidSkill : function(skill) {
			return (skill.title.length > 0);
		},

		isValidPosition : function(position) {
			return (position.title.length > 0 &&
				position.company.length > 0);
		},

		isValidInterest : function(interest) {
			return (interest.title.length > 0);
		}
	};
});