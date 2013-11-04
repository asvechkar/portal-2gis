$ ->
  $("#factors_search").submit (e) ->
    form = $(this)
    $.ajax(
      type: "GET"
      url: "/factors"
      data: form.serialize()
      success: (response) ->
        $(".plans-list").html response.html)
    e.preventDefault()