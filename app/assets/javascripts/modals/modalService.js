angular.module('partnr.notify').service('modals', function($uibModal, $location) {
    return {
        // modals

        // alert modal
        alert : function(title, message) {
            var modal = $uibModal.open({
                templateUrl: 'modals/alert_modal.html',
                controller: 'AlertModalController',
                resolve: {
                    title: function() { return title; },
                    message: function() { return message; },

                }
            });
        },

        // confirm modal
        confirm : function(message, callback) {
            var modal = $uibModal.open({
                templateUrl: 'modals/confirm_modal.html',
                controller: 'ConfirmModalController',
                resolve: {
                    message: function() { return message; }
                }
            });

            modal.result.then(callback);
        },
    };
});
