$ ->
  $("#plans_search").submit (e) ->
    form = $(this)
    $.ajax(
      type: "GET"
      url: "/plans"
      data: form.serialize()
      success: (response) ->
        $(".plans-list").html response.html)
    e.preventDefault()
