//= require jquery
//= require jquery-migrate-1.2.1
//= require jquery_ujs
//= require jquery.inputmask.bundle
//= require turbolinks
//= require beautify
//= require beautify-html
//= require jquery.prettyPhoto
//= require modernizr
//= require bootstrap
//= require bootstrap-timepicker
//= require bootstrap-datetimepicker
//= require jquery.slimscroll
//= require holder
//= require jquery.uniform
//= require employee

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
  $("#inputmask-currency").inputmask('999 999 999,99', { numericInput: true, rightAlignNumerics: false, greedy: false});
});