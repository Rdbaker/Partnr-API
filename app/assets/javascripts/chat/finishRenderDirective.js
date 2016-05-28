angular.module('partnr.messaging').directive('finishRender', function ($timeout, $parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            if (scope.$last === true) {
                $timeout(function () {
                    scope.$emit('ngRepeatFinished');
                    if(!!attr.finishRender){
                      $parse(attr.finishRender)(scope);
                  }
              });
            }
        }
    };
});