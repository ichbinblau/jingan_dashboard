# widgetTabWidget
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

$.fn["widgetTabWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	# tabview单独指定navbar
	element = $("#navbar")
	for item in element
		item._plugin_id = item._plugin_id || $.uuid()
		if  !cache[item._plugin_id]
			cache[item._plugin_id] = new widgetTabWidget(item, opt)
			tmp = cache[item._plugin_id]
		else
			cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

widgetTabWidget = (el, opts) -> 
	self = this
	this.el = el
	this.$el = $(el)
	this.current_page = opts.current_page
	self.configs = opts.configs
	self.params = $["ecParams"] self.configs.configs
	$(this.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.configs = opts.configs
	console.log "initWidget : #{opts.configs.control_id}"
	self.init( opts.configs.control_id ) if opts.configs.control_id != null
	return self

widgetTabWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	configs : null
	params : null
	init : ( control_id ) ->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype

	setData : () ->
		data = this.configs.datasource.data
		for tab in data.tabDataList
			# 添加tab
			tab.fragmentString
			content = """
				<a href="##{tab.fragmentString}" id='navbar_#{tab.fragmentString}' data-ignore-pressed="true" onclick="$.openURL('#{tab.fragmentString}')" class=''>#{tab.title}</a>
			"""
			this.$el.append $(content)
		$("#navbar>a").css("width", Math.floor(100 / data.tabDataList.length)+"%")
		# $.ui.updateNavbarElements(this.$el);
		# 设置默认界面
		url_para = location.href.split "#"
		if url_para[1]?
			console.log "urlpara1 = #{decodeURIComponent(url_para[1])}"
			$.openURL(decodeURIComponent(url_para[1]))
		else
			console.log "urlpara2"
			$("#navbar_#{data.tabDataList[0].fragmentString}").click()

# @loadTab = (div)->
# 	fragment_id = $(div).data("tabname")
# 	# console.log fragment_id
# 	$("##{fragment_id}").appPage {page_id : fragment_id}

# @openTab = () ->
# 	content = """
# 		<div title='title' id="page_fragment_activity" class="panel" data-tab="navbar_page_fragment_activity" data-load="loadTab" data-tabname="page_fragment_activity">
# 			<div id="blank_llayout"><span class='ui-icon ui-icon-loading spin'></span></div>
# 		</div>
# 	"""
# 	$.ui.addContentDiv tab.fragmentString , content , tab.title

# {
#   "control_id": "page_index_tab_TabWidget",
#   "xtype": "TabWidget",
#   "layout": "",
#   "datasource": {
#     "method": "http://abc/",
#     "data": {
#       "tabDataList": [
#         {
#           "title": "菜单",
#           "icon": "proj_tab_product",
#           "fragmentName": "ItemFragment",
#           "fragmentString": "page_fragment_tab_menu",
#           "tag": "page_fragment_tab_menu"
#         },
#         {
#           "title": "门店",
#           "icon": "proj_tab_map",
#           "fragmentName": "ItemFragment",
#           "fragmentString": "page_map_widget",
#           "tag": "page_map_widget"
#         },
#         {
#           "title": "优惠",
#           "icon": "proj_tab_youhui",
#           "fragmentName": "ItemFragment",
#           "fragmentString": "page_fragment_tab_youhui",
#           "tag": "page_fragment_tab_youhui"
#         },
#         {
#           "title": "更多",
#           "icon": "proj_tab_aboutus",
#           "fragmentName": "ItemFragment",
#           "fragmentString": "page_fragment_tab_aboutus",
#           "tag": "page_fragment_tab_aboutus"
#         },
#         {
#           "title": "智慧生活",
#           "icon": "proj_tab_myzone",
#           "fragmentName": "ItemFragment",
#           "fragmentString": "page_fragment_tab_news_detai_nofinished",
#           "tag": "page_fragment_tab_news_detai_nofinished"
#         }
#       ]
#     },
#     "params": [],
#     "adapter": []
#   },
#   "setEvent": [],
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