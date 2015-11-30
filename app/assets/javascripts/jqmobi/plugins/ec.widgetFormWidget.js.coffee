# widgetFormWidget
# attr : 表示widget属性，像行数列数等
# data : 为生成widget所用数据
# configs : 上下传参
# 表单类型 hidden text password label textarea checkbox radio select number

$ = this.af
cache = {}

baseurl = _appcfg_url || "./"
opts = 
	control_id : null
	configs : null
	current_page : null
	tpl : """
		<style>
			#afui.ios7 label{height:26px;overflow:hidden;width:39%}
			#afui.ios7 label+input,#afui.ios7 label+select,#afui.ios7 label+textarea{width:60%}
			#afui.ios7 .input-group{padding:5px;}
		</style>
		<form style="margin:10px;">
			<% for ( var i=0 ; i < input.input_list.length ; i++) { %>
				<% item = input.input_list[i] ; if ( item.default_layout == "number" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><input id="<%= item.name %>" name="<%= item.name %>" type="number" value="<%= item.default_value %>" placeholder="<%= item.text %>">
				<% } else if ( item.default_layout == "text" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><input id="<%= item.name %>" name="<%= item.name %>" type="text" value="<%= item.default_value %>" placeholder="<%= item.text %>">
				<% } else if ( item.default_layout == "label" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><input id="<%= item.name %>" name="<%= item.name %>" type="text" readonly value="<%= item.default_value %>" placeholder="<%= item.text %>">
				<% } else if ( item.default_layout == "hidden" ) { %>
					<input id="<%= item.name %>" name="<%= item.name %>" value="<%= item.default_value %>" type="hidden">
				<% } else if ( item.default_layout == "password" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><input id="<%= item.name %>" value="<%= item.default_value %>" name="<%= item.name %>" type="password" placeholder="<%= item.text %>">
				<% } else if ( item.default_layout == "textarea" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><textarea rows="3" id="<%= item.name %>" name="<%= item.name %>" type="text" placeholder="<%= item.text %>"><%= item.default_value %></textarea>
				<% } else if ( item.default_layout == "select" ) { %>
					<label for="<%= item.name %>"><%= item.text %></label><select id="<%= item.name %>" name="<%= item.name %>">
						<% for ( var j=0 ; j < item.selectlist.options.length ; j++) { %>
							<% option = item.selectlist.options[j] ;%>
							<option value="<%= option.value %>" <%= option.value == item.default_value ? 'selected': '' %>><%= option.text %></option>
						<% } %>
					</select>
				<% } %>
			<% } %>
			<div style="display:inline-block;width:100%">
				<input type="button" class="button gray" value="取消" style="float:left;" onclick="$.ui.goBack();">
				<input type="submit" class="button" value="<%= input.button_submit %>" style="float:right;">
			</div>
		</form>
	"""
