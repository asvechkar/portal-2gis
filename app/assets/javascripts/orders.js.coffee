$ ->
  $("#orders_search").submit (e) ->
    form = $(this)
    $.ajax(
      type: "GET"
      url: "/orders"
      data: form.serialize()
      success: (response) ->
        $(".orders-list").html response.html
        initializeCustomStuff())
    e.preventDefault()
