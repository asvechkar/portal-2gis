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
      $.ajax(
        type: "GET"
        url: "/employees/" + employee_id + "/clients_list"
        success: (response) ->
          $("#order_client_id").replaceOptions(response.clients)
      )
  $("#order_client_id").change ->
    client_id = $('#order_client_id :selected').val()
    if client_id != ""
      $.ajax(
        type: "GET"
        url: "/clients/" + client_id + "/orders_list"
        success: (response) ->
          $("#order_order_id").replaceOptions(response.orders)
      )