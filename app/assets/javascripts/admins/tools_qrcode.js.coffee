@codeActionForm = (codeid) ->
  $("#contentid").val('')
  $("#codeid").val(codeid)
  $('#code_action').modal('show')

@saveCodeAction = ->
  $.get("save_action.json?id="+$("#codeid").val()+"&contentid="+$("#contentid").val(),(data) ->
    $('#code_action').modal('hide')
    getCodeInfo($("#codeid").val())
  )

@getCodeInfo = (codeid)->
  $.get("show.json?id="+codeid,(data) ->
    $("#modal_data").html(data.data)
    $("#modal_url").html(data.url)
    $("#modal_project").html(data.project_info_id)
    $("#modal_batch_value").html(data.batch_value)
    $("#modal_created_at").html(data.created_at)
    $('#code_info').modal('show')
  )

@showCodeAddForm = ->
  $('#code_add').modal('show')

@saveCodeAddForm = ->
  $('#code_add .btn-primary').attr('disabled','true')
  url = "add.json?batch_value="+$("#batch_value").val()+'&project_info_id='+$("#project_info_id").val()+
        '&url='+$("#url").val()+'&enabled='+$("#enabled").val()+'&num='+$("#num").val()
  $.get(url,(data) ->
    $('#code_add').modal('hide')
    $('#code_add .btn-primary').attr('disabled','false')
    $('#code_add_form input').val("")
  )
