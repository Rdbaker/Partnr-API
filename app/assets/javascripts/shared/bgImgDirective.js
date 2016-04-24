angular.module('partnr.core').directive('pnBgImg', function() {
    return function(scope, elt, attrs) {
        attrs.$observe('pnBgImg', function(url) {
            elt.css({
                'background-image': 'url(' + url + ')',
                'background-size': 'cover'
            });
        });
    };
});
