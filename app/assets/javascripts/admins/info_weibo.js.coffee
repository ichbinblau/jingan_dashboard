@showSupports = ->
  $('#support_list').modal('show')

@show_add_status = (weiboinfo , contentid ) ->
  $("#add_status #weibo_type").html(weiboinfo.cnname)
  $("#add_status .weibo_words").html('')
  $("#add_status .weibo_show_image").hide()

  $("#add_status .weibo_words").val($("#ctitle_"+contentid).val()+'：'+$("#ccontent_"+contentid+"_truncate").val()+' '+$("#curl_"+contentid).val()) if contentid
  $("#add_status .weibo_show_image").attr("src","http://is.hudongka.com/"+$("#cimage_"+contentid+"").val()).show() if $("#cimage_"+contentid+"").val()
  $("#add_status .weibo_type").val(weiboinfo.name)

  $('#support_list').modal('hide')
  $('#add_status').modal('show')

@add_status = ->
  type = $("#add_status .weibo_type").val()
  words = $(".weibo_words").val()
  config = weibo_config[type]

  url = config.url_sendmsg
  data = {words:words}
  $.post(url,data,(data) ->
    if data? && (data.errornum? || data.error_code?)
      alert("微博发布出错，请重新登录微博。")
      location.href = config.url_get_token+"?from="+url_now+"&projectnum="+app_num
    else
      alert("发送成功！")
    $('#add_status').modal('hide')

  )
