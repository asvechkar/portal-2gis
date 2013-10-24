$ ->
  $("#plans_search").submit (e) ->
    form = $(this)
    $.ajax(
      type: "GET"
      url: "/plans"
      data: form.serialize()
      success: (response) ->
        $(".plans-list").html response.html)
    e.preventDefault()

  $('#plans_search #filter_branch').change ->
    id = $(this).val()
    if id
      $.ajax(
        type: "GET"
        url: "/branches/"+id+"/groups_list"
        success: (response) ->
          $("#plans_search #filter_group").replaceOptions(response.groups))
