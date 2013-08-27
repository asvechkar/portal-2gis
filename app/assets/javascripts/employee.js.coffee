@FieldOper =
  start: (level) ->
    if level == 0
      jQuery('#employee_level_id').hide()
      jQuery('#groups').hide()
    else
      jQuery('#employee_level_id').show()
      jQuery('#groups').show()
jQuery ->
  level = parseInt(jQuery('#level').val())
  FieldOper.start(level)
  jQuery('#employee_position_id').change ->
    pos = jQuery('#employee_position_id :selected').val()
    jQuery.get '/positions/level.js?id=' + pos, (response) ->
      level = parseInt(jQuery(jQuery('#levels').html()).find('#show_level').val())
      jQuery('#level').val(level)
      FieldOper.start(level)

