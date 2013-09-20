jQuery ->
  jQuery("#branches").on "change", ->
    window.location = "/reports/planfact/" + jQuery("#branches :selected").val()
