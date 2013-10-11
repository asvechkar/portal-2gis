$ ->
  $(".refresh").on "click", (event)->
    event.preventDefault()
    $('#update_planfact').val('1')
    $('form#planfact_params').submit()
