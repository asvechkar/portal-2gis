jQuery ->
  Morris.Bar
    element: 'incomes_chart'
    data: $('#incomes_chart').data('indata')
    xkey: 'indate'
    ykeys: $('#incomes_chart').data('inlabel')
    labels: $('#incomes_chart').data('initials')
    hideHover: 'auto'