@FieldOper =
  start: (level) ->
    if level == 0
      jQuery('#employee_level_id').hide()
      jQuery('#levelgroups').hide()
      jQuery('#groups').hide()
    else
      jQuery('#employee_level_id').show()
      jQuery('#levelgroups').show()
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
  jQuery('#employee_branch_id').change ->
    branch_id = jQuery('#employee_branch_id :selected').val()
    if (branch_id == "")
      branch_id = "0"
    jQuery.get '/employees/get_groups_by_branch_id/' + branch_id, (data) ->
      jQuery('#group_group_ids').html(data)
