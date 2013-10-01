//= require jquery
//= require jquery-migrate-1.2.1
//= require jquery_ujs
//= require jquery.bootstrap.wizard
//= require jquery.inputmask.bundle
//= require jquery.toggle.buttons
//= require highcharts
//= require highcharts/highcharts-more
//= require beautify
//= require beautify-html
//= require jquery.prettyPhoto
//= require modernizr
//= require bootbox.js
//= require bootstrap
//= require bootstrap-timepicker
//= require bootstrap-datetimepicker
//= require bootstrap-select
//= require twitter-bootstrap-hover-dropdown
//= require jquery.slimscroll
//= require holder
//= require jquery.uniform
//= require jquery-fileupload
//= require bootstrap-fileupload
//= require employee
//= require incomes
//= require debts
//= require upload
//= require reports
//= require pGenerator.jquery



function toggleMenuHidden()
{
  //console.log('toggleMenuHidden');
  $('.container-fluid:first').toggleClass('menu-hidden');
  $('#menu').toggleClass('hidden-phone', function()
  {
    if ($('.container-fluid:first').is('.menu-hidden'))
    {
      if (typeof resetResizableMenu != 'undefined')
        resetResizableMenu(true);
    }
    else
    {
      removeMenuHiddenPhone();

      if (typeof lastResizableMenuPosition != 'undefined')
        lastResizableMenuPosition();
    }

    if (typeof $.cookie != 'undefined')
      $.cookie('menuHidden', $('.container-fluid:first').is('.menu-hidden'));
  });

  if (typeof masonryGallery != 'undefined')
    masonryGallery();
}

function removeMenuHiddenPhone()
{
  if (!$('.container-fluid:first').is('.menu-hidden') && $('#menu').is('.hidden-phone'))
    $('#menu').removeClass('hidden-phone');
}

$(function()
{
  $('.navbar.main .btn-navbar').click(function()
  {
    var disabled = typeof toggleMenuButtonWhileTourOpen != 'undefined' ? toggleMenuButtonWhileTourOpen(true) : false;
    if (!disabled)
      toggleMenuHidden();
  });

  if ($('.uniformjs').length) $('.uniformjs').find("select, input, button, textarea").uniform();
  $('.selectpicker').selectpicker();
  if ($('.toggle-button').length) $('.toggle-button').toggleButtons();
  
  $('#password_generator_btn').pGenerator({
          'bind': 'click',
          'passwordElement': '#my-input-element',
          'displayElement': '#my-display-element',
          'passwordLength': 8,
          'uppercase': true,
          'lowercase': true,
          'numbers':   true,
          'specialChars': false,
          'onPasswordGenerated': function(generatedPassword) {
          	$('#member_password').val(generatedPassword);
            $('#password_generator_label').html(generatedPassword);
          }
      });
  
  $('.checkboxs tbody').on('click', 'tr.selectable', function(e){
    $('#selected_count').text($('.checkboxs tbody :checked').length);
    for (var i = 0; i < $('.checkboxs tbody :checked').length; i++) {
      order_id = $('.checkboxs tbody :checked')[i].id
       $('#selected_count').text(order_id);
    }
  });

  $('#dtp_orderdate').datetimepicker({
      format: "dd.mm.yyyy",
      weekStart: "1",
      autoclose: "true",
      minView: "2",
      todayBtn: "true",
      language: "ru"
  });
  $('#dtp_startdate').datetimepicker({
    format: "dd.mm.yyyy",
    weekStart: "1",
    autoclose: "true",
    minView: "2",
    todayBtn: "true",
    language: "ru"
  });
  $('#dtp_finishdate').datetimepicker({
    format: "dd.mm.yyyy",
    weekStart: "1",
    autoclose: "true",
    minView: "2",
    todayBtn: "true",
    language: "ru"
  });
  $('#dtp_birthdate').datetimepicker({
    format: "dd.mm.yyyy",
    weekStart: "1",
    autoclose: "true",
    minView: "2",
    todayBtn: "true",
    language: "ru"
  });
  $('#member_birthdate').on('change', function(){
    year = parseInt($('#member_birthdate').val().match(/\d+/g)[2]);
    month = parseInt($('#member_birthdate').val().match(/\d+/g)[1]) - 1;
    day = parseInt($('#member_birthdate').val().match(/\d+/g)[0]);
    birthdate = new Date(year, month, day);
    todate = new Date();
    defdate = todate - birthdate;
    $('#age').val(Math.floor(defdate / (1000*60*60*24*365.26)).toString());
  });
  $("#inputmask-currency").inputmask('999 999 999,99', { numericInput: true, rightAlignNumerics: false, greedy: false});
  $('#member_phone').inputmask('(999) 999-9999', { numericInput: true, rightAlignNumerics: false, greedy: false})
});