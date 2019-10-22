// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//  require rails-ujs
//  require turbolinks
//= require jquery
//= require jquery_ujs
//= require jquery.min
//= require bootstrap
//= require bootstrap.min
//= require slick.min
//= require owl.carousel
//= require jquery.flexslider
//= require jquery.easy-autocomplete
//= require jquery.lazy.min
//= require bootstrap-slider.min
//= require bootstrap-datepicker
//= require main
//= require toastr.min
//= require creditcard
//  require_tree .

$(document).ready(function(){
  $('#collapsibleNavbar').mouseleave(function() {
    $(this).collapse('toggle');
  });

  $(".datepicker").datepicker({
    format: 'dd/mm/yyyy',
    startDate: new Date(),
    autoclose: true
  });
  $('form').on('click', '.remove_record', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.row').hide();
    return event.preventDefault();
  });
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('.fields').append($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });
});

function to_brl(n) {
  return "R$ " + n.toFixed(2).replace('.', ',').replace(/(\d)(?=(\d{3})+\,)/g, "$1.");
}
