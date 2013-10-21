//= require jquery
//= require jquery.ui.all
//= require jquery.ui.datepicker-ru
//= require jquery_ujs
//= require jquery-migrate-1.2.1
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
//= require upload
// bootstrap-fileupload
//= require employee
//= require incomes
//= require debts
//= require upload
//= require reports
//= require pGenerator.jquery
//= require wizard

function equalHeight(boxes)
{
	boxes.height('auto');
	var maxHeight = Math.max.apply( Math, boxes.map(function(){ return $(this).height(); }).get());
	boxes.height(maxHeight);
}

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
  $('#selected_count').text($('.checkboxs tbody :checked').length)

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
  var orders_ids = [];
  $('.checkboxs tbody').on('click', 'tr.selectable', function(e){
    var all_elements = $('.checkboxs tbody :checked').length;
    orders_ids = [];
    $('#selected_count').text(all_elements);
    for (var i = 0; i < all_elements; i++) {
      orders_ids.push($('.checkboxs tbody :checked')[i].id);
    }
    $('#check_all').removeAttr('checked');
    $.uniform.update();
  });

  $('.set_continue').click( function (e){
    var url = $('.set_continue').data('url');
    $.ajax({
      type:'post',
      url: url,
      data: ({ ids: orders_ids }),
      success: function () { location.reload(true); }
    });
    orders_ids = null;
    return false;
  });

  $('#check_all').click( function() {
    if ($('#check_all').is(':checked')) {
      $('input:checkbox').each(function() {
        this.checked = true;
      });
      $('#selected_count').text($('.checkboxs tbody :checked').length)
      $.uniform.update();
    }
    else {
      $('input:checkbox').each(function() {
        this.checked = false;
      });
      $('#selected_count').text($('.checkboxs tbody :checked').length)
      $.uniform.update();
    }
  });

  $("#planfact_date").datetimepicker({
    pickTime: false,
    format: "mm.yyyy",
    weekStart: "1",
    autoclose: "true",
    minView: "2",
    todayBtn: "true",
    language: "ru"
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

ajaxRequest = function(url, type) {
  $.ajax({
    url: url,
    type: type
  })
}
