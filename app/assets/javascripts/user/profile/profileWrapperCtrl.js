angular.module('partnr.users.assets').controller('ProfileWrapperController', function($scope, $rootScope, $state, $q, $stateParams, $filter, $log, principal, toaster, users) {
    $scope.loadComplete = false;
    $scope.user = null;
    $scope.currentUser = principal.getUser();
    $scope.msgBtnEnabled = $rootScope.featureGate.profile.msgBtn;

    $scope.initialize = function() {
        var deferred = $q.defer();
        users.get($stateParams.id).then(function(result) {
            $scope.user = result.data;
            $scope.user.totalSkillScore = 0;
            for (var i = 0; i < $scope.user.skillscore.scored.categories.length; i++) {
                $scope.user.totalSkillScore += $scope.user.skillscore.scored.categories[i].score;
            }
            $log.debug("User at for loop", $scope.user);
            $scope.loadComplete = true;
            $scope.$broadcast('user.updated', $scope.user);

            $log.debug($scope.user);
            deferred.resolve($scope.user);
        });
        return deferred.promise;
    };

    $scope.getProfileWrapperInfo = function() {
        var deferred = $q.defer();

        if ($scope.user !== null) {
            deferred.resolve($scope.user);
        } else {
            $scope.initialize().then(function(result) {
                deferred.resolve(result);
            });
        }
        return deferred.promise;
    };

    $scope.initialize();
});
