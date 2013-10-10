$ ->
  $(".refresh").on "click", (event)->
    event.preventDefault()
    $('form#planfact_params').submit()
