jQuery ->
  d = new Date()
  # Поступление денежных средств
  new Highcharts.Chart(
    chart:
      renderTo: "chart-incomes"
    title: null
    legend:
      enabled: false
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
  # Прирост клиентов
  new Highcharts.Chart
    chart:
      type: "spline"
      renderTo: "chart-grow-clients"
    title: null
    xAxis:
      type: "datetime"
      dateTimeLabelFormats:
        day: "%d.%m"
      gridLineWidth: 1
    yAxis:
      title: null
    tooltip:
      formatter: ->
        "На " + Highcharts.dateFormat("%d.%m", @x) + " клиентов: " + @y
    series: [
      name: "План"
      color: "#6F8745"
      marker:
        symbol: "circle"
      pointInterval: (d.getDate() - 1) * 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: [$("#chart-grow-clients").data("plan"), $("#chart-grow-clients").data("plan")]
    ,
      name: "Факт"
      color: "#CC181E"
      marker:
        symbol: "circle"
      pointInterval: 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: $("#chart-grow-clients").data("fact")
    ]

