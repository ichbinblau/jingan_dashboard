# widgetListViewWidget
$ = this.af
# attr : 表示widget属性，像行数列数等
# data : 为生成widget所用数据
# configs : 上下传参
cache = {}

baseurl = _appcfg_url || "./"
opts = 
	control_id : null
	configs : null
	current_page : null
	tpl : """
		<ul class="list">
			<% for (var i=0 ; i< input.ListByType.length ; i++) {%>
				<li class="listview-twoline" pos="<%= i %>">
					<% if ( input.ListByType[i].image_cover ){ %>
						<img class="left-img" src="<%= $.getISUrl(input.ListByType[i].image_cover , '100') %>" />
					<% } %>
					<div class="right-div">
						<% if ( input.ListByType[i].title ){ %>
							<div class="title"><%= input.ListByType[i].title %></div>
						<% } %>
						<% if ( input.ListByType[i].abstracts ){ %>
							<div class="des"><%= input.ListByType[i].abstracts %></div>
						<% } %>
					</div>
					<div class="badge">
						<% if ( input.ListByType[i].date ){ %>
							<div class="date"><%= input.ListByType[i].date %></div>
						<% } %>
						<% if ( input.ListByType[i].label ){ %>
							<div class="label"><%= input.ListByType[i].label %></div>
						<% } %>
					</div>
					<div style="clear:both;"></div>
				</li>
			<% } %>
		</ul>
	"""


$.fn["widgetListViewWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		# if  !cache[item._plugin_id]
		cache[item._plugin_id] = new widgetListViewWidget(item, opt)
		tmp = cache[item._plugin_id]
		# else
		# 	cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

widgetListViewWidget = (el, opts) -> 
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
	return self

widgetListViewWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	tpl : null
	configs : null
	params : null
	events : {
		itemClick : {
			javascript : "",
			params : []
		}
	}
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype
		$.template_set "widgetListViewWidget" , self.tpl

	setData : () ->
		self = this
		data = self.configs.datasource.data
		if Object.toQueryString(data) == ""
			method = this.configs.datasource.method
			$.ui.showMask()
			$.callApi method , $.ecParams(self.configs.datasource.params, self , 1)  , (res) ->
				$.ui.hideMask()
				if res.data.error
					alert "请求出错："+res.data.error.errordes
				else
					self.showList res , self
		else
			self.showList data , self
	onResume : (options) ->
		self = this
		# console.log "apppage : resume - #{self.name}"
		# console.log "params : #{Object.toJSON( self.params )} "
		# console.log "newpar : #{Object.toJSON(options.params) }"
		if self.params? && Object.toJSON(self.params) != Object.toJSON(options.params) 
			self.params = options.params
			# 重新启动 controls
			console.log "apppage : renew - #{self.id}"
			for item in data.auto_start_controls
				continue if "undefined" == typeof self.controls[item]
				self.startControl item

	showList : (data ,self)->
		# console.log "adapter input:" , data
		input = $.adapter( data.data , self.configs.datasource.adapter )
		self.configs.datasource.data = input
		console.log "adapter output to ##{self.current_page.id} ##{self.el.id}:" , $.template("widgetListViewWidget",{ input : input })
		$("._page#{self.current_page.id} ##{self.el.id}").html $.template("widgetListViewWidget",{ input : input })
		$("._page#{self.current_page.id} ul.list>li").each((index ,item) ->
			$(item).bind 'click' , (evt) ->
				self.itemClickEvent index ,item , self
		)

	itemClickEvent : ( index , ele , self ) ->
		str = "params = {};"
		for k , v of $.ecParams( self.events.itemClick.params , self , index )
			str += "params.#{k} = '#{v}';"
		str += "#{self.events.itemClick.javascript}"
		console.log "itemClickEvent: eval = "+str
		eval str


# {
#       "control_id": "page_fragment_product_ListViewWidget",
#       "xtype": "ListViewWidget",
#       "layout": "",
#       "datasource": {
#         "method": "content.getsonsortlist",
#         "data": {},
#         "params": [
#           {
#             "key": "sortid",
#             "value": "422",
#             "defaultValue": "null"
#           }
#         ],
#         "adapter": [
#           {
#             "key": "model",
#             "value": "free",
#             "defaultValue": "null"
#           },
#           {
#             "key": "SonSorList[]",
#             "value": "ListByType[]",
#             "defaultValue": "null"
#           },
#           {
#             "key": "SonSorList[].name",
#             "value": "ListByType[].title",
#             "defaultValue": "null"
#           },
#           {
#             "key": "SonSorList[].sort_img",
#             "value": "ListByType[].image_cover",
#             "defaultValue": "null"
#           }
#         ]
#       }