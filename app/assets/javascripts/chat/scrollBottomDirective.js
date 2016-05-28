angular.module('partnr.messaging').directive('chatMessageList', function($timeout) {
  return {
    restrict: 'AE',
    scope: {
      messages: '='
  },
  templateUrl: 'chat/chat_message.html',
  link: function(scope, element, attrs) {
    var todayDate = new Date();
    scope.isLoaded = false;
    var previousScrollHeight = 0;
    function scrollTo(scrollHeight,scrollableElt,speed) {
        console.log('scrollin to: ', scrollHeight);
        scrollableElt.animate({scrollTop: scrollHeight}, speed, 'swing', 
            function(){
                scope.isLoaded = true;
            });
    }
    scope.adjustScroll = function () {
        console.log('rendered');
        var elt = angular.element(element[0].querySelector('.js-chat-list'));
        console.log(elt);
        console.log(elt[0]);
        console.log(elt.prop('scrollHeight'));
        if (!scope.isLoaded) {
            scrollTo(elt.prop('scrollHeight'),elt,0);
        } else if (elt.scrollTop() + elt.innerHeight() === previousScrollHeight) {
            scrollTo(previousScrollHeight,elt,400);
        }
        previousScrollHeight = elt.prop('scrollHeight');
    };

    scope.returnDateFilter = function returnDateFilter (date){
        var messageDate = new Date(date);
        if (todayDate.setHours(0,0,0,0) == messageDate.setHours(0,0,0,0)) {
            return 'shortTime';
        } else {
            return 'short';
        }
    };
}
};
});