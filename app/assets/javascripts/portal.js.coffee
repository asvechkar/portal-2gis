jQuery ->
  d = new Date()
  # Поступление денежных средств
  new Highcharts.Chart(
    chart:
      type: "spline"
      renderTo: "chart-incomes"
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
        Highcharts.dateFormat("%d.%m", @x) + ": " + Highcharts.numberFormat(@y, 2) + " р."
    series: [
      name: "План"
      color: "#6F8745"
      marker:
        symbol: "circle"
      pointInterval: (d.getDate() - 1) * 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: [parseFloat($("#chart-incomes").data("plan")), parseFloat($("#chart-incomes").data("plan"))]
    ,
      name: "Факт"
      color: "#CC181E"
      marker:
        symbol: "circle"
      pointInterval: 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: $("#chart-incomes").data("fact")
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
  # Изменение груза в выпуск
  new Highcharts.Chart
    chart:
      type: "spline"
      renderTo: "chart-change-wight"
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
        Highcharts.dateFormat("%d.%m", @x) + ": " + Highcharts.numberFormat(@y, 2) + " р."
    series: [
      name: "План"
      color: "#6F8745"
      marker:
        symbol: "circle"
      pointInterval: (d.getDate() - 1) * 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: [parseFloat($("#chart-change-wight").data("plan")), parseFloat($("#chart-change-wight").data("plan"))]
    ,
      name: "Факт"
      color: "#CC181E"
      marker:
        symbol: "circle"
      pointInterval: 24 * 3600000
      pointStart: Date.UTC(d.getYear(), d.getMonth(), 1, 0, 0, 0, 0)
      data: $("#chart-change-wight").data("fact")
    ]
