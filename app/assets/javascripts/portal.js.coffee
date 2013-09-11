jQuery ->
  d = new Date()
  new Highcharts.Chart(
    chart:
      renderTo: "chart-incomes"
    title: null
    xAxis:
      type: "datetime"
      gridLineWidth: 1
    yAxis:
      title: null
    tooltip:
      formatter: ->
        Highcharts.dateFormat("%d.%m", @x) + ": " + Highcharts.numberFormat(@y, 2) + " р."
    series: [
      {name: "Сидоров И.П."
      pointInterval: (24 * 3600000)
      pointStart: Date.parse(new Date(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0))
      data: [0, 2400, 3580.90, 5760, 7390, 3856.67, 0]},
      {name: "Петров С.В."
      pointInterval: (24 * 3600000)
      pointStart: Date.parse(new Date(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0))
      data: [0, 2360.90, 3760, 5390, 1856.67, 0, 0]},
      {name: "Иванов А.С."
      pointInterval: (24 * 3600000)
      pointStart: Date.parse(new Date(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0))
      data: [2360.90, 3760, 5390, 1856.67, 8400, 1200, 5600]},
    ]
  )
