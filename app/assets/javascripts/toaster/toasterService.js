angular.module('partnr.toaster').factory('toaster', function($rootScope) {
  var toasts = [];

  function toast(type, text) {
    toasts.push({
      type: type,
      text: text
    });

    $rootScope.$broadcast('toast', {
      type: type,
      text: text
    });
  }

  function getToasts() {
    return toasts;
  }

  return {
    getToasts: getToasts,
    success: function(text) {
      toast('success', text)
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