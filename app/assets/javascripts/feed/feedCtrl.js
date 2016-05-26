angular.module('partnr.feed').controller('FeedController', function($scope, $state, $q, $log, principal, feeds) {
  $scope.user = principal.getUser();
  $scope.activities = [];
  $scope.loadComplete = false;
  var page = 0;

  var makeReadable = function(attr) {
    return attr.replace('_', ' ');
  };

	var parse = function(activity) {
    var re = /{\w+_\w+}/;
		var result = activity.message;
    var unparsed;
    while( ( unparsed = re.exec(result) ) !== null) {
      for (var i=0; i < unparsed.length; i++) {
        var ent = unparsed[i];
        var arr = ent.slice(1,-1).split('_');
        result = result.replace(ent, makeReadable(activity.subject[arr[0]][arr[1]]));
      }
    }

		return result;
	};


  $scope.getNextFeedPage = function() {
    feeds.list(++page).then(function(res) {
      $log.debug('[FEED] recieved feed:');
      for(var i=0; i < res.data.length; i++) {
        res.data[i]['user'] = res.data[i]['actor'];
        // get rid of "{user_name}" for now
        res.data[i].message = res.data[i].message.slice(res.data[i].message.indexOf('}')+2);
        res.data[i].parsedMessage = parse(res.data[i]);
        res.data[i].displayDate = (new Date(res.data[i].sent_at)).toDateString();
      }
      $log.debug(res);
      $scope.activities = res.data;
      $scope.loadComplete = true;
    });
  };


  $scope.getNextFeedPage();
});
