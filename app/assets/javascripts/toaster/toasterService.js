angular.module('partnr.notify').factory('toaster', function($rootScope) {

    function toast(type, text) {
        $rootScope.$broadcast('toast', {
            type: type,
            text: text
        });
    }

    return {
        success: function(text) {
            toast('success', text);
        },
        error: function(text) {
            toast('danger', text);
        },
        warn: function(text) {
            toast('warning', text);
        },
        info: function(text) {
            toast('info', text);
        }
    };
});
