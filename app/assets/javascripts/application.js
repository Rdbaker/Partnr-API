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
