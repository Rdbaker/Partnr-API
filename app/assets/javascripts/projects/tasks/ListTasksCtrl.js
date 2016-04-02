angular.module('partnr.users.assets').controller('ListTasksController', function($scope, $state, $stateParams, $log, $q, projects, principal, toaster) {
	$scope.project = {};
	$scope.applications = [];
	$scope.viewingEntity = 'Milestones';
	$scope.isOwner = false;

	$scope.loadComplete = false;
	var loadSteps = 2;
	var loadStepsAchieved = 0;

	// applications.list({'project' : $stateParams.project_id}).then(function(result) {
	// 	$scope.applications = result.data;
	// 	doLoadStep();
	// });

	// projects.get($stateParams.project_id).then(function(result) {
	// 	$scope.project = result.data;
	// 	$scope.isOwner = result.data.owner.id === principal.getUser().id;
	// 	doLoadStep();
	// });

	// $scope.doReload = function() {
	// 	$scope.loadComplete = false;
	// 	applications.list({'project' : $stateParams.project_id}).then(function(result) {
	// 		$log.debug(result.data);
	// 		$scope.applications = result.data;
	// 		$scope.loadComplete = true;
	// 	});
	// };

	// var doLoadStep = function() {
	// 	loadStepsAchieved += 1;
	// 	if (loadStepsAchieved >= loadSteps) {
	// 		$scope.loadComplete = true;
	// 	}
	// };
});
