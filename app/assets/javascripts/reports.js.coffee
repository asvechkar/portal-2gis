$ ->
  $(".refresh").on "click", (event)->
    event.preventDefault()
    $('#update_planfact').val('1')
    $('form#planfact_params').submit()

  $('a[rel=tooltip]').tooltip({html:true}).click (e) -> e.preventDefault()
