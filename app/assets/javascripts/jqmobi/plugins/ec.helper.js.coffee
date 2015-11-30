$ = this.af
self = this
apibaseurl = "/webapis/wiki/"

# 访问api
$["callApi"] = (method , params , success ,version) ->
	opts = {
		method : method
		version : params["version"] || "1.0"
	}
	$.extend(opts ,params)
	# console.log "opts: #{Object.values(opts)}"
	$.post apibaseurl+"call_api" , $.extend(opts ,params) , success , 'json'

# 将数组处理成 key - value ，处理 _widgetConfig _widgetData _pageData _pageConfig
$["ecParams"] = (input , control ,position) ->
	output = {}
	# console.log "input:"+Object.keys input
	input.map (val) ->
		output[val.key] = val.value || val.defaultValue
		
		if output[val.key] is "null"
			output[val.key] = "" 
		else
			# 替换为指定对象的调用
			output[val.key] = self._getParam output[val.key] , control , position
	# console.log "output:"+Object.toQueryString output
	return output

# 一般hash 对象处理 _widgetConfig _widgetData _pageData _pageConfig
$["parseParams"] = (input ,control) ->
	for key , item of input
		input[key] = self._getParam item , control
	return input

@_getParam = (input , control ,position ) ->
	return input.gsub( /\{(_widgetConfig|_widgetData|_pageData|_pageConfig|_page)([^{]+)\}/, (match)-> 
		switch match[1]
			when "_widgetConfig"
				str = "control.params"
			when "_widgetData"
				str = "control.configs.datasource.data"
			when "_page"
				str = "control.current_page.params"
			when "_pageData"
				str = "control.current_page.configs.datasource.data"
		str = str + match[2]
		# params上出现[#{position}]的情况，会传入位置，再进一步读取
		str = str.replace "[position]","[#{position}]" if position?
		# console.log "_getParams:"+str
		return eval str
		)
# 获取图片url
$["getISUrl"] = ( id , width ,height) ->
	id = id.url.split("/")[id.url.split("/").length-1] if typeof id != "string"
	size = ""
	if width
		if  !height
			size = "_#{width}"
		else 
			size = "_#{width}x#{height}"
	else
		if height
			size = "_x#{height}"
	return "http://is.hudongka.com/#{id.split('.')[0]}#{size}.#{id.split('.')[1]}"


# 系统接口 ################################################################
$["postEvent"] = (method , p1 ,p2 ,p3) ->
	params = []
	params.push p1
	params.push p2
	params.push p3
	console.log "postEvent: #{method} ; params - #{params}"
	return console.log "postEvent: #{method} faild , not found " if !$[method]?
	return $[method] params

# alert confirm
$["ShowConfirm"] = ( msg , cancelTag , okTag ) ->
	$.ui.popup( {
		title: "完成"
		message: msg
		cancelText: "返回"
		cancelCallback: () ->
			cancelTag() if cancelTag?
		cancelOnly: !okTag?
		doneText: "完成"
		doneCallback: () ->
			okTag()
	})
# 使用url打开页面
$["openURL"] = (url) ->
	para = []
	u = url.split "?"
	u[1] = "" if !u[1]?
	# console.log  "............"+encodeURIComponent(u[1])
	$.openPage url, decodeURIComponent(u[1]).toQueryParams()


# 使用参数模式打开页面， postevent时常用
$["openActivity"] = (params) ->
	params[2] = params[2].evalJSON()
	title = params[2].title
	$.openPage params[1]+"?#{$H(params[2]).toQueryString()}" , params[2]

# 通过page config打开一个page的具体操作
$["openPage"] = (url , params) ->
	# page_id = decodeURIComponent(page_id)
	page_id = $.getPageID url
	params.title = "" if !params.title?
	console.log "openactivity :##{url} ( ._page#{page_id} ); title: #{params.title} ;"
	content = """
		<div title='#{params.title}' id="#{url}" class="panel _page _page#{page_id}" ></div>
	"""
	if $("._page#{page_id}").length == 0
		$.ui.addContentDiv url , content , params.title
		# 放入panel的带scroll的div中
		$($("#content>div").eq( $("#content>div").length - 1 )).find(".afScrollPanel").addClass("_page#{page_id}")
		# $($("#content>div").eq( $("#content>div").length - 1 )).addClass("_page#{page_id}")
	$.ui.loadContent( "##{url}" , true , true )
	$("._page#{page_id}").appPage {page_id : url , params : params }

$["getPageID"] = (url) ->
	encodeURIComponent(url).replace( /[\&|\%|\?]/ig , "_")
# 设置page_id，pageid作为url的时候不能用于DOM对象的id
# _pages = {}
# _now_page_id = 100000
# $["getPageURL"] = (page_id) ->
# 	console.log "getPageURL: "+_pages[page_id]
# 	return _pages[page_id]
# $["setPageID"] = (url) ->
# 	_now_page_id = _now_page_id + 1
# 	_pages["page_"+_now_page_id] = url
# 	console.log "setPageID: page_#{_now_page_id} , "+url
# 	return "page_"+_now_page_id


@alert = ->
	$.ui.showMask();
	setTimeout( ()-> 
		$.ui.hideMask();
		$.ui.popup( {
			title: "成功"
			message: "信息提交成功，我们的工作人员会第一时间处理您的预约!"
			cancelText: "返回"
			cancelCallback: () ->
				$.ui.goBack();
			cancelOnly:true
			# doneText: "返回"
			doneCallback: () ->
				$.ui.goBack();
		});
	, 500)
