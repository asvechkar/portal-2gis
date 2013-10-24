$ ->
  $("#incomes_search").submit (e) ->
    form = $(this)
    $.ajax(
      type: "GET"
      url: "/incomes"
      data: form.serialize()
      success: (response) ->
        $(".incomes-list").html response.html)
    e.preventDefault()

  $('#incomes_search #branch').change ->
    id = $(this).val()
    if id
      $.ajax(
        type: "GET"
        url: "/branches/"+id+"/employees_list"
        success: (response) ->
          $("#incomes_search #manager").replaceOptions(response.employees))
