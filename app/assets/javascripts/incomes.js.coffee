jQuery ->
  jQuery('#brancheslist').change (event)->
    event.preventDefault()
    branch_id = jQuery('#brancheslist :selected').val()
    window.location = window.location.origin + window.location.pathname + '?branch=' + branch_id
  jQuery('#managerslist').change (event)->
    event.preventDefault()
    branch_id = jQuery('#managerslist :selected').val()
    window.location = window.location.origin + window.location.pathname + '?manager=' + branch_id

