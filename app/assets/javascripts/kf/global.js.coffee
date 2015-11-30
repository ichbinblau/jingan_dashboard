# 将input表单改为可层级选择的selector
@input_to_hierarchy_selector = (inputs , json_urls, init_param)->
	rand = Math.floor((Math.random() * 10000000) + 1);

	input_onchange = (a)->
		obj = $(this)
		now_num = parseInt(obj.data('input_num'));
		now_value = $(obj , "option:selected").val();
		$("input[input_id=#{rand}_input_#{now_num}]").val now_value
		init_select($("##{rand}_select_#{ now_num + 1}") , json_urls[now_num + 1] , now_value , $("input[input_id=#{rand}_input_#{now_num + 1}]").val() ) if inputs.length - 1 > now_num
		$("##{rand}_select_#{ now_num + 1}").change()

	init_select = (obj , url , param , default_value)->
		obj.html "<option></option>"
		$.getJSON "#{url}#{param}" , (data)->
			if data.children?
				for item in data.children
					if parseInt(default_value) != parseInt(item.id)
						obj.append "<option value='#{item.id}'>#{item.name}</option>"
					else
						obj.append "<option value='#{item.id}' selected>#{item.name}</option>"
					
	set_default_option = (obj , url ,param) ->
		$.getJSON "#{url}#{param}" , (data) ->
			if data.name?
				obj.append "<option value='#{param}' selected>#{data.name}</option>"

	# 初始化input
	for input,i in inputs
		obj = input
		obj.attr("input_id" , "#{rand}_input_#{i}").data("input_num" , "#{i}")
		obj.after "<select id='#{rand}_select_#{i}'></select>"
		obj.hide()
	# 添加事件
	for input,i in inputs
		obj = input
		selectObj = $("##{rand}_select_#{i}")
		selectObj.data("input_num" , "#{i}").change(input_onchange)
		if parseInt(obj.val()) > 0
			set_default_option(selectObj , json_urls[i] ,obj.val()) if i != 0
		else
			selectObj.append "<option></option>"
	# 第一个input初始化
	init_select($("##{rand}_select_0") , json_urls[0] , init_param , $("input[input_id=#{rand}_input_0]").val())

# 将input表单改为可层级选择的selector，最终归为一个表单input
@input_to_hierarchy_1selector = (input , json_urls, init_param , default_value_url)->
	rand = Math.floor((Math.random() * 10000000) + 1);
	input_onchange = (a)->
		obj = $(this)
		now_num = parseInt(obj.data('input_num'));
		now_value = $(obj , "option:selected").val();
		# 启动下一个select
		if json_urls.length - 1 > now_num
			init_select $("##{rand}_select_#{ now_num + 1}") , json_urls[now_num + 1] , now_value , $("input[input_id=#{rand}_input_#{now_num + 1}]").val() 
			$("##{rand}_select_#{ now_num + 1}").change()
		# 修改input值
		if json_urls.length - 1 == now_num && parseInt(now_value) > 0
			input.val now_value
	init_select = (obj , url , param , default_value)->
		obj.html "<option></option>"
		$.getJSON "#{url}#{param}" , (data)->
			if data.children?
				for item in data.children
					if parseInt(default_value) != parseInt(item.id)
						obj.append "<option value='#{item.id}'>#{item.name}</option>"
					else
						obj.append "<option value='#{item.id}' selected>#{item.name}</option>"
			else
				for item in data
					if parseInt(default_value) != parseInt(item.id)
						obj.append "<option value='#{item.id}'>#{item.name}</option>"
					else
						obj.append "<option value='#{item.id}' selected>#{item.name}</option>"
					
	set_default_option = (obj ,param) ->
		$.getJSON "#{default_value_url}#{param}" , (data)->
			if data.name?
				obj.append "<option value='#{param}' selected>#{data.name}</option>"

	input.hide()
	# 初始化select
	for url,i in json_urls
		input.parent().append "<select id='#{rand}_select_#{i}'></select><br />"
		$("##{rand}_select_#{i}").data("input_num" , "#{i}").change(input_onchange)
		
	set_default_option($("##{rand}_select_#{json_urls.length - 1}") , input.val()) if parseInt(input.val()) > 0
	# 第一个input初始化
	init_select($("##{rand}_select_0") , json_urls[0] , init_param , $("input[input_id=#{rand}_input_0]").val())

# 搜索选择的selector
@get_search_selector = (selectInput ,searchUrl ,initRawData , isMuti  )->
	selectInput.hide()
	selectInput.after "<input id='input_#{selectInput.attr("id")}' />"
	# 简单处理一下数据，查找name title 作为text字段显示
	formatData = (data)->
		for item,i in data
			item.text = item.title if item.title?
			item.text = item.name if item.name?
			item.text = item.ectitle if item.ectitle?
		return data

	removeFromSelect = (value) ->
		$("##{selectInput.attr("id")} option[value='#{value}']").remove();

	addToSelect = (value ,text) ->
		selectInput.append "<option value='#{value}' selected>#{text}</option>"

	initData = formatData(initRawData)
	initData = initData[0] unless isMuti
	$("#input_#{selectInput.attr("id")}").select2
		placeholder: "请输入关键字查询"
		width: 380
		minimumInputLength: 1
		multiple: isMuti
		ajax: 
			url : searchUrl
			data : (term, page) ->
				return { search: term };
			results : (data, page)->
				return { results: formatData(data) }
		dropdownCssClass: "bigdrop",
		escapeMarkup:  (m)->
			return m
	.select2( 'data', initData )
	.on "select2-selecting" ,(e) ->
		addToSelect e.choice.id ,e.choice.text
	.on "select2-removed" ,(e) ->
		removeFromSelect e.choice.id
	for item,i in initData
		addToSelect(item.id ,item.text)

@search_list = ()->
