angular.module('partnr.users.assets').directive('chatMessageList', function($timeout) {
  return {
    restrict: 'AE',
    scope: {
      openConversation: '='
  },
  templateUrl: 'chat/chat_message.html',
  link: function(scope, element, attrs) {
    scope.isLoaded = false;
    var previousScrollHeight = 0; 
    console.log();
    scope.$watchCollection('openConversation.messages', function() {
        function scrollDown(scrollHeight,element,speed) {
            console.log('scrollin');
            element.animate({scrollTop: scrollHeight}, speed, 'swing', 
                function(){
                    scope.isLoaded = true;
                });
        }
        $timeout(function() {
         var elt = angular.element(element[0].querySelector('.js-chat-list'));
         if (!scope.isLoaded) {
            console.log('initialScroll');
            scrollDown(elt.prop('scrollHeight'),elt,0);
            
        } else if (elt.scrollTop() + elt.innerHeight() === previousScrollHeight) {
            scrollDown(previousScrollHeight,elt,400);
        }
        previousScrollHeight = elt.prop('scrollHeight');
    });
    });
}
};
});