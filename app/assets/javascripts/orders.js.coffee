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

  $('#orders_search #order_branch').change ->
    id = $(this).val()
    if id
      $.ajax(
        type: "GET"
        url: "/branches/"+id+"/employees_list"
        success: (response) ->
          $("#orders_search #order_employee").replaceOptions(response.employees))
  $("#order_employee_id").change ->
    employee_id = $('#order_employee_id :selected').val()
    if employee_id != ""