$.fn["widgetFormWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		if  !cache[item._plugin_id]
			cache[item._plugin_id] = new widgetFormWidget(item, opt)
			tmp = cache[item._plugin_id]
		else
			cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

widgetFormWidget = (el, opts) -> 
	self = this
	self.el = el
	self.$el = $(el)
	self.current_page = opts.current_page
	self.configs = opts.configs
	self.params = $.ecParams self.configs.configs
	for item in self.configs.setEvent
		self.events[item.name] = item
	$(self.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.tpl = opts.tpl
	console.log "initWidget : #{opts.configs.control_id}"
	self.init( opts.configs.control_id ) if opts.configs.control_id != null

widgetFormWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	tpl : null
	configs : null
	params : null
	events : {
		submit : {
			javascript : "",
			params : []
		}
	}
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype
		$.template_set "widgetFormWidget" , self.tpl

	setData : () ->
		self = this
		data = self.configs.datasource.data
		self.showContent data , self
		
	showContent : (data , self) ->
		console.log "showdontent:##{self.el.id}"
		# 合并默认输入项
		for k,v of self.current_page.params
			for input in data.input_list
				input.default_value = v if input.name == k && input.default_value == ""
		$("._page#{self.current_page.id}").find("##{self.el.id}").html $.template("widgetFormWidget",{ input : data })
		# $.ui.updateContentDiv "##{self.el.id}" ,$.template("widgetFormWidget",{ input : data })
		$("._page#{self.current_page.id}").find("##{self.el.id}").find("form").submit( () ->
			self.submitEvent self
			return false
		)
	submitEvent : ( self ) ->
		inputs = {}
		params = self.$el.find("form select,form textarea,form input[type=text],form input[type=password],form input[type=number],form input[type=hidden]")
		for input in params
			if $(input).val() == ""
				alert("请完整填写表单！")
				return
			else
				inputs[$(input).attr("name")] = $(input).val()
		$.ui.showMask()
		# 提交表单到api
		$.callApi self.configs.datasource.data.post_uri , inputs , (res) ->
			$.ui.hideMask()
			console.log "res : " + Object.toJSON res
			str = "params = {};"
			for k , v of $.ecParams( self.events.submit.params , self )
				str += "params.#{k} = '#{v}';"
			# 表单输入
			str += "params.input = #{Object.toJSON(inputs)};"
			str += "params.result = #{Object.toJSON(res)};"
			str += "#{self.events.submit.javascript}"
			console.log "submitEvent - eval : "+str
			eval str
		console.log "form input : " + Object.toJSON inputs

# @showCustomJsonSheet = ->
# 	$("#afui").actionsheet(
#     [{
#         text: '徐汇田林校区',
#         cssClasses: 'blue',
#         handler: () ->
#             $('#text4').val('徐汇田林校区')
#     }, {
#         text: '宝山大华校区',
#         cssClasses: '',
#         handler: () ->
#             $('#text4').val('宝山大华校区')
#     }, {
#         text: '长宁虹桥校区',
#         cssClasses: '',
#         handler: () ->
#             $('#text4').val('长宁虹桥校区')
#     }]);
# @submitSuccess = ->
# 	$.ui.showMask();
# 	setTimeout( ()-> 
# 		$.ui.hideMask();
# 		$.ui.popup( {
# 			title: "成功"
# 			message: "信息提交成功，我们的工作人员会第一时间处理您的预约!"
# 			cancelText: "返回"
# 			cancelCallback: () ->
# 				$.ui.goBack();
# 			cancelOnly:true
# 			# doneText: "返回"
# 			doneCallback: () ->
# 				$.ui.goBack();
# 		});
# 	, 500)
	
# <label for="test1">宝宝姓名</label><input id="test1" type="text" placeholder="宝宝姓名">
# <label for="test2">宝宝年龄</label><input id="text2" type="search" placeholder="宝宝年龄">
# <label for="test3">手机号码</label><input id="text3" type="search" placeholder="手机号码">
# <label for="test4">预约校区</label><input id="text4" readonly onClick="showCustomJsonSheet()" type="search" placeholder="预约校区">

# {
#   "name": "login",
#   "title": "",
#   "button_submit": "提交",
#   "success_redirect": "pecct://app/null",
#   "post_uri": "pecct://user/addapply",
#   "helper_list": [
#     {
#       "_uri": "pecct://user/regPage",
#       "name": "regPage",
#       "text": "没有账号？点这里注册"
#     }
#   ],
#   "input_list": [
#     {
#       "default_layout": "hidden",
#       "input_type": "",
#       "name": "act_apply_id",
#       "text": "",
#       "default_value": "",
#       "background_wrods": "",
#       "des_wrods": "",
#       "must_input": "",
#       "must_input_words": ""
#     },
#     {
#       "default_layout": "text",
#       "input_type": "",
#       "name": "text1_des",
#       "text": "推荐宝宝姓名",
#       "default_value": "",
#       "background_wrods": "推荐宝宝姓名",
#       "des_wrods": "",
#       "must_input": "",
#       "must_input_words": ""
#     },
#     {
#       "default_layout": "text",
#       "input_type": "",
#       "name": "text2_des",
#       "text": "推荐宝宝校区",
#       "default_value": "",
#       "background_wrods": "推荐宝宝校区",
#       "des_wrods": "",
#       "must_input": "",
#       "must_input_words": ""
#     },
#     {
#       "default_layout": "number",
#       "input_type": "",
#       "name": "text2_des",
#       "text": "推荐家长手机",
#       "default_value": "",
#       "background_wrods": "推荐家长手机",
#       "des_wrods": "",
#       "must_input": "",
#       "must_input_words": ""
#     }
#   ]
# }
