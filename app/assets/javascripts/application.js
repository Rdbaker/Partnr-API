//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink

$(document).ready(function() {
  $('.close').click(function() {
    $(this.parentElement).slideUp();
  });
});

(function(window, document) {
  var entity_map = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  window.escapeHTML = function(str) {
    return String(str).replace(/[&<>"'\/]/g, function (s) {
      return entity_map[s];
    });
  };

})(window, document, undefined);
