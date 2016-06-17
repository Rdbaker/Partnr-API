angular.module('partnr.users.assets').controller('ProfileSkillsController', function($scope, $rootScope, $state, $stateParams, $log, toaster, users) {
	$scope.loadComplete = false;
	$scope.user = null;
	$scope.categorySkillMap = [];
	$scope.totalScore = 0;

	$scope.$parent.getProfileWrapperInfo().then(function(result) {
		$scope.user = result;

		for (var i = 0; i < $scope.user.skillscore.scored.categories.length; i++) {
			$scope.totalScore += $scope.user.skillscore.scored.categories[i].score;
		}

		for (var i = 0; i < $scope.user.skillscore.scored.skills.length; i++) {
			var currentSkill = $scope.user.skillscore.scored.skills[i].skill;
			if ($scope.categorySkillMap[currentSkill.category.title]) {
				$scope.categorySkillMap[currentSkill.category.title].push(currentSkill);
			} else {
				$scope.categorySkillMap[currentSkill.category.title] = [currentSkill];
			}
		}

		$log.debug($scope.categorySkillMap);
		$scope.loadComplete = true;
	});
});