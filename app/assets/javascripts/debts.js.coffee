jQuery ->
  jQuery('#debt_client_id').change ->
    client_id = jQuery('#debt_client_id :selected').val()
    if (client_id == "")
      client_id = "0"
    jQuery.get '/incomes/get_orders_by_client_id/' + client_id, (data) ->
      jQuery('#debt_order_id').html(data)
