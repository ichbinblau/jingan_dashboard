# widgetItemProductWidget
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
		<div class="div-news" style="padding: 10px;">
		  <h3><%= input.title %></h3>
		  <div class="des"><%= input.abstract %></div>
		  <hr/>
		  <center class="well"><img class="left-img" style="width:95%" src="<%= $.getISUrl(input.image_cover , '600') %>" /></center>
		  
		  <div class="rel-div">
		  	<div class="rel-title">产地</div>
		  	<div class="rel-items">
			  	<% for (var i=0 ; i< input.shop_contents.length ; i++) {%>
			  		<div class="rel-item" onclick="$.openURL('page_news_item?contentid=<%= input.shop_contents[i].id %>&title=<%= input.shop_contents[i].title %>')">
			  			<div class="rel-item-img"><img src="<%= $.getISUrl(input.shop_contents[i].image_cover , '100') %>" /></div>
			  			<div class="rel-item-title"><%= input.shop_contents[i].title %></div>
			  		</div>
			  	<% } %>
		  	</div>
		  </div>

		  <div class="rel-div">
		  	<div class="rel-title">搭配产品</div>
		  	<div class="rel-items">
			  	<% for (var i=0 ; i< input.relproduct_contents.length ; i++) {%>
			  		<div class="rel-item" onclick="$.openURL('page_news_item?contentid=<%= input.relproduct_contents[i].id %>&title=<%= input.relproduct_contents[i].title %>')">
			  			<div class="rel-item-img"><img src="<%= $.getISUrl(input.relproduct_contents[i].image_cover , '100') %>" /></div>
			  			<div class="rel-item-title"><%= input.relproduct_contents[i].title %></div>
			  		</div>
			  	<% } %>
		  	</div>
		  </div>

		  <div><pre><%= input.content%></pre></div>
		</div>
	"""


$.fn["widgetItemProductWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		if  !cache[item._plugin_id]
			cache[item._plugin_id] = new widgetItemProductWidget(item, opt)
			tmp = cache[item._plugin_id]
		else
			cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

widgetItemProductWidget = (el, opts) -> 
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

widgetItemProductWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	tpl : null
	configs : null
	params : null
	events : {
		itemLoad : {
			javascript : "",
			params : []
		}
	}
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype
		$.template_set "widgetItemProductWidget" , self.tpl

	setData : () ->
		self = this
		data = self.configs.datasource.data
		if Object.toQueryString(data) == ""
			method = this.configs.datasource.method
			$.ui.showMask()
			# console.log "....."+self.params.title
			# $.ui.setTitle(self.params.title)
			$.callApi method , $.ecParams(self.configs.datasource.params , self , 1) , (res) ->
				$.ui.hideMask()
				if res.data.error
					alert "请求出错："+res.data.error.errordes
				else
					self.showContent res , self
				self.itemLoadEvent self.$el , self
		else
			self.showContent data , self
	showContent : (data , self) ->
		console.log "adapter input:" , data
		input = $.adapter( data.data , self.configs.datasource.adapter )
		self.configs.datasource.data = input
		console.log "adapter output:" , input
		console.log "showContent : #{self.el.id}:" , input
		$("._page#{self.current_page.id}").find("##{self.el.id}").html $.template("widgetItemProductWidget",{ input : input })

	itemLoadEvent : ( ele , self ) ->
		str = "params = {};"
		for k , v of $.ecParams( self.events.itemLoad.params , self )
			str += "params.#{k} = '#{v}';"
		str += "#{self.events.itemLoad.javascript}"
		console.log "itemLoadEvent: eval -  "+str
		eval str

# {
#   "control_id": "page_news_detai_ItemNewsWidget",
#   "xtype": "ItemNewsWidget",
#   "layout": "",
#   "datasource": {
#     "method": "content.getcontentinfo",
#     "data": {},
#     "params": [
#       {
#         "key": "contentid",
#         "value": "{_page.contentid}",
#         "defaultValue": "null"
#       }
#     ],
#     "adapter": [
#       {
#         "key": "model",
#         "value": "deep",
#         "defaultValue": "null"
#       },
#       {
#         "key": "ContentInfo.Title",
#         "value": "title",
#         "defaultValue": "null"
#       },
#       {
#         "key": "ContentInfo.ImageCover",
#         "value": "image_cover",
#         "defaultValue": "null"
#       },
#       {
#         "key": "ContentInfo.Abstract",
#         "value": "abstracts",
#         "defaultValue": "null"
#       },
#       {
#         "key": "ContentInfo.Content",
#         "value": "content",
#         "defaultValue": "null"
#       }
#     ]
#   },
#   "setEvent": [
#     {
#       "name": "click",
#       "id": "view_image_big_imageview",
#       "javascript": "$C.handle('pecct://app/openActivity?pageName=page_detail_slideshow&id=' + params.id + '&title=' + params.title);",
#       "params": [
#         {
#           "key": "id",
#           "value": "{_page.contentid}",
#           "defaultValue": ""
#         },
#         {
#           "key": "title",
#           "value": "{_widgetData.title}",
#           "defaultValue": ""
#         }
#       ]
#     }
#   ],
#   "position": [
#     {
#       "key": "parent",
#       "value": "activity_item_container_llayout",
#       "defaultValue": "null"
#     },
#     {
#       "key": "location",
#       "value": "0",
#       "defaultValue": "null"
#     },
#     {
#       "key": "insertType",
#       "value": "1",
#       "defaultValue": "null"
#     }
#   ],
#   "attr": [],
#   "configs": []
# }

