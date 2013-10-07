$(document).ready ->
  if $('#wizard')
    Wizard.clients()
    Wizard.current_orders()
    Wizard.continueOrders()
    Wizard.debts()
    Wizard.plans()

@Wizard = ->

Wizard.clients = ->
  url = $('#wizard #tab1-2').data('url')
  ajaxRequest(url, 'GET')

Wizard.continueOrders = ->
  url = $('#wizard #tab2-2').data('url')
  ajaxRequest(url, 'GET')

Wizard.current_orders = ->
  url = $('#wizard #tab3-2').data('url')
  ajaxRequest(url, 'GET')

Wizard.debts = ->
  url = $('#wizard #tab4-2').data('url')
  ajaxRequest(url, 'GET')

Wizard.plans = ->
  url = $('#wizard #tab5-2').data('url')
  ajaxRequest(url, 'GET')
